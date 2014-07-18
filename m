Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864AbaGRME2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:04:28 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60909 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761566AbaGRMEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:04:25 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, spk.linux@gmail.com
Subject: [PATCH Resend 2/2] mfd: tps65912-spi: Remove unused variable
Date: Fri, 18 Jul 2014 17:30:17 +0530
Message-Id: <1405684817-20171-2-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405684817-20171-1-git-send-email-sachin.kamat@samsung.com>
References: <1405684817-20171-1-git-send-email-sachin.kamat@samsung.com>
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

