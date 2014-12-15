Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaLOPVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:21:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38163 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaLOO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Hauke <mardnh@gmx.de>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 006/168] qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem
Date: Mon, 15 Dec 2014 14:24:20 +0000
Message-Id: <1418653622-21105-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Hauke <mardnh@gmx.de>

commit bb2bdeb83fb125c95e47fc7eca2a3e8f868e2a74 upstream.

Added the USB VID/PID for the HP lt4112 LTE/HSPA+ Gobi 4G Modem (Huawei me906e)

Signed-off-by: Martin Hauke <mardnh@gmx.de>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 22756db53dca..b8a82b86f909 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -780,6 +780,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a8, 8)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a9, 8)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card */
+	{QMI_FIXED_INTF(0x03f0, 0x581d, 4)},	/* HP lt4112 LTE/HSPA+ Gobi 4G Module (Huawei me906e) */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
2.1.3

