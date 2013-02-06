Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3BFWnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:43:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFWnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:43:06 -0500
Message-ID: <5112DC75.8070806@dawncrow.de>
Date: Wed, 06 Feb 2013 23:43:01 +0100
From: =?ISO-8859-15?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: tony@atomide.com, linux@arm.linux.org.uk, linux-omap@vger.kernel.org
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: Include soc.h to fix compiling
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:PSMM/3JzVMr8MISjhU2GrEMMp+mbpkyZrKSoz+36BoB
 9RPJgbTb+BiTMaIKxEgKZVeMld47twhQkKhEW3TqDsnHB1+9y9
 NiOJFt7DiE004dVFVGtoTT3hjh5ENOrbVu25PINWHYsgNKt9aR
 560tU8OESesJgw3JKuJm2T121grKxbGtri3chWND0cCS9aVaeD
 2OcNy+hb1BWRKVAG1TLevBAxrM985+wCSwg6IqlGYUgxpu2Oea
 aPx/RJq3SR/fQjkw53Gktpi7EPSRlVt/DqF/SNcjnkhFuovOYB
 4Oiaxssb9sJoh4DP4RW+zSs1IrwBCixmb5S8xjiBDHD87FJoWu
 rv/CMGOtPxYnRGDB2C88=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I needed this when compiling for pandaboard at commit: 0944c0a03465718909ba8e800a5230528aeabafb

Signed-off-by: André Hentschel <nerv@dawncrow.de>From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
Date: Wed, 6 Feb 2013 23:16:20 +0100
Subject: [PATCH] arm: Include soc.h to fix compiling

---
 arch/arm/mach-omap2/drm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/drm.c b/arch/arm/mach-omap2/drm.c
index 4c7566c..b4faf96 100644
--- a/arch/arm/mach-omap2/drm.c
+++ b/arch/arm/mach-omap2/drm.c
@@ -27,6 +27,7 @@
 
 #include "omap_device.h"
 #include "omap_hwmod.h"
+#include "soc.h"
 
 #if defined(CONFIG_DRM_OMAP) || (CONFIG_DRM_OMAP_MODULE)
 
-- 
1.8.0

Best Regards, André Hentschel
