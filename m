Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3DKTCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:02:54 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60921 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab3DKTCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:02:53 -0400
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] ASoC: samsung: fix neo1973-wm8753 compilation
Date: Thu, 11 Apr 2013 21:02:43 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <201304111908.42532.arnd@arndb.de> <20130411171938.GS9243@opensource.wolfsonmicro.com>
In-Reply-To: <20130411171938.GS9243@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304112102.43896.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b2ca78717cea (ARM: S3C24XX: make gta02.h local) already replaced
the GTA02_GPIO_* constants in neo1973-wm8753.c but forgot to remove the
inclusion of mach/gta02.h before moving the file out of mach/.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 sound/soc/samsung/neo1973_wm8753.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index a301d8c..68675dd 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -22,7 +22,6 @@
 
 #include <asm/mach-types.h>
 #include <plat/regs-iis.h>
-#include <mach/gta02.h>
 
 #include "../codecs/wm8753.h"
 #include "s3c24xx-i2s.h"
-- 
1.7.2.3

