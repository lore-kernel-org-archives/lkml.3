Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbaGOR24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:28:56 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49635 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaGORCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:06 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 10/94] clk/exynos5250: fix bit number for tv sysmmu clock
Date: Tue, 15 Jul 2014 20:00:25 +0300
Message-Id: <1405443709-15288-10-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rahul Sharma <rahul.sharma@samsung.com>

Change bit from 2 to 9 for tv (mixer) sysmmu clock.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
Reviewed-by: Sachin Kamat <sachin.kamat@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/samsung/clk-exynos5250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index 1fad4c5..184f642 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -661,7 +661,7 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(CLK_RTC, "rtc", "div_aclk66", GATE_IP_PERIS, 20, 0, 0),
 	GATE(CLK_TMU, "tmu", "div_aclk66", GATE_IP_PERIS, 21, 0, 0),
 	GATE(CLK_SMMU_TV, "smmu_tv", "mout_aclk200_disp1_sub",
-			GATE_IP_DISP1, 2, 0, 0),
+			GATE_IP_DISP1, 9, 0, 0),
 	GATE(CLK_SMMU_FIMD1, "smmu_fimd1", "mout_aclk200_disp1_sub",
 			GATE_IP_DISP1, 8, 0, 0),
 	GATE(CLK_SMMU_2D, "smmu_2d", "div_aclk200", GATE_IP_ACP, 7, 0, 0),
-- 
1.7.10.4

