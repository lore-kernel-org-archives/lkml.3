Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaEZQG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:06:57 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50689 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:06:54 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/24] staging: rtl8188eu: Remove unused function rtl8188e_deinit_dm_priv()
Date: Mon, 26 May 2014 21:35:25 +0530
Message-Id: <1401120339-23667-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c     |    4 ----
 drivers/staging/rtl8188eu/include/rtl8188e_dm.h |    1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
index 4e9f797..d5cd30b 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
@@ -203,10 +203,6 @@ void rtl8188e_init_dm_priv(struct adapter *Adapter)
 	ODM_InitDebugSetting(podmpriv);
 }
 
-void rtl8188e_deinit_dm_priv(struct adapter *Adapter)
-{
-}
-
 /*  Add new function to reset the state of antenna diversity before link. */
 /*  Compare RSSI for deciding antenna */
 void AntDivCompare8188E(struct adapter *Adapter, struct wlan_bssid_ex *dst, struct wlan_bssid_ex *src)
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_dm.h b/drivers/staging/rtl8188eu/include/rtl8188e_dm.h
index 97a3175..5e0ac31 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_dm.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_dm.h
@@ -51,7 +51,6 @@ struct	dm_priv {
 };
 
 void rtl8188e_init_dm_priv(struct adapter *adapt);
-void rtl8188e_deinit_dm_priv(struct adapter *adapt);
 void rtl8188e_InitHalDm(struct adapter *adapt);
 void rtl8188e_HalDmWatchDog(struct adapter *adapt);
 
-- 
1.7.10.4

