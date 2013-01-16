Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab3APLJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:09:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53068 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3APLJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:09:54 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: fsi: Remove __devinitconst
Date: Wed, 16 Jan 2013 12:09:45 +0100
Message-Id: <1358334585-25046-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
X-Provags-ID: V02:K0:fMeu0JWbF8ln/RSGP0IWxLQQf2yXXcvLwJ44Ja5bCdA
 Gv1cXYvqW3Q3C1C3HSPavBZdCpX8DOGJlkcHbKh1rd34QH/Kt1
 Hyuw5L7k6HlbyNV+KV28sY83AXBPe9WewlSPlDZLQRPx+Vvq5C
 wH60G1FzRaIbmbqXTIyE8qg/fbLg4jgJt+PXuUbK+7DM45LRRt
 AtmvEL2ZLvz26iJClfLUOElD6Wfr2S/iz//H2BI/brizzbO3Zm
 bzC6I9eyDUFyz+PceErCx3g8f9KA8r2Sd5IZrJb8SkT14C+Laj
 swfsuI3uZ29cG4SdaWgD9pu2lOOUXtOTNR9+IAy3LHW04i+6xS
 xbQ9vMM0VqZzvX73+7TLBGSm8Y7m438lj0mtdbA8F8PSOVi0yJ
 ef3aDEx1cNb2hmSJOYMiHCWnX2Wk5QRPkYewLc+BFGWrwUUPuh
 jW8mS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__devinitconst and friends have recently been removed and must not be
used anymore.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 sound/soc/sh/fsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index 9157612..c724026 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -2160,7 +2160,7 @@ static struct fsi_core fsi2_core = {
 	.b_mclk	= B_MST_CTLR,
 };
 
-static struct of_device_id fsi_of_match[] __devinitconst = {
+static struct of_device_id fsi_of_match[] = {
 	{ .compatible = "renesas,sh_fsi",	.data = &fsi1_core},
 	{ .compatible = "renesas,sh_fsi2",	.data = &fsi2_core},
 	{},
-- 
1.8.1

