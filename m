Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878Ab3BHBMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:12:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759491Ab3BHA5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [ 22/34] USB: qcserial: add Telit Gobi QDL device
Date: Thu,  7 Feb 2013 16:57:18 -0800
Message-Id: <20130208004631.025705413@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 78796ae17eacedcdcaaeb03ba73d2e532a4c8f83 upstream.

Add VID and PID for Telit Gobi QDL device

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -53,6 +53,7 @@ static const struct usb_device_id id_tab
 	{DEVICE_G1K(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
+	{DEVICE_G1K(0x1bc7, 0x900e)},	/* Telit Gobi QDL device */
 
 	/* Gobi 2000 devices */
 	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi 2000 QDL device */


