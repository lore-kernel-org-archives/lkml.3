Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391AbaE2RzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:55:16 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42663 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988AbaE2RzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:55:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 17/18] staging: rtl8188eu: Remove unused function declaration
Date: Thu, 29 May 2014 23:20:57 +0530
Message-Id: <1401385858-28722-17-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/usb_osintf.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/usb_osintf.h b/drivers/staging/rtl8188eu/include/usb_osintf.h
index 9de99ca..2dce3bf 100644
--- a/drivers/staging/rtl8188eu/include/usb_osintf.h
+++ b/drivers/staging/rtl8188eu/include/usb_osintf.h
@@ -29,9 +29,6 @@ extern int rtw_mc2u_disable;
 
 #define USBD_HALTED(Status) ((u32)(Status) >> 30 == 3)
 
-u8 usbvendorrequest(struct dvobj_priv *pdvobjpriv, enum bt_usb_request brequest,
-		    enum rt_usb_wvalue wvalue, u8 windex, void *data,
-		    u8 datalen, u8 isdirectionin);
 int pm_netdev_open(struct net_device *pnetdev, u8 bnormal);
 void netdev_br_init(struct net_device *netdev);
 void dhcp_flag_bcast(struct adapter *priv, struct sk_buff *skb);
-- 
1.7.10.4

