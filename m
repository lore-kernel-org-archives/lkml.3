Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3LRWMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:12:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3LRVL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:11:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Nol=20 "Mag" =20Archinova?= <magissia@magissia.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 02/78] Input: xpad - add signature for Razer Onza Classic Edition
Date: Wed, 18 Dec 2013 13:10:30 -0800
Message-Id: <20131218211111.974025060@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mag <magissia@magissia.com>

commit ed06349fe8d12dcb718984862b6e839fc8606c34 upstream.

Signed-off-by: Nol "Mag" Archinova <magissia@magissia.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -167,6 +167,7 @@ static const struct xpad_device {
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x146b, 0x0601, "BigBen Interactive XBOX 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfd00, "Razer Onza Tournament Edition", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
+	{ 0x1689, 0xfd01, "Razer Onza Classic Edition", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0xf016, "Mad Catz Xbox 360 Controller", 0, XTYPE_XBOX360 },


