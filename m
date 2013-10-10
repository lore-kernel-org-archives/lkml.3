Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3JJVAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:00:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57123 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755947Ab3JJVAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:00:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Sujith Thomas <sujith.thomas@intel.com>
Subject: [PATCH] MAINTAINERS / ACPI: Update links to the Linux-ACPI project web page
Date: Thu, 10 Oct 2013 23:12:01 +0200
Message-ID: <2537172.WAToVyMzMe@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The Linux-ACPI project web page is now hosted by 01.org, so update
MAINTAINERS to reflect that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-pm/MAINTAINERS
===================================================================
--- linux-pm.orig/MAINTAINERS
+++ linux-pm/MAINTAINERS
@@ -270,21 +270,21 @@ F:	include/acpi/
 ACPI FAN DRIVER
 M:	Zhang Rui <rui.zhang@intel.com>
 L:	linux-acpi@vger.kernel.org
-W:	http://www.lesswatts.org/projects/acpi/
+W:	https://01.org/linux-acpi
 S:	Supported
 F:	drivers/acpi/fan.c
 
 ACPI THERMAL DRIVER
 M:	Zhang Rui <rui.zhang@intel.com>
 L:	linux-acpi@vger.kernel.org
-W:	http://www.lesswatts.org/projects/acpi/
+W:	https://01.org/linux-acpi
 S:	Supported
 F:	drivers/acpi/*thermal*
 
 ACPI VIDEO DRIVER
 M:	Zhang Rui <rui.zhang@intel.com>
 L:	linux-acpi@vger.kernel.org
-W:	http://www.lesswatts.org/projects/acpi/
+W:	https://01.org/linux-acpi
 S:	Supported
 F:	drivers/acpi/video.c
 
@@ -4353,7 +4353,7 @@ F:	drivers/video/i810/
 INTEL MENLOW THERMAL DRIVER
 M:	Sujith Thomas <sujith.thomas@intel.com>
 L:	platform-driver-x86@vger.kernel.org
-W:	http://www.lesswatts.org/projects/acpi/
+W:	https://01.org/linux-acpi
 S:	Supported
 F:	drivers/platform/x86/intel_menlow.c
 

