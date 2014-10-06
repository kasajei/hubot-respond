# Description:
#   add hubot hear
#
# Commands:
#   hubot add hear command "hear message" - add hear command
#   hubot list hears - list up hear command
#   hubot rm hear <id> - remove hear command
#
# Author:
#   kasajei


HEARS = {}
createNewHear = (robot, command, message) ->
  id = Math.floor(Math.random() * 1000000) while !id? || HEARS[id]
  hearCommand = registerNewHear(robot, id, command, message)
  robot.brain.data.hears[id] = hearCommand.serialize()
  id

registerNewHear = (robot, id, command, message) ->
  hearCommand = new HearCommand(id, command, message)
  HEARS[id] = hearCommand

registerNewHearFromBrain = (robot, id, command, message) ->
  registerNewHear(robot, id, command, message)

handleNewHear = (robot, msg, command, message) ->
  try
    id = createNewHear robot, command, message
    msg.send "Hear #{id} created"
  catch error
    msg.send "Error: #{error}. "


module.exports = (robot) ->
  robot.brain.data.hears or= {}
  robot.brain.on 'loaded', =>
    for own id, hearCommand of robot.brain.data.hears
      registerNewHearFromBrain robot, id, hearCommand...

  # add hear
  robot.respond /(?:new|add) hear (.*) "(.*?)" *$/i, (msg) ->
    handleNewHear robot, msg, msg.match[1], msg.match[2]

  # list hears
  robot.respond /(?:list|ls) hears?/i, (msg) ->
    for id, hearCommand of HEARS
      msg.send "#{id}: #{hearCommand.command} \"#{hearCommand.message}\""

  # rm hear
  robot.respond /(?:rm|remove|del|delete) hear (\d+)/i, (msg) ->
    id = msg.match[1]
    if HEARS[id]
      delete robot.brain.data.hears[id]
      delete HEARS[id]
      msg.send "Hear #{id} deleted"
    else
      msg.send "Hear #{id} does not exist"



  # hear command
  robot.hear /(.*)/i, (msg) ->
    command = msg.match[1]
    for id, hearCommand of HEARS
      if hearCommand.command == command
        spliteMessages = hearCommand.message.split("\\n");
        for message in spliteMessages
          msg.send "#{message}"


class HearCommand
  constructor: (id, command, message) ->
    @id = id
    @command = command
    @message = message

  serialize: ->
    [@command, @message]
