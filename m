Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaJOLGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:06:18 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:56065 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaJOLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:05:59 -0400
From: Tommi Rantala <tt.rantala@gmail.com>
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 2/2] Input: xpad - add Thrustmaster as Xbox 360 controller vendor
Date: Wed, 15 Oct 2014 14:04:36 +0300
Message-Id: <1413371076-12390-2-git-send-email-tt.rantala@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413371076-12390-1-git-send-email-tt.rantala@gmail.com>
References: <1413371076-12390-1-git-send-email-tt.rantala@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Thrustmaster as Xbox 360 controller vendor. This is required for
example to make the GP XID (044f:b326) gamepad work.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index cee4fe3..2ed7905 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -293,6 +293,7 @@ static const signed short xpad_abs_triggers[] = {
 
 static struct usb_device_id xpad_table[] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
+	XPAD_XBOX360_VENDOR(0x044f),		/* Thrustmaster X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
-- 
1.9.3

