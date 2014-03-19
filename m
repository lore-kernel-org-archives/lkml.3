Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbaCSWop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:44:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51591 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755588AbaCSWon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:44:43 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, Len Brown <lenb@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] MAINTAINERS: Reorder maintainer addresses for PM and ACPI
Date: Thu, 20 Mar 2014 00:00:14 +0100
Message-ID: <1744772.yf52reTAmC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@rjwysocki.net>

For a few subsystems I am the person who actually applies patches
and people don't CC me on patch submissions, because my address is
not the first one in the given MAINTAINERS item.

Reorder PM and ACPI maintainer addresses in MAINTAINERS to make
the probability of that a bit smaller.

Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
---
 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-pm/MAINTAINERS
===================================================================
--- linux-pm.orig/MAINTAINERS
+++ linux-pm/MAINTAINERS
@@ -242,8 +242,8 @@ S:	Maintained
 F:	drivers/platform/x86/acer-wmi.c
 
 ACPI
-M:	Len Brown <lenb@kernel.org>
 M:	Rafael J. Wysocki <rjw@rjwysocki.net>
+M:	Len Brown <lenb@kernel.org>
 L:	linux-acpi@vger.kernel.org
 W:	https://01.org/linux-acpi
 Q:	https://patchwork.kernel.org/project/linux-acpi/list/
@@ -3657,8 +3657,8 @@ S:	Maintained
 F:	fs/freevxfs/
 
 FREEZER
+M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 M:	Pavel Machek <pavel@ucw.cz>
-M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	Documentation/power/freezing-of-tasks.txt
@@ -4022,8 +4022,8 @@ S:	Maintained
 F:	drivers/video/hgafb.c
 
 HIBERNATION (aka Software Suspend, aka swsusp)
+M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 M:	Pavel Machek <pavel@ucw.cz>
-M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	arch/x86/power/
@@ -8425,9 +8425,9 @@ F:	arch/sh/
 F:	drivers/sh/
 
 SUSPEND TO RAM
+M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 M:	Len Brown <len.brown@intel.com>
 M:	Pavel Machek <pavel@ucw.cz>
-M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	Documentation/power/

