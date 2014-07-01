Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbaGATLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:11:53 -0400
Received: from smtp131.dfw.emailsrvr.com ([67.192.241.131]:46528 "EHLO
	smtp131.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbaGATLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:11:47 -0400
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 15:11:46 EDT
X-Broken-By: aardmail-smtpc (http://bwachter.lart.info/projects/aardmail/)
From: Bernd Wachter <bernd.wachter@jolla.com>
To: netdev@vger.kernel.org
Subject: [PATCH] net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
X-use-pgp: no
X-personality: jolla
Tomato: Polka-dot
Importance: high
Date: Tue, 01 Jul 2014 22:01:09 +0300
Message-ID: <87vbrgewei.fsf@bwachter.lart.info>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There's a new version of the Telewell 4G modem working with, but not
recognized by this driver. 

Signed-off-by: Bernd Wachter <bernd.wachter@jolla.com>
---
--- linux-3.15.3/drivers/net/usb/qmi_wwan.c.orig	2014-07-01 21:31:07.000000000 +0300
+++ linux-3.15.3/drivers/net/usb/qmi_wwan.c	2014-07-01 20:39:30.000000000 +0300
@@ -741,6 +741,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x19d2, 0x1424, 2)},
 	{QMI_FIXED_INTF(0x19d2, 0x1425, 2)},
 	{QMI_FIXED_INTF(0x19d2, 0x1426, 2)},	/* ZTE MF91 */
+	{QMI_FIXED_INTF(0x19d2, 0x1428, 2)},	/* Telewell TW-LTE 4G v2 */
 	{QMI_FIXED_INTF(0x19d2, 0x2002, 4)},	/* ZTE (Vodafone) K3765-Z */
 	{QMI_FIXED_INTF(0x0f3d, 0x68a2, 8)},    /* Sierra Wireless MC7700 */
 	{QMI_FIXED_INTF(0x114f, 0x68a2, 8)},    /* Sierra Wireless MC7750 */

