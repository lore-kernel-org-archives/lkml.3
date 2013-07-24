Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3GXOPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:15:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab3GXOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg KH" <gregkh@linuxfoundation.org>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.257952240@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [84/85] MAINTAINERS: Greg's suse email address is dead
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Greg KH <gregkh@linuxfoundation.org>

commit 879a5a001b62a020e074d460b3a7c0fd993f9832 upstream.

My email address has changed, the suse.de one is now dead, so update all
of my MAINTAINER entries with the correct one so that patches don't get
lost.

Also change the status of some of my entries as I'm supposed to be doing
this stuff now for real.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 MAINTAINERS | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -159,7 +159,7 @@ S:	Maintained
 F:	drivers/net/ethernet/realtek/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
 S:	Maintained
@@ -1781,9 +1781,9 @@ X:	net/wireless/wext*
 
 CHAR and MISC DRIVERS
 M:	Arnd Bergmann <arnd@arndb.de>
-M:	Greg Kroah-Hartman <greg@kroah.com>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
-S:	Maintained
+S:	Supported
 F:	drivers/char/*
 F:	drivers/misc/*
 
@@ -2315,7 +2315,7 @@ F:	lib/lru_cache.c
 F:	Documentation/blockdev/drbd/
 
 DRIVER CORE, KOBJECTS, DEBUGFS AND SYSFS
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git
 S:	Supported
 F:	Documentation/kobject.txt
@@ -6257,15 +6257,15 @@ S:	Maintained
 F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
-M:	Greg Kroah-Hartman <greg@kroah.com>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	stable@vger.kernel.org
-S:	Maintained
+S:	Supported
 
 STAGING SUBSYSTEM
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
 L:	devel@driverdev.osuosl.org
-S:	Maintained
+S:	Supported
 F:	drivers/staging/
 
 STAGING - AGERE HERMES II and II.5 WIRELESS DRIVERS
@@ -6654,8 +6654,8 @@ S:	Maintained
 K:	^Subject:.*(?i)trivial
 
 TTY LAYER
-M:	Greg Kroah-Hartman <gregkh@suse.de>
-S:	Maintained
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
 F:	drivers/tty/*
 F:	drivers/tty/serial/serial_core.c
@@ -6943,7 +6943,7 @@ S:	Maintained
 F:	drivers/usb/serial/digi_acceleport.c
 
 USB SERIAL DRIVER
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	Documentation/usb/usb-serial.txt
@@ -6958,9 +6958,8 @@ S:	Maintained
 F:	drivers/usb/serial/empeg.c
 
 USB SERIAL KEYSPAN DRIVER
-M:	Greg Kroah-Hartman <greg@kroah.com>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-usb@vger.kernel.org
-W:	http://www.kroah.com/linux/
 S:	Maintained
 F:	drivers/usb/serial/*keyspan*
 
@@ -6988,7 +6987,7 @@ F:	Documentation/video4linux/sn9c102.txt
 F:	drivers/media/video/sn9c102/
 
 USB SUBSYSTEM
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
@@ -7075,7 +7074,7 @@ F:	fs/hppfs/
 
 USERSPACE I/O (UIO)
 M:	"Hans J. Koch" <hjk@hansjkoch.de>
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 S:	Maintained
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/

