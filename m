Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaJOIjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 04:39:08 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53042 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaJOIjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 04:39:06 -0400
From: Will Sheppard <wsheppard@embedded-bits.co.uk>
To: linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        Will Sheppard <wsheppard@embedded-bits.co.uk>
Subject: [PATCH] mfd: arizona-spi: Add lines after declarations - checkpatch catch
Date: Wed, 15 Oct 2014 09:38:47 +0100
Message-Id: <1413362327-17378-1-git-send-email-wsheppard@embedded-bits.co.uk>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was found whilst running checkpatch.pl on arizona-spi.

WARNING: Missing a blank line after declarations
+       struct arizona *arizona = spi_get_drvdata(spi);
+       arizona_dev_exit(arizona);

Signed-off-by: Will Sheppard <wsheppard@embedded-bits.co.uk>
---
 drivers/mfd/arizona-spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
index 5145d78..8ef58bc 100644
--- a/drivers/mfd/arizona-spi.c
+++ b/drivers/mfd/arizona-spi.c
@@ -75,7 +75,9 @@ static int arizona_spi_probe(struct spi_device *spi)
 static int arizona_spi_remove(struct spi_device *spi)
 {
 	struct arizona *arizona = spi_get_drvdata(spi);
+
 	arizona_dev_exit(arizona);
+
 	return 0;
 }
 
-- 
1.8.5.2

