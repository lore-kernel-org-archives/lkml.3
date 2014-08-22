Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaHVJ12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:27:28 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56586 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaHVJ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:27:26 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] sound: tegra: tegra_asoc_utils.h: Fix typo in include guard
Date: Fri, 22 Aug 2014 11:27:07 +0200
Message-Id: <1408699627-7364-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 sound/soc/tegra/tegra_asoc_utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra_asoc_utils.h b/sound/soc/tegra/tegra_asoc_utils.h
index 9577121..ca80376 100644
--- a/sound/soc/tegra/tegra_asoc_utils.h
+++ b/sound/soc/tegra/tegra_asoc_utils.h
@@ -21,7 +21,7 @@
  */
 
 #ifndef __TEGRA_ASOC_UTILS_H__
-#define __TEGRA_ASOC_UTILS_H_
+#define __TEGRA_ASOC_UTILS_H__
 
 struct clk;
 struct device;
-- 
1.9.2

