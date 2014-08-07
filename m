Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaHGFmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:42:09 -0400
Received: from s87.loopia.se ([194.9.94.112]:60289 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbaHGFmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:42:07 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 1/2] [media] dvb: remove 0x prefix from decimal value in printf
Date: Wed,  6 Aug 2014 22:41:45 -0700
Message-Id: <1407390105-29277-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <20140806115607.1946e967.m.chehab@samsung.com>
References: <20140806115607.1946e967.m.chehab@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/media/dvb-frontends/mb86a16.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 9ae40ab..1f7fce7 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -115,7 +115,7 @@ static int mb86a16_read(struct mb86a16_state *state, u8 reg, u8 *val)
 	};
 	ret = i2c_transfer(state->i2c_adap, msg, 2);
 	if (ret != 2) {
-		dprintk(verbose, MB86A16_ERROR, 1, "read error(reg=0x%02x, ret=0x%i)",
+		dprintk(verbose, MB86A16_ERROR, 1, "read error(reg=0x%02x, ret=%i)",
 			reg, ret);
 
 		return -EREMOTEIO;
-- 
2.0.0.526.g5318336

