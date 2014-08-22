Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaHVJZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:25:21 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46924 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaHVJZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:25:20 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Support Opensource <support.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] sound: soc: da732x.h: Fix typo in include guard
Date: Fri, 22 Aug 2014 11:25:13 +0200
Message-Id: <1408699513-7318-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 sound/soc/codecs/da732x.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/da732x.h b/sound/soc/codecs/da732x.h
index 1dceafe..f586cbd 100644
--- a/sound/soc/codecs/da732x.h
+++ b/sound/soc/codecs/da732x.h
@@ -11,7 +11,7 @@
  */
 
 #ifndef __DA732X_H_
-#define __DA732X_H
+#define __DA732X_H_
 
 #include <sound/soc.h>
 
-- 
1.9.2

