Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3JRNpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:45:20 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2063 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3JRNpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:45:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Oct 2013 06:40:46 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 3/7] clk: tegra124: Add common clk IDs to clk-id.h
Date: Fri, 18 Oct 2013 16:45:00 +0300
Message-ID: <1382103904-6398-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382103904-6398-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382103904-6398-1-git-send-email-pdeschrijver@nvidia.com>
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
 drivers/clk/tegra/clk-id.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-id.h b/drivers/clk/tegra/clk-id.h
index 22e2e8e..836b054 100644
--- a/drivers/clk/tegra/clk-id.h
+++ b/drivers/clk/tegra/clk-id.h
@@ -7,8 +7,10 @@
 enum clk_id {
 	tegra_clk_actmon,
 	tegra_clk_adx,
+	tegra_clk_adx1,
 	tegra_clk_afi,
 	tegra_clk_amx,
+	tegra_clk_amx1,
 	tegra_clk_apbdma,
 	tegra_clk_apbif,
 	tegra_clk_audio0,
@@ -35,6 +37,7 @@ enum clk_id {
 	tegra_clk_cilcd,
 	tegra_clk_cile,
 	tegra_clk_clk_32k,
+	tegra_clk_clk72Mhz,
 	tegra_clk_clk_m,
 	tegra_clk_clk_m_div2,
 	tegra_clk_clk_m_div4,
@@ -44,6 +47,8 @@ enum clk_id {
 	tegra_clk_clk_out_2_mux,
 	tegra_clk_clk_out_3,
 	tegra_clk_clk_out_3_mux,
+	tegra_clk_cml0,
+	tegra_clk_cml1,
 	tegra_clk_csi,
 	tegra_clk_csite,
 	tegra_clk_csus,
@@ -58,6 +63,7 @@ enum clk_id {
 	tegra_clk_disp1,
 	tegra_clk_disp2,
 	tegra_clk_dp2,
+	tegra_clk_dpaux,
 	tegra_clk_dsia,
 	tegra_clk_dsialp,
 	tegra_clk_dsia_mux,
@@ -66,6 +72,7 @@ enum clk_id {
 	tegra_clk_dsib_mux,
 	tegra_clk_dtv,
 	tegra_clk_emc,
+	tegra_clk_entropy,
 	tegra_clk_epp,
 	tegra_clk_epp_8,
 	tegra_clk_extern1,
@@ -73,6 +80,7 @@ enum clk_id {
 	tegra_clk_extern3,
 	tegra_clk_fuse,
 	tegra_clk_fuse_burn,
+	tegra_clk_gpu,
 	tegra_clk_gr2d,
 	tegra_clk_gr2d_8,
 	tegra_clk_gr3d,
@@ -82,6 +90,7 @@ enum clk_id {
 	tegra_clk_hda2codec_2x,
 	tegra_clk_hda2hdmi,
 	tegra_clk_hdmi,
+	tegra_clk_hdmi_audio,
 	tegra_clk_host1x,
 	tegra_clk_host1x_8,
 	tegra_clk_i2c1,
@@ -89,6 +98,7 @@ enum clk_id {
 	tegra_clk_i2c3,
 	tegra_clk_i2c4,
 	tegra_clk_i2c5,
+	tegra_clk_i2c6,
 	tegra_clk_i2cslow,
 	tegra_clk_i2s0,
 	tegra_clk_i2s0_sync,
@@ -101,6 +111,8 @@ enum clk_id {
 	tegra_clk_i2s4,
 	tegra_clk_i2s4_sync,
 	tegra_clk_isp,
+	tegra_clk_isp_8,
+	tegra_clk_ispb,
 	tegra_clk_kbc,
 	tegra_clk_kfuse,
 	tegra_clk_la,
@@ -115,17 +127,20 @@ enum clk_id {
 	tegra_clk_ndspeed_8,
 	tegra_clk_nor,
 	tegra_clk_owr,
+	tegra_clk_pcie,
 	tegra_clk_pclk,
 	tegra_clk_pll_a,
 	tegra_clk_pll_a_out0,
 	tegra_clk_pll_c,
 	tegra_clk_pll_c2,
 	tegra_clk_pll_c3,
+	tegra_clk_pll_c4,
 	tegra_clk_pll_c_out1,
 	tegra_clk_pll_d,
 	tegra_clk_pll_d2,
 	tegra_clk_pll_d2_out0,
 	tegra_clk_pll_d_out0,
+	tegra_clk_pll_dp,
 	tegra_clk_pll_e_out0,
 	tegra_clk_pll_m,
 	tegra_clk_pll_m_out1,
@@ -135,6 +150,7 @@ enum clk_id {
 	tegra_clk_pll_p_out2_int,
 	tegra_clk_pll_p_out3,
 	tegra_clk_pll_p_out4,
+	tegra_clk_pll_p_out5,
 	tegra_clk_pll_ref,
 	tegra_clk_pll_re_out,
 	tegra_clk_pll_re_vco,
@@ -169,6 +185,7 @@ enum clk_id {
 	tegra_clk_sdmmc4,
 	tegra_clk_se,
 	tegra_clk_soc_therm,
+	tegra_clk_sor0,
 	tegra_clk_spdif,
 	tegra_clk_spdif_2x,
 	tegra_clk_spdif_in,
@@ -195,8 +212,11 @@ enum clk_id {
 	tegra_clk_vfir,
 	tegra_clk_vi,
 	tegra_clk_vi_8,
+	tegra_clk_vic03,
+	tegra_clk_vim2_clk,
 	tegra_clk_vimclk_sync,
 	tegra_clk_vi_sensor,
+	tegra_clk_vi_sensor2,
 	tegra_clk_vi_sensor_8,
 	tegra_clk_xusb_dev,
 	tegra_clk_xusb_dev_src,
-- 
1.7.7.rc0.72.g4b5ea.dirty

