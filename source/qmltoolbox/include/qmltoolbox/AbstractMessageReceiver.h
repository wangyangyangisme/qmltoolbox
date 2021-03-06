
#pragma once


#include <QtCore/qglobal.h>

#include <qmltoolbox/MessageHandler.h>


class QDateTime;
class QMessageLogContext;
class QString;


namespace qmltoolbox
{


/**
*  @brief
*    Interface needed to receive messages from MessageHandler
*/
class QMLTOOLBOX_API AbstractMessageReceiver
{
public:
    /**
    *  @brief
    *    Constructor
    */
    AbstractMessageReceiver();

    /**
    *  @brief
    *    Constructor
    */
    virtual ~AbstractMessageReceiver();

    /**
    *  @brief
    *    Called by MessageHandler for each incoming message
    *
    *  @param[in] type
    *    Message type
    *  @param[in] timestamp
    *    Timestamp when the message was received
    *  @param[in] context
    *    Message context
    *  @param[in] message
    *    Message string
    */
    virtual void print(MessageHandler::MessageType type, const QDateTime & timestamp, const QString & context, const QString & message) = 0;
};


} // namespace qmltoolbox
