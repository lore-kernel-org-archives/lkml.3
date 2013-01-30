Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3A3MsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:48:25 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50868 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3A3MsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:48:21 -0500
From: Daniele Palmas <dnlplm@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Mork <bjorn@mork.no>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH v2] NET: qmi_wwan: add Telit LE920 support
Date: Wed, 30 Jan 2013 13:47:06 +0100
Message-Id: <1359550026-1879-1-git-send-email-dnlplm@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add VID, PID and fixed interface for Telit LE920

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
v2:
 - rebased against net tree

 drivers/net/usb/qmi_wwan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 575a583..2ca7f8e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -461,6 +461,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1199, 0x901c, 8)},    /* Sierra Wireless EM7700 */
 	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
+	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
1.7.4.1

