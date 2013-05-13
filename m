Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3EMKnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:43:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:27377 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3EMKnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:43:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,660,1363158000"; 
   d="scan'208";a="240707395"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 3/3] spi/pxa2xx: add Intel BayTrail ACPI ID
Date: Mon, 13 May 2013 13:45:11 +0300
Message-Id: <1368441911-6562-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368441911-6562-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1368441911-6562-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel BayTrail has one general purpose SPI controller that is compatible
with Intel Low Power Subsystem SPI. The controller is enumerated from ACPI
namespace with ACPI ID 80860F0E.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index d20b31a..f669953 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1089,6 +1089,7 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 static struct acpi_device_id pxa2xx_spi_acpi_match[] = {
 	{ "INT33C0", 0 },
 	{ "INT33C1", 0 },
+	{ "80860F0E", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, pxa2xx_spi_acpi_match);
-- 
1.7.10.4

