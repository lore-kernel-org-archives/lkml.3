Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967444AbaFTMh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:37:59 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:47600 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967202AbaFTMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:37:46 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/4] ARM: shmobile: dma: Use defines instead of hardcoded numbers
Date: Fri, 20 Jun 2014 14:37:39 +0200
Message-Id: <1403267861-15609-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
References: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-shmobile/dma-register.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/dma-register.h b/arch/arm/mach-shmobile/dma-register.h
index 97c40bd9b94f..52a2f66e600f 100644
--- a/arch/arm/mach-shmobile/dma-register.h
+++ b/arch/arm/mach-shmobile/dma-register.h
@@ -52,8 +52,8 @@ static const unsigned int dma_ts_shift[] = {
 	((((i) & TS_LOW_BIT) << TS_LOW_SHIFT) |\
 	 (((i) & TS_HI_BIT)  << TS_HI_SHIFT))
 
-#define CHCR_TX(xmit_sz) (DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL((xmit_sz)))
-#define CHCR_RX(xmit_sz) (DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL((xmit_sz)))
+#define CHCR_TX(xmit_sz) (DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL((xmit_sz)))
+#define CHCR_RX(xmit_sz) (DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL((xmit_sz)))
 
 
 /*
-- 
1.9.1

