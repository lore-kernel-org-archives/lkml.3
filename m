Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaJCRRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 13:17:34 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61446 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJCRRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 13:17:30 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        tiwai@suse.de
Cc: joe@perches.com, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] ASoC: da732x: Remove unnecessary KERN_ERR in pr_err()
Date: Sat,  4 Oct 2014 02:17:08 +0900
Message-Id: <1412356628-10818-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.1.273.g97b8860
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary KERN_ERR in pr_err().

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/soc/codecs/da732x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/da732x.c b/sound/soc/codecs/da732x.c
index f35e83e..61b2f9a 100644
--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -216,7 +216,7 @@ static void da732x_set_charge_pump(struct snd_soc_codec *codec, int state)
 		snd_soc_write(codec, DA732X_REG_CP_CTRL1, DA723X_CP_DIS);
 		break;
 	default:
-		pr_err(KERN_ERR "Wrong charge pump state\n");
+		pr_err("Wrong charge pump state\n");
 		break;
 	}
 }
-- 
2.1.1.273.g97b8860

