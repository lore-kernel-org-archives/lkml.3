Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab3CIKXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 05:23:15 -0500
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:52368 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab3CIKXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 05:23:13 -0500
X-Greylist: delayed 1484 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Mar 2013 05:23:13 EST
Date: Sat, 9 Mar 2013 13:57:32 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: gregkh@linuxfoundation.org
cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: cp210x new Vendor/Device IDs
Message-ID: <alpine.LRH.2.00.1303091354020.20326@lnfm1.sai.msu.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matwey V. Kornilov <matwey@sai.msu.ru>

This patch adds support for the Lake Shore Cryotronics devices to
the CP210x driver.

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
These lines are ported from cp210x driver distributed by Lake Shore web site:
   http://www.lakeshore.com/Documents/Lake%20Shore%20cp210x-3.0.0.tar.gz
and licensed under the terms of GPLv2.

Moreover, I've tested this changes with Lake Shore 335 in my labs.

This patch is based on linux/kernel/git/gregkh/usb.git tree.

p.s Sorry for 80-column overflow, but I don't know how to format this comments
more concinnous.

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index edc0f0d..67088ce 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -150,6 +150,25 @@ static const struct usb_device_id id_table[] = {
  	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
  	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
  	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
+	{ USB_DEVICE(0x1FB9, 0x0100) }, /* Lake Shore Model 121 Current Source */
+	{ USB_DEVICE(0x1FB9, 0x0200) }, /* Lake Shore Model 218A Temperature Monitor */
+	{ USB_DEVICE(0x1FB9, 0x0201) }, /* Lake Shore Model 219 Temperature Monitor */
+	{ USB_DEVICE(0x1FB9, 0x0202) }, /* Lake Shore Model 233 Temperature Transmitter */
+	{ USB_DEVICE(0x1FB9, 0x0203) }, /* Lake Shore Model 235 Temperature Transmitter */
+	{ USB_DEVICE(0x1FB9, 0x0300) }, /* Lake Shore Model 335 Temperature Controller */
+	{ USB_DEVICE(0x1FB9, 0x0301) }, /* Lake Shore Model 336 Temperature Controller */
+	{ USB_DEVICE(0x1FB9, 0x0302) }, /* Lake Shore Model 350 Temperature Controller */
+	{ USB_DEVICE(0x1FB9, 0x0303) }, /* Lake Shore Model 371 AC Bridge */
+	{ USB_DEVICE(0x1FB9, 0x0400) }, /* Lake Shore Model 411 Handheld Gaussmeter */
+	{ USB_DEVICE(0x1FB9, 0x0401) }, /* Lake Shore Model 425 Gaussmeter */
+	{ USB_DEVICE(0x1FB9, 0x0402) }, /* Lake Shore Model 455A Gaussmeter */
+	{ USB_DEVICE(0x1FB9, 0x0403) }, /* Lake Shore Model 475A Gaussmeter */
+	{ USB_DEVICE(0x1FB9, 0x0404) }, /* Lake Shore Model 465 Three Axis Gaussmeter */
+	{ USB_DEVICE(0x1FB9, 0x0600) }, /* Lake Shore Model 625A Superconducting MPS */
+	{ USB_DEVICE(0x1FB9, 0x0601) }, /* Lake Shore Model 642A Magnet Power Supply */
+	{ USB_DEVICE(0x1FB9, 0x0602) }, /* Lake Shore Model 648 Magnet Power Supply */
+	{ USB_DEVICE(0x1FB9, 0x0700) }, /* Lake Shore Model 737 VSM Controller */
+	{ USB_DEVICE(0x1FB9, 0x0701) }, /* Lake Shore Model 776 Hall Matrix */
  	{ USB_DEVICE(0x3195, 0xF190) }, /* Link Instruments MSO-19 */
  	{ USB_DEVICE(0x3195, 0xF280) }, /* Link Instruments MSO-28 */
  	{ USB_DEVICE(0x3195, 0xF281) }, /* Link Instruments MSO-28 */
