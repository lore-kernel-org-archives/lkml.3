Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3HaKVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 06:21:18 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59499 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3HaKVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 06:21:15 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 6/6] ACPI / processor: Remove outdated comments
Date: Sat, 31 Aug 2013 18:16:01 +0800
Message-Id: <1377944162-18574-6-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377944162-18574-1-git-send-email-hanjun.guo@linaro.org>
References: <1377944162-18574-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_get_processor_id() can be find nowhere, and the acpi id
is synchronized to APIC id when acpi_get_cpuid() is called, so
the comments can be removed.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/acpi_processor.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index d1cabe5..fa2412e 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -240,11 +240,6 @@ static int acpi_processor_get_info(struct acpi_device *device)
 			return -ENODEV;
 		}
 
-		/*
-		 * TBD: Synch processor ID (via LAPIC/LSAPIC structures) on SMP.
-		 *      >>> 'acpi_get_processor_id(acpi_id, &id)' in
-		 *      arch/xxx/acpi.c
-		 */
 		pr->acpi_id = object.processor.proc_id;
 	} else {
 		/*
-- 
1.7.9.5

