#include "MacXLocalServer.h"
#include "MacXLocalSocket.h"
#include "MacXLocalServerPrivate.h"
#include "Protocol.h"
#include "megaapi.h"
#import <Cocoa/Cocoa.h>

using namespace mega;

MacXLocalServer::MacXLocalServer()
    :serverPrivate(new MacXLocalServerPrivate())
{
    serverPrivate->localServer = this;
}

MacXLocalServer::~MacXLocalServer()
{
    qDeleteAll(pendingConnections);
    pendingConnections.clear();
}

bool MacXLocalServer::listen(QString name)
{
    if ([serverPrivate->connection registerName:name.toNSString()] == YES)
    {
        MegaApi::log(MegaApi::LOG_LEVEL_INFO, "Shell ext server started");
        return true;
    }

    MegaApi::log(MegaApi::LOG_LEVEL_ERROR, "Error opening shell ext server");
    return false;
}

MacXLocalSocket* MacXLocalServer::nextPendingConnection()
{
    if (pendingConnections.isEmpty())
    {
        return NULL;
    }

    return pendingConnections.takeFirst();
}

bool MacXLocalServer::hasPendingConnections()
{
    return !pendingConnections.isEmpty();
}

void MacXLocalServer::appendPendingConnection(MacXLocalSocket *client)
{
    pendingConnections.append(client);
}
