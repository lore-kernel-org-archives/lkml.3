Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab3KLKL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:11:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:41561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab3KLKL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:11:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433777808"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] spi/pxa2xx: add new ACPI IDs
Date: Tue, 12 Nov 2013 12:06:21 +0200
Message-Id: <1384250781-11789-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Intel PCHs with LPSS have the same SPI controllers than Haswell but
ACPI IDs are different. Add these IDs to the driver list.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index c1a50674c1e3..28361f7783cd 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1077,6 +1077,8 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 static struct acpi_device_id pxa2xx_spi_acpi_match[] = {
 	{ "INT33C0", 0 },
 	{ "INT33C1", 0 },
+	{ "INT3430", 0 },
+	{ "INT3431", 0 },
 	{ "80860F0E", 0 },
 	{ },
 };
-- 
1.8.4.2

