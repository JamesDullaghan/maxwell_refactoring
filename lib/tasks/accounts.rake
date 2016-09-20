namespace :accounts do

  desc "Remove accounts where the email was never validated and it is over 30 days old"
  task :remove_unvalidated do
    RemoveUnvalidatedPeopleService.call!
  end
end
