Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3EMKwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:52:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:6122 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab3EMKwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:52:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,660,1363158000"; 
   d="scan'208";a="301615160"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] i2c-designware: add Intel BayTrail ACPI ID
Date: Mon, 13 May 2013 13:54:31 +0300
Message-Id: <1368442471-7582-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368442471-7582-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1368442471-7582-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the same controller as on Intel Lynxpoint but the ACPI ID is
different (8086F41). Add support for this.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 8ec9133..35b70a1 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -69,6 +69,7 @@ static int dw_i2c_acpi_configure(struct platform_device *pdev)
 static const struct acpi_device_id dw_i2c_acpi_match[] = {
 	{ "INT33C2", 0 },
 	{ "INT33C3", 0 },
+	{ "80860F41", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, dw_i2c_acpi_match);
-- 
1.7.10.4

