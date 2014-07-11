Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaGKMiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:38:11 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:47474 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaGKMiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:38:10 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, spk.linux@gmail.com
Subject: [PATCH 1/1] mfd: tps65912-spi: Remove unused variable
Date: Fri, 11 Jul 2014 18:04:20 +0530
Message-Id: <1405082060-30454-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

‘rx_buf’ is not used in this function.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/mfd/tps65912-spi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65912-spi.c b/drivers/mfd/tps65912-spi.c
index 69a5178bf152..de60ad98bd9f 100644
--- a/drivers/mfd/tps65912-spi.c
+++ b/drivers/mfd/tps65912-spi.c
@@ -32,10 +32,9 @@ static int tps65912_spi_write(struct tps65912 *tps65912, u8 addr,
 	unsigned long spi_data = 1 << 23 | addr << 15 | *data;
 	struct spi_transfer xfer;
 	struct spi_message msg;
-	u32 tx_buf, rx_buf;
+	u32 tx_buf;
 
 	tx_buf = spi_data;
-	rx_buf = 0;
 
 	xfer.tx_buf	= &tx_buf;
 	xfer.rx_buf	= NULL;
-- 
1.7.9.5

