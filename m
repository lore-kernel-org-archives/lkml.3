Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbaKRPVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:21:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbaKROJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Frank Razenberg <frank@zzattack.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/206] Input: xpad - add VID/PID for Razer Sabertooth
Date: Tue, 18 Nov 2014 15:06:36 +0100
Message-Id: <c4736877ce6ddfbefd32cac42da6524e9e0370cc.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Razenberg <frank@zzattack.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a7b447380c5c974c740437af82793e450f47304d upstream.

The xpad driver recognizes Razer Sabertooth controllers as generic xbox
controller, while it is really a 360 controller.  This patch adds pid/vid
mappings for the controller so that it is correctly recognized.

Signed-off-by: Frank Razenberg <frank@zzattack.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 995e79fa7dad..ac15b1395caf 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -170,6 +170,7 @@ static const struct xpad_device {
 	{ 0x146b, 0x0601, "BigBen Interactive XBOX 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfd00, "Razer Onza Tournament Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfd01, "Razer Onza Classic Edition", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0xf016, "Mad Catz Xbox 360 Controller", 0, XTYPE_XBOX360 },
-- 
2.1.3

