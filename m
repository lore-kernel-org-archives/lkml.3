Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3JWJIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:08:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab3JWJIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:08:43 -0400
Date: Wed, 23 Oct 2013 11:08:36 +0200
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zwane Mwaikambo <zwanem@gmail.com>
Subject: [PATCH] Update Zwane Mwaikambo's e-mail address
Message-ID: <20131023110836.4690aba7@endymion.delvare>
Organization: Suse Linux
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zwane Mwaikambo's @arm.linux.org.uk address no longer works. In
February 2013 he asked for his gmail address to be used instead [1] so
let's just do that.

[1] http://marc.info/?l=linux-kernel&m=136079068903214&w=2

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Zwane Mwaikambo <zwanem@gmail.com>
---
 CREDITS                       |    2 +-
 Documentation/cpu-hotplug.txt |    2 +-
 MAINTAINERS                   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-3.12-rc6.orig/CREDITS	2013-09-30 08:47:53.797076563 +0200
+++ linux-3.12-rc6/CREDITS	2013-10-23 11:02:04.531400675 +0200
@@ -2576,7 +2576,7 @@ S: Toronto, Ontario
 S: Canada
 
 N: Zwane Mwaikambo
-E: zwane@arm.linux.org.uk
+E: zwanem@gmail.com
 D: Various driver hacking
 D: Lowlevel x86 kernel hacking
 D: General debugging
--- linux-3.12-rc6.orig/Documentation/cpu-hotplug.txt	2013-09-24 00:41:09.000000000 +0200
+++ linux-3.12-rc6/Documentation/cpu-hotplug.txt	2013-10-23 11:02:09.641511953 +0200
@@ -5,7 +5,7 @@
 			Rusty Russell <rusty@rustcorp.com.au>
 			Srivatsa Vaddagiri <vatsa@in.ibm.com>
 		i386:
-			Zwane Mwaikambo <zwane@arm.linux.org.uk>
+			Zwane Mwaikambo <zwanem@gmail.com>
 		ppc64:
 			Nathan Lynch <nathanl@austin.ibm.com>
 			Joel Schopp <jschopp@austin.ibm.com>
--- linux-3.12-rc6.orig/MAINTAINERS	2013-10-21 11:25:38.518242528 +0200
+++ linux-3.12-rc6/MAINTAINERS	2013-10-23 11:02:16.339657845 +0200
@@ -7276,7 +7276,7 @@ S:	Odd Fixes
 F:	drivers/media/usb/tlg2300/
 
 SC1200 WDT DRIVER
-M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
+M:	Zwane Mwaikambo <zwanem@gmail.com>
 S:	Maintained
 F:	drivers/watchdog/sc1200wdt.c
 


-- 
Jean Delvare
Suse L3 Support
