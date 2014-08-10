Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaHJOsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:48:11 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64378 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHJOsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:48:09 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 19/22] staging: rtl8188eu: Remove unused function iol_ioconfig()
Date: Sun, 10 Aug 2014 20:14:32 +0530
Message-Id: <1407681875-2611-19-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 16525b0..50b1332 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -99,15 +99,6 @@ s32 rtl8188e_iol_efuse_patch(struct adapter *padapter)
 	return result;
 }
 
-static s32 iol_ioconfig(struct adapter *padapter, u8 iocfg_bndy)
-{
-	s32 rst = _SUCCESS;
-
-	usb_write8(padapter, REG_TDECTRL+1, iocfg_bndy);
-	rst = iol_execute(padapter, CMD_IOCONFIG);
-	return rst;
-}
-
 #define MAX_REG_BOLCK_SIZE	196
 
 void _8051Reset88E(struct adapter *padapter)
-- 
1.7.10.4

