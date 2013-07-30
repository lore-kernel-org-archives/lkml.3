Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab3G3Jlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:41:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3G3Jdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sami Rahman <sami.rahman@mmbresearch.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 079/106] USB: cp210x: add MMB and PI ZigBee USB Device Support
Date: Tue, 30 Jul 2013 10:31:38 +0100
Message-Id: <1375176725-5825-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sami Rahman <sami.rahman@mmbresearch.com>

commit 7681156982026ebf7eafd7301eb0374d7648d068 upstream.

Added support for MMB Networks and Planet Innovation Ingeni ZigBee USB
devices using customized Silicon Labs' CP210x.c USB to UART bridge
drivers with PIDs: 88A4, 88A5.

Signed-off-by: Sami Rahman <sami.rahman@mmbresearch.com>
Tested-by: Sami Rahman <sami.rahman@mmbresearch.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/cp210x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 8521468..2ab3af1 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -125,6 +125,8 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
+	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs factory default */
-- 
1.8.3.2

