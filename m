Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab3EWUeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:34:11 -0400
Received: from smtp-out-103.synserver.de ([212.40.185.103]:1041 "EHLO
	smtp-out-103.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab3EWUeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:34:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8636
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/6] MIPS: jz4740: Correct clock gate bit for DMA controller
Date: Thu, 23 May 2013 22:36:22 +0200
Message-Id: <1369341387-19147-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1369341387-19147-1-git-send-email-lars@metafoo.de>
References: <1369341387-19147-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten ter Huurne <maarten@treewalker.org>

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/jz4740/clock.c b/arch/mips/jz4740/clock.c
index 484d38a..1b5f554 100644
--- a/arch/mips/jz4740/clock.c
+++ b/arch/mips/jz4740/clock.c
@@ -687,7 +687,7 @@ static struct clk jz4740_clock_simple_clks[] = {
 	[3] = {
 		.name = "dma",
 		.parent = &jz_clk_high_speed_peripheral.clk,
-		.gate_bit = JZ_CLOCK_GATE_UART0,
+		.gate_bit = JZ_CLOCK_GATE_DMAC,
 		.ops = &jz_clk_simple_ops,
 	},
 	[4] = {
-- 
1.8.2.1

