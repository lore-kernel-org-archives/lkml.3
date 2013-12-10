Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3LJIMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:12:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3LJICN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 43/62] spi/pxa2xx: add new ACPI IDs
Date: Tue, 10 Dec 2013 00:01:14 -0800
Message-Id: <20131210080100.452898258@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 54acbd9688e6324470671525c7916011f1ff8081 upstream.

Newer Intel PCHs with LPSS have the same SPI controllers than Haswell but
ACPI IDs are different. Add these IDs to the driver list.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-pxa2xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1077,6 +1077,8 @@ pxa2xx_spi_acpi_get_pdata(struct platfor
 static struct acpi_device_id pxa2xx_spi_acpi_match[] = {
 	{ "INT33C0", 0 },
 	{ "INT33C1", 0 },
+	{ "INT3430", 0 },
+	{ "INT3431", 0 },
 	{ "80860F0E", 0 },
 	{ },
 };


