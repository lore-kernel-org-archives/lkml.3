Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3FEV0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:26:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab3FEVMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:12:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Teppo Kotilainen <qubit303@gmail.com>
Subject: [ 04/44] usb: option: Add Telewell TW-LTE 4G
Date: Wed,  5 Jun 2013 14:12:02 -0700
Message-Id: <20130605211222.346901445@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Teppo Kotilainen <qubit303@gmail.com>

commit 73c042df6e1bc50544842a04b777b36bbe3630e6 upstream.

Information from driver description files:

  diag:  VID_19D2&PID_0412&MI_00
  nmea:  VID_19D2&PID_0412&MI_01
  at:    VID_19D2&PID_0412&MI_02
  modem: VID_19D2&PID_0412&MI_03
  net:   VID_19D2&PID_0412&MI_04

Signed-off-by: Teppo Kotilainen <qubit303@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -966,6 +966,8 @@ static const struct usb_device_id option
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0330, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0395, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0412, 0xff, 0xff, 0xff), /* Telewell TW-LTE 4G */
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0414, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0417, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1008, 0xff, 0xff, 0xff),


