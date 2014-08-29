Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaH2S4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:56:53 -0400
Received: from mout.gmx.net ([212.227.17.22]:49489 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbaH2S4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:56:52 -0400
Date: Fri, 29 Aug 2014 22:56:39 +0200
From: Andreas Werner <wernerandy@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: andreas.werner@men.de, wernerandy@gmx.de
Subject: eeprom Board Information EEPROM
Message-ID: <20140829205639.GA584@awedesk.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V03:K0:p19m8az4utEbUKzsXrrAam4PiyLfVHRGCxWrHBtUeYZQGw6CTMb
 lLPg9N4EldQLos4a2E6JT86pdjmIeV2PSWJvoa6wZVh2L8XjMMJ80GoaT4/HlJoT1hDSiU+
 Y8YZ6J8OBdp5kSrhYmIphe3tERV3biuMWsuluPcshTRdUazIw0XvC1PxrHshmHD17RMiGlW
 XvyH7I0omEWPHd2Ihxmcg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question regarding a driver for a Board Information EEPROM.

I want to give our customer easy access to our Board Information EEPROM
which is an 256byte I2C eeprom.

There is a defined structure of information at the beginning of the eeprom
which includes board name, serialnumber, production date, repair date and
a eeprom structure ident number.

The rest of the eeprom is for user defined settings where customer can write
any data to.

I want to have access to the eeprom without any special to and without installing
anything just running linux and to a cat/echo to sysfs entries to read/write
data to the eeprom.

What i want to do is to create sysfs entries for the pre defined settings and
on entrie where customer can access the rest of the eeprom bytes.

Is drivers/misc/eeprom the right place to put those kind of driver in? Or are
there any other options to write those kind of driver?


Regards
Andy
