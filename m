Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3GHS3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:29:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57145 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3GHS3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:29:06 -0400
Message-ID: <1373308135.12543.6.camel@ubuntu>
Subject: [PATCH 01/01] Drivers: MMB and PI ZigBee USB Device Support in
 cp210x.c
From: Sami Rahman <sami.rahman@mmbresearch.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        alireza.motamed@mmbresearch.com, software@mmbresearch.com
Date: Mon, 08 Jul 2013 14:28:55 -0400
Organization: MMB Networks
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Rahman <sami.rahman@mmbresearch.com>

Kernel Version: 3.5.0-34-generic
Added support for MMB Networks and Planet Innovation Ingeni ZigBee USB devices using customized Silicon Labs' CP210x.c USB to UART bridge drivers with PIDs: 88A4, 88A5. 

Signed-off-by: Sami Rahman <sami.rahman@mmbresearch.com>
Tested-by: Sami Rahman <sami.rahman@mmbresearch.com>

---

--- linux-source-3.5.0/drivers/usb/serial/cp210x.c.orig	2013-07-05 11:55:58.000000000 -0400
+++ linux-source-3.5.0/drivers/usb/serial/cp210x.c	2013-07-05 12:12:19.000000000 -0400
@@ -122,6 +122,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x85EB) }, /* AC-Services CIS-IBUS */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
+	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs factory default */


