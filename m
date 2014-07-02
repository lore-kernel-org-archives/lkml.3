Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbaGBQtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:49:42 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33807 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaGBQtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:49:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/48] staging: rtl8188eu: Remove unused function rtw_hal_c2h_id_filter_ccx()
Date: Wed,  2 Jul 2014 22:17:02 +0530
Message-Id: <1404319664-8327-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c     |    5 -----
 drivers/staging/rtl8188eu/include/hal_intf.h |    4 ----
 2 files changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index 279dd0b..2faa690 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -375,8 +375,3 @@ void rtw_hal_reset_security_engine(struct adapter *adapter)
 	if (adapter->HalFunc.hal_reset_security_engine)
 		adapter->HalFunc.hal_reset_security_engine(adapter);
 }
-
-c2h_id_filter rtw_hal_c2h_id_filter_ccx(struct adapter *adapter)
-{
-	return adapter->HalFunc.c2h_id_filter_ccx;
-}
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index f7ce9de..56d5c50 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -144,8 +144,6 @@ enum hal_intf_ps_func {
 	HAL_MAX_ID,
 };
 
-typedef s32 (*c2h_id_filter)(u8 id);
-
 struct hal_ops {
 	u32	(*hal_power_on)(struct adapter *padapter);
 	u32	(*hal_init)(struct adapter *padapter);
@@ -236,7 +234,6 @@ struct hal_ops {
 
 	void (*hal_notch_filter)(struct adapter *adapter, bool enable);
 	void (*hal_reset_security_engine)(struct adapter *adapter);
-	c2h_id_filter c2h_id_filter_ccx;
 };
 
 enum rt_eeprom_type {
@@ -340,7 +337,6 @@ int rtw_hal_iol_cmd(struct adapter  *adapter, struct xmit_frame *xmit_frame,
 void rtw_hal_notch_filter(struct adapter *adapter, bool enable);
 void rtw_hal_reset_security_engine(struct adapter *adapter);
 
-c2h_id_filter rtw_hal_c2h_id_filter_ccx(struct adapter *adapter);
 void indicate_wx_scan_complete_event(struct adapter *padapter);
 u8 rtw_do_join(struct adapter *padapter);
 
-- 
1.7.10.4

