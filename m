Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaGOQsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:48:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40628 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbaGOQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:48:31 -0400
From: Adithya Krishnamurthy <linux.challenge1@gmail.com>
To: omar.ramirez@copitl.com, gregkh@linuxfoundation.org,
        rashika.kheria@gmail.com, freemangordon@abv.bg,
        dan.carpenter@oracle.com, ody.guru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Adithya Krishnamurthy <linux.challenge1@gmail.com>
Subject: [PATCH] Staging:tidspbridge Fix minor checkpatch.pl warning unnecessary whitespace before a quoted newline
Date: Tue, 15 Jul 2014 22:18:19 +0530
Message-Id: <1405442900-6977-2-git-send-email-linux.challenge1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405442900-6977-1-git-send-email-linux.challenge1@gmail.com>
References: <y>
 <1405442900-6977-1-git-send-email-linux.challenge1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adithya Krishnamurthy <linux.challenge1@gmail.com>

Fixed checkpatch "WARNING: unnecessary whitespace before a quoted newline"

Signed-off-by: Adithya Krishnamurthy <linux.challenge1@gmail.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index f63dd8f..0559ab6 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -536,7 +536,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		if ((unsigned int *)ul_dsp_clk_addr != NULL) {
 			/* Get the clock rate */
 			ul_dsp_clk_rate = dsp_clk_get_iva2_rate();
-			dev_dbg(bridge, "%s: DSP clock rate (KHZ): 0x%x \n",
+			dev_dbg(bridge, "%s: DSP clock rate (KHZ): 0x%x\n",
 				__func__, ul_dsp_clk_rate);
 			(void)bridge_brd_write(dev_context,
 					       (u8 *) &ul_dsp_clk_rate,
-- 
1.7.9.5

