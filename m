Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3EXKkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:40:06 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51422 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab3EXKjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:39:42 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 5/6] ASoC: ux500: Add missing mop500_ab8500.h include
Date: Fri, 24 May 2013 12:39:19 +0200
Message-Id: <1369391960-27320-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1369391960-27320-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369391960-27320-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing include that was resulting in some sparse warning for
non-static structure without forward declaration.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/ux500/mop500_ab8500.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/ux500/mop500_ab8500.c b/sound/soc/ux500/mop500_ab8500.c
index 884a362..5e0f146 100644
--- a/sound/soc/ux500/mop500_ab8500.c
+++ b/sound/soc/ux500/mop500_ab8500.c
@@ -24,6 +24,7 @@
 
 #include "ux500_pcm.h"
 #include "ux500_msp_dai.h"
+#include "mop500_ab8500.h"
 #include "../codecs/ab8500-codec.h"
 
 #define TX_SLOT_MONO	0x0008
-- 
1.8.2

