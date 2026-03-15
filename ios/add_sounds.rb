require 'xcodeproj'
project_path = '/home/kal/.gemini/antigravity/scratch/Reminders/reminders_app/ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Find Runner group
runner_group = project.main_group.find_subpath(File.join('Runner'), true)

# Define the audio files
files = ['bell.wav', 'chime.wav', 'alert.wav', 'synth.wav']

# Get the Resources build phase
target = project.targets.find { |t| t.name == 'Runner' }
resources_build_phase = target.resources_build_phase

# Add files to the group and build phase
files.each do |file|
  # Avoid duplicates
  unless runner_group.files.any? { |f| f.path == file }
    puts "Adding #{file} to Xcode project..."
    file_reference = runner_group.new_file(file)
    resources_build_phase.add_file_reference(file_reference)
  else
    puts "#{file} already in project."
  end
end

project.save
puts "Successfully saved project.pbxproj"
