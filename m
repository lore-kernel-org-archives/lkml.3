Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3A1PtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:49:08 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34247 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3A1PtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:49:06 -0500
From: Daniele Palmas <dnlplm@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] USB: qcserial: add Telit Gobi QDL device
Date: Mon, 28 Jan 2013 16:48:54 +0100
Message-Id: <1359388134-2853-1-git-send-email-dnlplm@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add VID and PID for Telit Gobi QDL device

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/usb/serial/qcserial.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index aa148c2..2466254 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -53,6 +53,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_G1K(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
+	{DEVICE_G1K(0x1bc7, 0x900e)},	/* Telit Gobi QDL device */
 
 	/* Gobi 2000 devices */
 	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi 2000 QDL device */
-- 
1.7.4.1

