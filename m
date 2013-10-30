Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3J3SHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:07:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3J3SHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:07:32 -0400
Date: Wed, 30 Oct 2013 11:07:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] USB: Maintainers change for usb serial drivers
Message-ID: <20131030180731.GA24503@kroah.com>
References: <20131029222747.GA3072@kroah.com>
 <20131030152855.GD29813@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030152855.GD29813@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan has been conned^Wgracious in accepting the maintainership of the
USB serial drivers, especially as he's been doing all of the real work
for the past few years.

At the same time, remove a bunch of old entries for USB serial drivers
that don't make sense anymore, given that the developers are no longer
around, and individual driver maintainerships for tiny things like this
is pretty pointless.

Cc: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d3858de..c75199cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8845,61 +8845,14 @@ W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
-USB SERIAL BELKIN F5U103 DRIVER
-M:	William Greathouse <wgreathouse@smva.com>
+USB SERIAL SUBSYSTEM
+M:	Johan Hovold <jhovold@gmail.com>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
-F:	drivers/usb/serial/belkin_sa.*
-
-USB SERIAL CYPRESS M8 DRIVER
-M:	Lonnie Mendez <dignome@gmail.com>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-W:	http://geocities.com/i0xox0i
-W:	http://firstlight.net/cvs
-F:	drivers/usb/serial/cypress_m8.*
-
-USB SERIAL CYBERJACK DRIVER
-M:	Matthias Bruestle and Harald Welte <support@reiner-sct.com>
-W:	http://www.reiner-sct.de/support/treiber_cyberjack.php
-S:	Maintained
-F:	drivers/usb/serial/cyberjack.c
-
-USB SERIAL DIGI ACCELEPORT DRIVER
-M:	Peter Berger <pberger@brimson.com>
-M:	Al Borchers <alborchers@steinerpoint.com>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-F:	drivers/usb/serial/digi_acceleport.c
-
-USB SERIAL DRIVER
-M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-L:	linux-usb@vger.kernel.org
-S:	Supported
 F:	Documentation/usb/usb-serial.txt
-F:	drivers/usb/serial/generic.c
-F:	drivers/usb/serial/usb-serial.c
+F:	drivers/usb/serial/
 F:	include/linux/usb/serial.h
 
-USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
-M:	Gary Brubaker <xavyer@ix.netcom.com>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-F:	drivers/usb/serial/empeg.c
-
-USB SERIAL KEYSPAN DRIVER
-M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-F:	drivers/usb/serial/*keyspan*
-
-USB SERIAL WHITEHEAT DRIVER
-M:	Support Department <support@connecttech.com>
-L:	linux-usb@vger.kernel.org
-W:	http://www.connecttech.com
-S:	Supported
-F:	drivers/usb/serial/whiteheat*
-
 USB SMSC75XX ETHERNET DRIVER
 M:	Steve Glendinning <steve.glendinning@shawell.net>
 L:	netdev@vger.kernel.org
