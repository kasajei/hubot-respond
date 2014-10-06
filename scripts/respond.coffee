# Description:
#   add hubot respond
#
# Commands:
#   hubot add respond command "respond message" - add respond command
#   hubot list responds - list respond commands
#   hubot rm respond <id> - remove respond command
#
# Author:
#   kasajei


RESPONDS = {}
createNewRespond = (robot, command, message) ->
  id = Math.floor(Math.random() * 1000000) while !id? || RESPONDS[id]
  respondCommand = registerNewRespond(robot, id, command, message)
  robot.brain.data.responds[id] = respondCommand.serialize()
  id

registerNewRespond = (robot, id, command, message) ->
  respondCommand = new RespondCommand(id, command, message)
  RESPONDS[id] = respondCommand

registerNewRespondFromBrain = (robot, id, command, message) ->
  registerNewRespond(robot, id, command, message)

handleNewRespond = (robot, msg, command, message) ->
  try
    id = createNewRespond robot, command, message
    msg.send "Respond #{id} created"
  catch error
    msg.send "Error: #{error}. "


module.exports = (robot) ->
  robot.brain.data.responds or= {}
  robot.brain.on 'loaded', =>
    for own id, respondCommand of robot.brain.data.responds
      registerNewRespondFromBrain robot, id, respondCommand...

  # add respond
  robot.respond /(?:new|add) respond (.*) "(.*?)" *$/i, (msg) ->
    handleNewRespond robot, msg, msg.match[1], msg.match[2]

  # list responds
  robot.respond /(?:list|ls) responds?/i, (msg) ->
    for id, respondCommand of RESPONDS
      msg.send "#{id}: #{respondCommand.command} \"#{respondCommand.message}\""

  # rm respond
  robot.respond /(?:rm|remove|del|delete) respond (\d+)/i, (msg) ->
    id = msg.match[1]
    if RESPONDS[id]
      delete robot.brain.data.responds[id]
      delete RESPONDS[id]
      msg.send "Respond #{id} deleted"
    else
      msg.send "Respond #{id} does not exist"


  # respond command
  robot.respond /(.*)/i, (msg) ->
    command = msg.match[1]
    for id, respondCommand of RESPONDS
      if respondCommand.command == command
        spliteMessages = respondCommand.message.split("\\n");
        for message in spliteMessages
          msg.send "#{message}"


class RespondCommand
  constructor: (id, command, message) ->
    @id = id
    @command = command
    @message = message

  serialize: ->
    [@command, @message]