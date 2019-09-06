class Company {
    //MARK: -Properties
    var name: String
    var employees: [Employee]
    var teams: [Team]
    
    //MARK: -Initializers
    init?(name: String, employees: [Employee] = [], teams: [Team] = []) {
        if name.isEmpty {
            return nil
        }
        self.name = name
        self.employees = employees
        self.teams = teams
    }
    
    func createTeam(name: String, members: [Team.Profession: [Employee]]) {
        teams += [Team(name: name, members: members)]
    }
    
    func register(employee: Employee, teamName: String?) {
        employees.append(employee)
        //add Team
        guard let _ = teamName else { return }
        add(employee: employee, to: teamName!)
    }
    
    // MARK: -Private Interface
    private func add(employee: Employee, to team: String) {
        guard let idx = teams.firstIndex(where: { $0.name == team}) else { return }
        teams[idx].add(member: employee)
    }
}

class Employee: CustomStringConvertible {
    enum Gender {
        case man
        case woman
    }
    
    //MARK: -Properties
    var name: String
    var gender: Gender
    weak var team: Team?
    
    //MARK: -Initializers
    init(name: String, gender: Gender) {
        self.name = name
        self.gender = gender
    }
    
    //MARK: -Description
    var description: String {
        let teamName = self.team?.name ?? ""
        let str = "Hi my name is \(self.name),\n team name: \(teamName), gender: \(self.gender), profession: \(type(of: self))"
        return str
    }
}

class Developer: Employee {
    enum Platform: String {
        case iOS = "iOS"
        case Android = "Android"
        case Web = "Web"
    }
    
    //MARK: -Properties
    var platform: Platform
    
    //MARK: -Initializers
    init(name: String, gender: Gender, platform: Platform) {
        self.platform = platform
        super.init(name: name, gender: gender)
    }
    
    //MARK: -Description
    override var description: String {
        let teamName = self.team?.name ?? ""
        let str = "Hi my name is \(self.name),\n team name: \(teamName),\n gender: \(self.gender),\n profession: \(type(of: self))(\(self.platform.rawValue))"
        return str
    }
    
    func develop(project: String) -> String {
        return ""
    }
}

class Designer: Employee {
    
    //MARK: -Initializers
    override init(name: String, gender: Gender) {
        super.init(name: name, gender: gender)
    }
    
    //MARK: -Description
    override var description: String {
        let teamName = self.team?.name ?? ""
        let str = "Hi my name is \(self.name),\n team name: \(teamName),\n gender: \(self.gender),\n profession: \(type(of: self))"
        return str
    }
    
    func design(project: String) -> String {
        return ""
    }
}

class ProductManager: Employee {
    //MARK: -Properties
    var project: String
    
    //MARK: -Initializers
    init(name: String, gender: Gender, project: String = "") {
        self.project = project
        super.init(name: name, gender: gender)
    }
    
    //MARK: -Description
    override var description: String {
        let teamName = self.team?.name ?? ""
        let str = "Hi my name is \(self.name),\n team name: \(teamName),\n gender: \(self.gender),\n profession: \(type(of: self))\n project: \(self.project)"
        return str
    }
    
    func manage(project: String) -> String {
        return ""
    }
}

class Team {
    enum Profession {
        case productManager
        case designer
        case developer
        
        static func profession(for member: Employee) -> Profession? {
            switch member {
            case is ProductManager: return .productManager
            case is Developer: return .developer
            case is Designer: return .designer
            default: return nil
            }
        }
    }
    
    //MARK: -Properties
    var name: String
    var members: [Profession: [Employee]]
    
    //MARK: -Initializers
    init(name: String, members: [Profession: [Employee]]) {
        self.name = name
        self.members = members
    }
    
    func add(member: Employee) {
        guard let key = Profession.profession(for: member) else { return }
        
        var professionals = members[key] ?? []
        professionals.append(member)
        members.updateValue(professionals, forKey: key)
        member.team = self
    }
}

var company: Company! = Company(name: "PicsArt")

//MARK: -Create Teams
company.createTeam(name: "Dream Profile", members: [.developer: [], .designer: [], .productManager: []])
company.createTeam(name: "Dream Settings", members: [.developer: [], .designer: [], .productManager: []])
company.createTeam(name: "Dream Feed", members: [.developer: [], .designer: [], .productManager: []])

//MARK: -Register Employees
company.register(employee: Developer(name: "James", gender: .man, platform: .iOS), teamName: "Dream Profile")
company.register(employee: Developer(name: "Mike", gender: .man, platform: .Android), teamName: "Dream Profile")
company.register(employee: Designer(name: "Boo", gender: .woman), teamName: "Dream Profile")
company.register(employee: ProductManager(name: "Roz", gender: .woman, project: "Profile photo"), teamName: "Dream Profile")

company.register(employee: Developer(name: "Fungus", gender: .man, platform: .iOS), teamName: "Dream Settings")
company.register(employee: Developer(name: "Rex", gender: .man, platform: .iOS), teamName: "Dream Settings")
company.register(employee: Developer(name: "Woodie", gender: .woman, platform: .Android), teamName: "Dream Settings")
company.register(employee: Designer(name: "Jony", gender: .man), teamName: "Dream Settings")
company.register(employee: Designer(name: "Boo", gender: .man), teamName: "Dream Settings")
company.register(employee: ProductManager(name: "Randall", gender: .man, project: "Profile settings"), teamName: "Dream Settings")
company.register(employee: ProductManager(name: "Steve", gender: .man, project: "Account settings"), teamName: "Dream Settings")

company.register(employee: Developer(name: "Flint", gender: .man, platform: .iOS), teamName: "Dream Feed")
company.register(employee: Developer(name: "Needleman", gender: .man, platform: .Android), teamName: "Dream Feed")
company.register(employee: Developer(name: "Buzz", gender: .man, platform: .iOS), teamName: "Dream Feed")
company.register(employee: Designer(name: "Bile", gender: .man), teamName: "Dream Feed")
company.register(employee: ProductManager(name: "Pete", gender: .man, project: "Feedbacks classification"), teamName: "Dream Feed")
company.register(employee: ProductManager(name: "Henry", gender: .man, project: "Feedbacks"), teamName: "Dream Feed")

for emp in company.employees {
    print("\(emp)\n______________")
}
