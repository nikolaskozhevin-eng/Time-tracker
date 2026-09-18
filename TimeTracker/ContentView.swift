import SwiftUI

// Структура для записи времени
struct TimeEntry: Identifiable {
    let id = UUID()
    let person: String
    let date: Date
    let hours: Int
}

// Структура проекта
struct Project: Identifiable {
    let id = UUID()
    let name: String
    var entries: [TimeEntry]
}

struct ContentView: View {
    // Тестовые проекты
    @State private var projects = [
        Project(name: "KNESS APP", entries: []),
        Project(name: "Solar & BESS Dashboard", entries: [])
    ]
    
    @State private var selectedProjectID: UUID?
    @State private var currentUser = "Микола"
    let team = ["Микола", "Марго", "Даша"]

    var body: some View {
        NavigationSplitView {
            // Левая панель с проектами
            List(projects, selection: $selectedProjectID) { project in
                Label(project.name, systemImage: "folder.fill")
                    .tag(project.id)
            }
            .navigationTitle("Проєкти")
        } detail: {
            // Правая панель с деталями
            if let projectIndex = projects.firstIndex(where: { $0.id == selectedProjectID }) {
                VStack(alignment: .leading, spacing: 24) {
                    Text(projects[projectIndex].name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // Переключатель пользователей
                    Picker("Участник", selection: $currentUser) {
                        ForEach(team, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 300)

                    Text("Затрекать часы за сегодня:")
                        .font(.headline)

                    // Кнопки от 1 до 8 часов
                    HStack(spacing: 12) {
                        ForEach(1...8, id: \.self) { hour in
                            Button(action: {
                                let newEntry = TimeEntry(person: currentUser, date: Date(), hours: hour)
                                projects[projectIndex].entries.append(newEntry)
                            }) {
                                Text("\(hour)")
                                    .font(.title3)
                                    .frame(width: 44, height: 44)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                        }
                    }

                    Divider()

                    Text("Лог времени")
                        .font(.headline)

                    // Вывод статистики
                    List(projects[projectIndex].entries) { entry in
                        HStack {
                            Text(entry.person)
                                .fontWeight(.medium)
                                .frame(width: 100, alignment: .leading)
                            Text("\(entry.hours) год")
                                .foregroundColor(.secondary)
                                .frame(width: 60, alignment: .leading)
                            Text(entry.date, style: .date)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            } else {
                Text("Выберите проект из левого меню")
                    .foregroundColor(.secondary)
            }
        }
    }
}
