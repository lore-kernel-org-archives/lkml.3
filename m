Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3JJVZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:25:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58199 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754847Ab3JJVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:25:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [PATCH] ACPI / PM / Documentation: Replace outdated project links and addresses
Date: Thu, 10 Oct 2013 23:37:13 +0200
Message-ID: <5673332.e1GqhHJQBY@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Some links to projects web pages and e-mail addresses in ACPI/PM
documentation and Kconfig are outdated, so update them.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/ABI/stable/sysfs-bus-usb |    8 ++++----
 Documentation/acpi/dsdt-override.txt   |    2 +-
 drivers/acpi/Kconfig                   |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-pm/Documentation/ABI/stable/sysfs-bus-usb
===================================================================
--- linux-pm.orig/Documentation/ABI/stable/sysfs-bus-usb
+++ linux-pm/Documentation/ABI/stable/sysfs-bus-usb
@@ -37,8 +37,8 @@ Description:
 		that the USB device has been connected to the machine.  This
 		file is read-only.
 Users:
-		PowerTOP <power@bughost.org>
-		http://www.lesswatts.org/projects/powertop/
+		PowerTOP <powertop@lists.01.org>
+		https://01.org/powertop/
 
 What:		/sys/bus/usb/device/.../power/active_duration
 Date:		January 2008
@@ -57,8 +57,8 @@ Description:
 		will give an integer percentage.  Note that this does not
 		account for counter wrap.
 Users:
-		PowerTOP <power@bughost.org>
-		http://www.lesswatts.org/projects/powertop/
+		PowerTOP <powertop@lists.01.org>
+		https://01.org/powertop/
 
 What:		/sys/bus/usb/devices/<busnum>-<port[.port]>...:<config num>-<interface num>/supports_autosuspend
 Date:		January 2008
Index: linux-pm/Documentation/acpi/dsdt-override.txt
===================================================================
--- linux-pm.orig/Documentation/acpi/dsdt-override.txt
+++ linux-pm/Documentation/acpi/dsdt-override.txt
@@ -4,4 +4,4 @@ CONFIG_ACPI_CUSTOM_DSDT builds the image
 
 When to use this method is described in detail on the
 Linux/ACPI home page:
-http://www.lesswatts.org/projects/acpi/overridingDSDT.php
+https://01.org/linux-acpi/documentation/overriding-dsdt
Index: linux-pm/drivers/acpi/Kconfig
===================================================================
--- linux-pm.orig/drivers/acpi/Kconfig
+++ linux-pm/drivers/acpi/Kconfig
@@ -24,7 +24,7 @@ menuconfig ACPI
 	  are configured, ACPI is used.
 
 	  The project home page for the Linux ACPI subsystem is here:
-	  <http://www.lesswatts.org/projects/acpi/>
+	  <https://01.org/linux-acpi>
 
 	  Linux support for ACPI is based on Intel Corporation's ACPI
 	  Component Architecture (ACPI CA).  For more information on the

