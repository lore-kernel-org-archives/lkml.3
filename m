Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaHGKhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:37:12 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:50675 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756196AbaHGKhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:37:10 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Mark Brown <broonie@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] spi: qup: Remove unnecessary initialization of local variable
Date: Thu,  7 Aug 2014 16:10:32 +0530
Message-Id: <1407408032-4561-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initialization of variable ret is unnecessary, Hence removing it.

CC: Mark Brown <broonie@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/spi/spi-qup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index c08da38..369f05c 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -430,7 +430,7 @@ static int spi_qup_transfer_one(struct spi_master *master,
 {
 	struct spi_qup *controller = spi_master_get_devdata(master);
 	unsigned long timeout, flags;
-	int ret = -EIO;
+	int ret;
 
 	ret = spi_qup_io_config(spi, xfer);
 	if (ret)
-- 
1.7.9.5

