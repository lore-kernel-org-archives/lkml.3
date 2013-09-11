Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3ILFoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:44:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26034 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab3ILFkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:40:45 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=yIp9G3zzW4AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=E_ncOF4gu2kA:10 a=yGkY4lMGAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=pR24EIdXrMkA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=D0kxBfdW8FMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042903.928678718@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sami Rahman <sami.rahman@mmbresearch.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [069/251] USB: cp210x: add MMB and PI ZigBee USB Device Support
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0069-USB-cp210x-add-MMB-and-PI-ZigBee-USB-Device-Support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sami Rahman <sami.rahman@mmbresearch.com>

[ Upstream commit 7681156982026ebf7eafd7301eb0374d7648d068 ]

Added support for MMB Networks and Planet Innovation Ingeni ZigBee USB
devices using customized Silicon Labs' CP210x.c USB to UART bridge
drivers with PIDs: 88A4, 88A5.

Signed-off-by: Sami Rahman <sami.rahman@mmbresearch.com>
Tested-by: Sami Rahman <sami.rahman@mmbresearch.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/cp210x.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 5e64f6c..5abb19a 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -124,6 +124,8 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
+	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs factory default */
-- 
1.7.10.4


