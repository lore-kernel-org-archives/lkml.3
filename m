Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaGLTRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 15:17:17 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:35217 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaGLTRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 15:17:15 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: adc: ad7192: fix coding style
Date: Sat, 12 Jul 2014 21:16:49 +0200
Message-Id: <1405192609-24652-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line over 80 characters. This is for Eudyptula Challenge.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/staging/iio/adc/ad7192.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/ad7192.c b/drivers/staging/iio/adc/ad7192.c
index 83bb44b..c25c9ab 100644
--- a/drivers/staging/iio/adc/ad7192.c
+++ b/drivers/staging/iio/adc/ad7192.c
@@ -223,7 +223,8 @@ static int ad7192_setup(struct ad7192_state *st,
 	id &= AD7192_ID_MASK;
 
 	if (id != st->devid)
-		dev_warn(&st->sd.spi->dev, "device ID query failed (0x%X)\n", id);
+		dev_warn(&st->sd.spi->dev,
+			"device ID query failed (0x%X)\n", id);
 
 	switch (pdata->clock_source_sel) {
 	case AD7192_CLK_EXT_MCLK1_2:
-- 
2.0.0.rc0

