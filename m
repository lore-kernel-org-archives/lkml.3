Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbaJCViR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:38:17 -0400
Received: from mail-ig0-f201.google.com ([209.85.213.201]:39587 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbaJCViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:38:12 -0400
From: Ben Zhang <benzh@chromium.org>
To: alsa-devel@alsa-project.org
Cc: Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Ben Zhang <benzh@chromium.org>
Subject: [PATCH 1/3] ASoC: rt5677: Include gpio driver header
Date: Fri,  3 Oct 2014 14:37:24 -0700
Message-Id: <1412372246-10489-1-git-send-email-benzh@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header file is needed because struct gpio_chip is
placed in struct rt5677_priv.

Signed-off-by: Ben Zhang <benzh@chromium.org>
---
 sound/soc/codecs/rt5677.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5677.h b/sound/soc/codecs/rt5677.h
index d4eb6d5..99fd023 100644
--- a/sound/soc/codecs/rt5677.h
+++ b/sound/soc/codecs/rt5677.h
@@ -13,6 +13,7 @@
 #define __RT5677_H__
 
 #include <sound/rt5677.h>
+#include <linux/gpio/driver.h>
 
 /* Info */
 #define RT5677_RESET				0x00
-- 
2.1.0.rc2.206.gedb03e5

