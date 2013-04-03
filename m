Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846Ab3DCO6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:58:45 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19566 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761666Ab3DCO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:58:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 03 Apr 2013 07:58:31 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <achew@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 14/14] clk: tegra: Remove forced clk_enable of uartd
Date: Wed, 3 Apr 2013 17:40:49 +0300
Message-ID: <1365000110-8916-16-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
References: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
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
index e2a7fa1..0db81dd 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -2011,7 +2011,7 @@ static __initdata struct tegra_clk_init_table init_table[] = {
 	{uarta, pll_p, 408000000, 0},
 	{uartb, pll_p, 408000000, 0},
 	{uartc, pll_p, 408000000, 0},
-	{uartd, pll_p, 408000000, 1},
+	{uartd, pll_p, 408000000, 0},
 	{pll_a, clk_max, 564480000, 1},
 	{pll_a_out0, clk_max, 11289600, 1},
 	{extern1, pll_a_out0, 0, 1},
-- 
1.7.7.rc0.72.g4b5ea.dirty

