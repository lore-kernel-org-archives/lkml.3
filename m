Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab3C3Mcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:32:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3C3Mco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:32:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 5/7] USB: EHCI: make ehci-atmel a separate driver
Date: Sat, 30 Mar 2013 12:29:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>
References: <Pine.LNX.4.44L0.1303291600080.1467-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303291600080.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303301229.59504.arnd@arndb.de>
X-Provags-ID: V02:K0:jehYahzUMxdiD0m9MMlcgIAsBbRSa/NAy4XNMfXXwzi
 W2ypqGpAHitCbYKMTfz1YW0JTp1BN1val0WVU6QnBDwD/XWwpi
 62gCpQBbh8OFhdpD5ocZuW24RFxpbwLuVMYtoC+4oK/GLrjgLf
 v8yItJ6Qq+WA7s+zSWMblBsWTcDB0c8dKcqNkoJTcU2G4y2Evy
 XADv2zCfcP981Zr8SpWsAe1ROCMevjXLazfU5YFw5+YoIjhf9S
 JpoP9cD6T7/JZLmWHpEC3a4b+rrgQ0etD6Hap6uiZwzFN3Y8wl
 lDooZl6kK4bWuezES1MQRaYHwsktfFjCw97ciTZ3YmX5RoNPn0
 UvRXpkKoawr53fmOTSLU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 March 2013, Alan Stern wrote:

> While not absolutely necessary, it would be nice to have the #include 
> files in alphabetical order.
> 
> > +
> > +#include "ehci.h"
> > +
> > +#define DRIVER_DESC "EHCI atmel driver"
> 
> "atmel" should have a capital 'A'.
> 

Ok, added these changes for v4 along with Nicolas' Ack,
and removed the call to ehci_shutdown.

	Arnd
