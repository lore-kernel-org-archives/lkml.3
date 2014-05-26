Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaEZQGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:06:52 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34661 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:06:48 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/24] staging: rtl8188eu: Remove unused function pointer ->dm_init
Date: Mon, 26 May 2014 21:35:24 +0530
Message-Id: <1401120339-23667-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    1 -
 drivers/staging/rtl8188eu/include/hal_intf.h      |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index f9d5558..5a22c6d 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1843,7 +1843,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->free_hal_data = &rtl8188e_free_hal_data;
 
 	pHalFunc->dm_init = &rtl8188e_init_dm_priv;
-	pHalFunc->dm_deinit = &rtl8188e_deinit_dm_priv;
 
 	pHalFunc->read_chip_version = &rtl8188e_read_chip_version;
 
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index a8f25c9..c59fccd 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -166,7 +166,6 @@ struct hal_ops {
 	void	(*DeInitSwLeds)(struct adapter *padapter);
 
 	void	(*dm_init)(struct adapter *padapter);
-	void	(*dm_deinit)(struct adapter *padapter);
 	void	(*read_chip_version)(struct adapter *padapter);
 
 	void	(*init_default_value)(struct adapter *padapter);
-- 
1.7.10.4

