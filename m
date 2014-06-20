Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbaFTPD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:03:28 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59460 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaFTPDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:24 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 23/41] staging: rtl8188eu: Remove unused function Efuse_PgPacketWrite_BT()
Date: Fri, 20 Jun 2014 20:29:29 +0530
Message-Id: <1403276387-11841-24-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c   |    9 ---------
 drivers/staging/rtl8188eu/include/hal_intf.h |    3 ---
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 9321546..f2ca6d4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -221,15 +221,6 @@ u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data, bool pseudo)
 	return result;
 }
 
-static int Efuse_PgPacketWrite_BT(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *data, bool pseudo)
-{
-	int ret;
-
-	ret =  pAdapter->HalFunc.Efuse_PgPacketWrite_BT(pAdapter, offset, word_en, data, pseudo);
-
-	return ret;
-}
-
 /*-----------------------------------------------------------------------------
  * Function:	efuse_WordEnableDataRead
  *
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index cacf9df..a86b3f8 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -233,9 +233,6 @@ struct hal_ops {
 			       enum rf_radio_path eRFPath, u32 RegAddr,
 			       u32 BitMask, u32 Data);
 
-	bool	(*Efuse_PgPacketWrite_BT)(struct adapter *padapter, u8 offset,
-					  u8 word_en, u8 *data, bool test);
-
 	void (*sreset_init_value)(struct adapter *padapter);
 	u8 (*sreset_get_wifi_status)(struct adapter *padapter);
 
-- 
1.7.10.4

