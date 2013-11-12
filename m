Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3KLJsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:48:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:30431 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab3KLJsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:48:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407367738"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / LPSS: add ACPI IDs for newer Intel PCHs
Date: Tue, 12 Nov 2013 11:48:19 +0200
Message-Id: <1384249699-9493-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some recent Intel PCHs with LPSS have different ACPI IDs for the LPSS
devices, so add these to the list as well.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index fb78bb9ad8f6..242885715331 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -157,6 +157,15 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
 	{ "INT33B2", },
 
+	{ "INT3430", (unsigned long)&lpt_dev_desc },
+	{ "INT3431", (unsigned long)&lpt_dev_desc },
+	{ "INT3432", (unsigned long)&lpt_dev_desc },
+	{ "INT3433", (unsigned long)&lpt_dev_desc },
+	{ "INT3434", (unsigned long)&lpt_uart_dev_desc },
+	{ "INT3435", (unsigned long)&lpt_uart_dev_desc },
+	{ "INT3436", (unsigned long)&lpt_sdio_dev_desc },
+	{ "INT3437", },
+
 	{ }
 };
 
-- 
1.8.4.2

