Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaJIVxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:53:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaJIVDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Nico Baggus <nico-linux@noci.xs4all.nl>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 009/163] rtlwifi: rtl8192cu: Add new ID
Date: Thu,  9 Oct 2014 14:00:34 -0700
Message-Id: <1412888588-26755-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit c66517165610b911e4c6d268f28d8c640832dbd1 upstream.

The Sitecom WLA-2102 adapter uses this driver.

Reported-by: Nico Baggus <nico-linux@noci.xs4all.nl>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Nico Baggus <nico-linux@noci.xs4all.nl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index c613110..f583167 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -317,6 +317,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
 	{RTL_USB_DEVICE(0x0bda, 0x5088, rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
 	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x0070, rtl92cu_hal_cfg)}, /*Sitecom - 150N */
 	{RTL_USB_DEVICE(0x0df6, 0x0077, rtl92cu_hal_cfg)}, /*Sitecom-WLA2100V2*/
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
 	{RTL_USB_DEVICE(0x4856, 0x0091, rtl92cu_hal_cfg)}, /*NetweeN - Feixun*/
-- 
1.9.1

