Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaK0JWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:22:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:41185 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbaK0Iq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:26 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Nico Baggus <nico-linux@noci.xs4all.nl>,
        "John W. Linville" <linville@tuxdriver.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 13/91] rtlwifi: rtl8192cu: Add new ID
Date: Thu, 27 Nov 2014 16:41:56 +0800
Message-Id: <1417077794-9299-13-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit c66517165610b911e4c6d268f28d8c640832dbd1 upstream.

The Sitecom WLA-2102 adapter uses this driver.

Reported-by: Nico Baggus <nico-linux@noci.xs4all.nl>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Nico Baggus <nico-linux@noci.xs4all.nl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 52a9c33..2c4cdce 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -306,6 +306,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
 	{RTL_USB_DEVICE(0x0bda, 0x5088, rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
 	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x0070, rtl92cu_hal_cfg)}, /*Sitecom - 150N */
 	{RTL_USB_DEVICE(0x0df6, 0x0077, rtl92cu_hal_cfg)}, /*Sitecom-WLA2100V2*/
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
 	{RTL_USB_DEVICE(0x4856, 0x0091, rtl92cu_hal_cfg)}, /*NetweeN - Feixun*/
-- 
1.9.1

