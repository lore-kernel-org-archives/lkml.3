Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbaJUW5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:57:03 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41721 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933503AbaJUW4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:56:43 -0400
From: Brian Vandre <bvandre@gmail.com>
To: gregkh@linuxfoundation.org, jic23@kernel.org,
        alexandre.belloni@free-electrons.com, linux-iio@vger.kernel.org,
        marex@denx.de
Cc: Brian Vandre <bvandre@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Staging: iio: adc: fix line over 80 characters
Date: Tue, 21 Oct 2014 17:56:47 -0500
Message-Id: <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1413931615.git.bvandre@gmail.com>
References: <cover.1413858979.git.bvandre@gmail.com> <cover.1413931615.git.bvandre@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the 2 checkpatch.pl warnings:
WARNING: line over 80 characters

Signed-off-by: Brian Vandre <bvandre@gmail.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 32a1926..62449a6 100644
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
@@ -513,7 +514,8 @@ static void mxs_lradc_setup_ts_pressure(struct mxs_lradc *lradc, unsigned ch1,
 	 * SoC's delay unit and start the conversion later
 	 * and automatically.
 	 */
-	mxs_lradc_reg_wrt(lradc, LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
+	mxs_lradc_reg_wrt(lradc,
+		LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
 		LRADC_DELAY_TRIGGER_DELAYS(1 << 3) | /* trigger DELAY unit#3 */
 		LRADC_DELAY_KICK |
 		LRADC_DELAY_DELAY(lradc->settling_delay), LRADC_DELAY(2));
-- 
1.9.1

