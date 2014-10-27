Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaJ0QNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:13:39 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47317 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaJ0QNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:13:36 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        sfr@canb.auug.org.au, navin.patidar@gmail.com,
        gregkh@linuxfoundation.org
Subject: [PATCH] staging: rtl8188eu: hal: space required
Date: Mon, 27 Oct 2014 16:13:29 +0000
Message-Id: <1414426409-15212-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: space required before the open brace '{'

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/rtl8188eu/hal/bb_cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/hal/bb_cfg.c b/drivers/staging/rtl8188eu/hal/bb_cfg.c
index 80e8cc9..c2d166f 100644
--- a/drivers/staging/rtl8188eu/hal/bb_cfg.c
+++ b/drivers/staging/rtl8188eu/hal/bb_cfg.c
@@ -173,7 +173,7 @@ static bool set_baseband_agc_config(struct adapter *adapt)
 		u32 v1 = array[i];
 		u32 v2 = array[i+1];
 
-		if (v1 < 0xCDCDCDCD){
+		if (v1 < 0xCDCDCDCD) {
 			phy_set_bb_reg(adapt, v1, bMaskDWord, v2);
 			udelay(1);
 		}
-- 
1.9.1

