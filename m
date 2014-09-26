Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaIZKUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:20:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbaIZJqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 085/142] spi/pxa2xx: Add ACPI ID for Intel Braswell
Date: Fri, 26 Sep 2014 11:44:56 +0200
Message-Id: <05c1545f82f257383b7212f0d5b8bfd7c34957be.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit aca26364689e00e3b2052072424682231bdae6ae upstream.

The SPI host controller is the same as used in Baytrail, only the ACPI ID
is different so add this new ID to the list.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/spi/spi-pxa2xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 7b69e93d8448..fa28c75c6d04 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1082,6 +1082,7 @@ static struct acpi_device_id pxa2xx_spi_acpi_match[] = {
 	{ "INT3430", 0 },
 	{ "INT3431", 0 },
 	{ "80860F0E", 0 },
+	{ "8086228E", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, pxa2xx_spi_acpi_match);
-- 
2.1.0

