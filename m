Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaK0LF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:05:56 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:48831 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbaK0LFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:05:52 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH/TRIVIAL 2/4] [media] cx24117: Grammar s/if ... if/if ... is/
Date: Thu, 27 Nov 2014 12:05:44 +0100
Message-Id: <1417086346-23698-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417086346-23698-1-git-send-email-geert+renesas@glider.be>
References: <1417086346-23698-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb-frontends/cx24117.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index a6c3c9e2e89772ff..acb965ce0358b70e 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -459,7 +459,7 @@ static int cx24117_firmware_ondemand(struct dvb_frontend *fe)
 	if (state->priv->skip_fw_load)
 		return 0;
 
-	/* check if firmware if already running */
+	/* check if firmware is already running */
 	if (cx24117_readreg(state, 0xeb) != 0xa) {
 		/* Load firmware */
 		/* request the firmware, this will block until loaded */
-- 
1.9.1

