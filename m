Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaHESFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:05:10 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:32923 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaHESFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:05:09 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: gregkh@linuxfoundation.org
Cc: navin.patidar@gmail.com, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cmroliv@gmail.com
Subject: [PATCH] staging: rtl8188eu: HalPhyRf_8188e: Fix static symbol sparse warning
Date: Tue,  5 Aug 2014 21:03:48 +0100
Message-Id: <1407269028-10673-1-git-send-email-cmroliv@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:
drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c:25:4: warning: symbol 'ODM_GetRightChnlPlaceforIQK' was not declared. Should it be static?
by making it static since it's only used once.

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index 7fa744b..d2bcc16 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -22,7 +22,7 @@
 #define		ODM_TXPWRTRACK_MAX_IDX_88E		6
 
 
-u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
+static u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
 {
 	u8	channel_all[ODM_TARGET_CHNL_NUM_2G_5G] = {
 		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
-- 
1.7.10.4

