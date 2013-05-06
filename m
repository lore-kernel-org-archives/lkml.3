Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3EFJQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:16:50 -0400
Received: from smtp3.gemalto.com ([193.56.114.206]:44562 "EHLO
	smtp3.gemalto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3EFJQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:16:49 -0400
From: Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 6 May 2013 11:16:46 +0200
Subject: [PATCH] NET DRIVER: Added support for Cinterion's PLxx WWAN
 Interface
Thread-Topic: [PATCH] NET DRIVER: Added support for Cinterion's PLxx WWAN
 Interface
Thread-Index: Ac5KOm5PzwwbNsqpTr6ECZvzThVf3w==
Message-ID: <239D7A53E5B17B4BB20795A7977613A4A7EE9993A8@CROEXCFWP04.gemalto.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/drivers/net/usb/qmi_wwan.c: Added support for Cinterion's PLxx WWAN Interface by adding QMI_FIXED_INTF with Cinterion's Vendor ID as well as Product ID and WWAN Interface Number.

Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
---
patch is against linux-3.9
--- linux-3.9/drivers/net/usb/qmi_wwan.c.orig	2013-05-06 08:10:11.170034451 +0200
+++ linux-3.9/drivers/net/usb/qmi_wwan.c	2013-05-06 08:58:00.800264179 +0200
@@ -569,6 +569,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
+	{QMI_FIXED_INTF(0x1e2d, 0x12d1, 4)},	/* Cinterion PLxx */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
