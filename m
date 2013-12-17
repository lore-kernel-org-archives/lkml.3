Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3LQJea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:34:30 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54456 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3LQJe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:34:27 -0500
Date: Tue, 17 Dec 2013 15:04:17 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 10/11] drivers: acpi: Include appropriate header file in
 proc.c
Message-ID: <4ad729ba3e711c8acd0dab2d117e8be7bbf1bebf.1387271324.git.rashika.kheria@gmail.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file internal.h in proc.c because function
acpi_sleep_proc_init() has its prototype declaration in internal.h.

This eliminates the following warning in proc.c:
drivers/acpi/proc.c:148:12: warning: no previous prototype for ‘acpi_sleep_proc_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/acpi/proc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index 6a5b152..e8f7d36 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -9,6 +9,7 @@
 #include <acpi/acpi_drivers.h>
 
 #include "sleep.h"
+#include "internal.h"
 
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 
-- 
1.7.9.5

