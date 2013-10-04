Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3JDJSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:18:12 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11278 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3JDJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:18:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Oct 2013 02:18:10 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH 3/5] clk: tegra124: Add common clk IDs to clk-id.h
Date: Fri, 4 Oct 2013 12:12:42 +0300
Message-ID: <1380878014-22088-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra124 introduces a number of a new clocks. Introduce the corresponding
the IDs for them.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-id.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-id.h b/drivers/clk/tegra/clk-id.h
index b2a4d45..4ac3017 100644
--- a/drivers/clk/tegra/clk-id.h
+++ b/drivers/clk/tegra/clk-id.h
@@ -191,6 +191,33 @@ enum clk_id {
 	tegra_clk_clk_out_3_mux,
 	tegra_clk_dsia_mux,
 	tegra_clk_dsib_mux,
+
+	tegra124_clk_isp,
+	tegra_clk_uarte,
+	tegra_clk_entropy,
+	tegra_clk_i2c6,
+	tegra_clk_hdmi_audio,
+	tegra_clk_clk72Mhz,
+	tegra_clk_vic03,
+	tegra_clk_adx1,
+	tegra_clk_amx1,
+	tegra_clk_sor0,
+	tegra_clk_sata_oob,
+	tegra_clk_sata,
+	tegra_clk_vi_sensor2,
+	tegra_clk_ispb,
+	tegra_clk_vim2_clk,
+	tegra_clk_pcie,
+	tegra_clk_afi,
+	tegra_clk_sata_cold,
+	tegra_clk_dpaux,
+	tegra_clk_gpu,
+	tegra_clk_pll_p_out5,
+	tegra_clk_cml0,
+	tegra_clk_cml1,
+	tegra_clk_pll_c4,
+	tegra_clk_pll_dp,
+
 	tegra_clk_max,
 };
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

