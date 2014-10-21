Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaJUCtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:49:42 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:43248 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaJUCtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:49:41 -0400
From: Brian Vandre <bvandre@gmail.com>
To: gregkh@linuxfoundation.org, jic23@kernel.org,
        alexandre.belloni@free-electrons.com, linux-iio@vger.kernel.org
Cc: Brian Vandre <bvandre@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: iio: adc: fix line over 80 characters
Date: Mon, 20 Oct 2014 21:48:48 -0500
Message-Id: <8eb45695460b1131ed1abf72700667aa98e6b5b6.1413858979.git.bvandre@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1413858979.git.bvandre@gmail.com>
References: <cover.1413858979.git.bvandre@gmail.com>
In-Reply-To: <cover.1413858979.git.bvandre@gmail.com>
References: <cover.1413858979.git.bvandre@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the checkpatch.pl warning:
WARNING: line over 80 characters

Signed-off-by: Brian Vandre <bvandre@gmail.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 32a1926..7d4b068 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -455,7 +455,8 @@ static void mxs_lradc_setup_ts_channel(struct mxs_lradc *lradc, unsigned ch)
 	 * SoC's delay unit and start the conversion later
 	 * and automatically.
 	 */
-	mxs_lradc_reg_wrt(lradc, LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
+	mxs_lradc_reg_wrt(lradc,
+		LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
 		LRADC_DELAY_TRIGGER_DELAYS(1 << 3) | /* trigger DELAY unit#3 */
 		LRADC_DELAY_KICK |
 		LRADC_DELAY_DELAY(lradc->settling_delay),
-- 
1.9.1

