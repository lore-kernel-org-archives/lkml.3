Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab3BMKze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:55:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41931 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab3BMKzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:55:33 -0500
Date: Wed, 13 Feb 2013 10:55:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove obsolete email address for Zwane Mwaikambo
Message-ID: <20130213105527.GZ17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zwane's arm.linux.org.uk email address has not been functional for
a number of years now.  It's time that all references to it were
removed.  I no longer have a forwarding address for Zwane, as I had
assumed that my repeated requests over a number of years to Zwane to
avoid use of this address had been actioned.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 CREDITS                       |    1 -
 Documentation/cpu-hotplug.txt |    2 +-
 MAINTAINERS                   |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/CREDITS b/CREDITS
index 2346b09..463f0d8 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2564,7 +2564,6 @@ S: Toronto, Ontario
 S: Canada
 
 N: Zwane Mwaikambo
-E: zwane@arm.linux.org.uk
 D: Various driver hacking
 D: Lowlevel x86 kernel hacking
 D: General debugging
diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 9f40135..d03263a 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -5,7 +5,7 @@
 			Rusty Russell <rusty@rustcorp.com.au>
 			Srivatsa Vaddagiri <vatsa@in.ibm.com>
 		i386:
-			Zwane Mwaikambo <zwane@arm.linux.org.uk>
+			Zwane Mwaikambo
 		ppc64:
 			Nathan Lynch <nathanl@austin.ibm.com>
 			Joel Schopp <jschopp@austin.ibm.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 8c068f7..4089db6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6637,7 +6637,7 @@ S:	Supported
 F:	drivers/media/usb/tlg2300
 
 SC1200 WDT DRIVER
-M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
+M:	Zwane Mwaikambo
 S:	Maintained
 F:	drivers/watchdog/sc1200wdt.c
 

