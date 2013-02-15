Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161616Ab3BOMsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:48:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9739 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161489Ab3BOMsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:48:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 15 Feb 2013 04:46:53 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 12/12] clk: tegra: Remove forced clk_enable of uartd
Date: Fri, 15 Feb 2013 14:36:42 +0200
Message-ID: <1360931849-7090-13-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1360931849-7090-1-git-send-email-pdeschrijver@nvidia.com>
References: <1360931849-7090-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UART driver enables the console uart clock, so we don't need to do that
anymore in this file.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index f6c6b67..4175bf1 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1973,7 +1973,7 @@ static __initdata struct tegra_clk_init_table init_table[] = {
 	{uarta, pll_p, 408000000, 0},
 	{uartb, pll_p, 408000000, 0},
 	{uartc, pll_p, 408000000, 0},
-	{uartd, pll_p, 408000000, 1},
+	{uartd, pll_p, 408000000, 0},
 	{clk_max, clk_max, 0, 0}, /* This MUST be the last entry. */
 };
 
-- 
1.7.1

