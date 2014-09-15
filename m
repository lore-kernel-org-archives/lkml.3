Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaIOTj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:39:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaIOTj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:39:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 066/114] spi/pxa2xx: Add ACPI ID for Intel Braswell
Date: Mon, 15 Sep 2014 12:26:06 -0700
Message-Id: <20140915192643.513025467@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit aca26364689e00e3b2052072424682231bdae6ae upstream.

The SPI host controller is the same as used in Baytrail, only the ACPI ID
is different so add this new ID to the list.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-pxa2xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1078,6 +1078,7 @@ static struct acpi_device_id pxa2xx_spi_
 	{ "INT3430", 0 },
 	{ "INT3431", 0 },
 	{ "80860F0E", 0 },
+	{ "8086228E", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, pxa2xx_spi_acpi_match);


