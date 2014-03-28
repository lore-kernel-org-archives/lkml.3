Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbaC1Aob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 20:44:31 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55018 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaC1Ao3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 20:44:29 -0400
Message-ID: <5334C5E9.5080805@gmail.com>
Date: Fri, 28 Mar 2014 00:44:25 +0000
From: paulmcquad <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paul McQuade <paulmcquad@gmail.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jw@rjwysocki.net
Subject: [PATCH 1/3] acpi: Fixed code indent errors and use linux libs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0196c4e34dd02d89833ef851c43973d81dfa4399 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Thu, 27 Mar 2014 22:55:28 +0000
Subject: [PATCH 1/3] acpi: Fixed code indent errors and use linux libs

ERROR: code indent should use tabs where possible.
Use #include <linux/cpu.h> instead of <asm/cpu.h>.

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/acpi/ac.c          | 6 +++---
 drivers/acpi/acpi_extlog.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 6f190bc..078e969 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -62,7 +62,7 @@ struct acpi_ac {
 #define to_acpi_ac(x) container_of(x, struct acpi_ac, charger)
 
 /* --------------------------------------------------------------------------
-                               AC Adapter Management
+                AC Adapter Management
    -------------------------------------------------------------------------- */
 
 static int acpi_ac_get_state(struct acpi_ac *ac)
@@ -83,7 +83,7 @@ static int acpi_ac_get_state(struct acpi_ac *ac)
 }
 
 /* --------------------------------------------------------------------------
-                            sysfs I/F
+                sysfs I/F
    -------------------------------------------------------------------------- */
 static int get_ac_property(struct power_supply *psy,
                enum power_supply_property psp,
@@ -112,7 +112,7 @@ static enum power_supply_property ac_props[] = {
 };
 
 /* --------------------------------------------------------------------------
-                                   Driver Model
+                Driver Model
    -------------------------------------------------------------------------- */
 
 static void acpi_ac_notify_handler(acpi_handle handle, u32 event, void *data)
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index c4a5d87..7d9ae65 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -12,7 +12,7 @@
 #include <linux/cper.h>
 #include <linux/ratelimit.h>
 #include <linux/edac.h>
-#include <asm/cpu.h>
+#include <linux/cpu.h>
 #include <asm/mce.h>
 
 #include "apei/apei-internal.h"
-- 
1.8.3.2

