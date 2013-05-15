Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157Ab3EONov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:44:51 -0400
Received: from smtp4.gemalto.com ([193.56.114.199]:1598 "EHLO
	smtp4.gemalto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759062Ab3EONot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:44:49 -0400
From: Schmiedl Christian <Christian.Schmiedl@gemalto.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
Date: Wed, 15 May 2013 15:44:46 +0200
Subject: [PATCH] qmi_wwan: Added support for Cinterion's PLxx WWAN Interface
Thread-Topic: [PATCH] qmi_wwan: Added support for Cinterion's PLxx WWAN
 Interface
Thread-Index: Ac5RZ6xAZh/F2lNeR0iyQk7jWAHSJQACfbaA
Message-ID: <376FB829F3ECB542B825EAF4D8CA8A97012A579993A9@CROEXCFWP03.gemalto.com>
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

/drivers/net/usb/qmi_wwan.c: Added support for Cinterion's PLxx WWAN Interface
by adding QMI_FIXED_INTF with Cinterion's Vendor ID as well as Product ID and
WWAN Interface Number.

Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
Signed-off-by: Christian Schmiedl <christian.schmiedl@gemalto.com>
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
