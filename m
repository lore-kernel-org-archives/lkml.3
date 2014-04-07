Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaDGU2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:28:16 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:42651 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaDGU2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:28:14 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v2 3/5] Staging: rts5139: Splitted one-line multiple assignment
Date: Mon,  7 Apr 2014 22:27:46 +0200
Message-Id: <1396902468-27906-4-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396902468-27906-1-git-send-email-fabio.falzoi84@gmail.com>
References: <20140407003341.GA13365@kroah.com>
 <1396902468-27906-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Splitted a multiple assignment on two separate lines.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5139/rts51x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index 28f4631..2be6210 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -607,7 +607,8 @@ static int rts51x_acquire_resources(struct rts51x_chip *chip)
 		return -ENOMEM;
 	}
 
-	chip->cmd_buf = chip->rsp_buf = rts51x->iobuf;
+	chip->cmd_buf = rts51x->iobuf;
+	chip->rsp_buf = rts51x->iobuf;
 
 	rts51x_init_options(chip);
 
-- 
1.9.1

