Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3LSQOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:14:47 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19356 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3LSQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:14:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Dec 2013 08:15:57 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: Add missing Tegra20 fuse clks
Date: Thu, 19 Dec 2013 18:14:36 +0200
Message-ID: <1387469676-17693-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra20.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index b3b7204..4bc1cc5 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -575,6 +575,8 @@ static struct tegra_clk tegra20_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_tvdac] = { .dt_id = TEGRA20_CLK_TVDAC, .present = true },
 	[tegra_clk_vi_sensor] = { .dt_id = TEGRA20_CLK_VI_SENSOR, .present = true },
 	[tegra_clk_afi] = { .dt_id = TEGRA20_CLK_AFI, .present = true },
+	[tegra_clk_fuse] = { .dt_id = TEGRA20_CLK_FUSE, .present = true },
+	[tegra_clk_kfuse] = { .dt_id = TEGRA20_CLK_KFUSE, .present = true },
 };
 
 static unsigned long tegra20_clk_measure_input_freq(void)
-- 
1.7.7.rc0.72.g4b5ea.dirty

