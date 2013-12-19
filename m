Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3LSM5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:57:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3LSL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 053/208] spi/pxa2xx: add new ACPI IDs
Date: Thu, 19 Dec 2013 11:52:31 +0000
Message-Id: <1387454106-19326-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 54acbd9688e6324470671525c7916011f1ff8081 upstream.

Newer Intel PCHs with LPSS have the same SPI controllers than Haswell but
ACPI IDs are different. Add these IDs to the driver list.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi-pxa2xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index f440dce..46e481f 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1071,6 +1071,8 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 static struct acpi_device_id pxa2xx_spi_acpi_match[] = {
 	{ "INT33C0", 0 },
 	{ "INT33C1", 0 },
+	{ "INT3430", 0 },
+	{ "INT3431", 0 },
 	{ "80860F0E", 0 },
 	{ },
 };
-- 
1.8.3.2

