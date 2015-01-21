Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbbAUG1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:27:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62694 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbAUG1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:27:04 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-9a-54bf46b46c18
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: mturquette@linaro.org, kgene@kernel.org, pankaj.dubey@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        sw0312.kim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/12] clk: samsung: exynos5433: Add clocks for CMU_PERIS
 domain
Date: Wed, 21 Jan 2015 15:26:53 +0900
Message-id: <1421821618-8627-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWyRsSkUHeL2/4Qgwf3uC0u79e2uP7lOavF
	pPsTWCz6H79mtri8aw6bxYzz+5gsnk64yGaxaOsXdovDb9pZLWZMfslmsWrXH0YHbo+ds+6y
	e2xa1cnmcefaHjaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyji+/RNzwcmAiqc9R1kaGP+5
	djFyckgImEicm3OFHcIWk7hwbz1bFyMXh5DAUkaJK1dWs8IUzbnylx0isYhRYur2RUwQThOT
	RMvZNhaQKjYBLYn9L24AtXNwiAgYStw8pARSwyzwhlGi+/1vsEnCAqESl17eBLNZBFQlLm/Y
	wgxi8wq4SBzcvZEZYpuCxLLlM1lB5nAKuEq032YCMYWASs5tKQEZKSGwjV2i4+9KNogxAhLf
	Jh9iAamREJCV2HQAaoqkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREY
	C6f/PZuwg/HeAetDjAIcjEo8vC8U94cIsSaWFVfmHmI0BdowkVlKNDkfGHF5JfGGxmZGFqYm
	psZG5pZmSuK8r6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgXLVgbo1z5dPEn2Ee8hby
	p9w3PP+ZcYnjxbavAYs3SIvohAusCuUKnWky22JVnNlMFzvrZXHHDeyvLvoQtz1zQu/NLacZ
	W1gt3q2I+n7kSOtPqZrI45+VJzdeWH12ypfQVqbug9ME454ly9nd2sZ5rcfwolZzPYfwW+kz
	PxqmiRzddchsj0jnUiWW4oxEQy3mouJEAHlrGJKAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAd0tbvtDDGbPYrS4vF/b4vqX56wW
	k+5PYLHof/ya2eLyrjlsFjPO72OyeDrhIpvFoq1f2C0Ov2lntZgx+SWbxapdfxgduD12zrrL
	7rFpVSebx51re9g8+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB+g0JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhDWPG8e2fmAtOBlQ87TnK0sD4z7WLkZNDQsBEYs6Vv+wQtpjEhXvr2boYuTiEBBYxSkzd
	vogJwmlikmg528YCUsUmoCWx/8UNoCoODhEBQ4mbh5RAapgF3jBKdL//zQpSIywQKnHp5U0w
	m0VAVeLyhi3MIDavgIvEwd0bmSG2KUgsWz6TFWQOp4CrRPttJhBTCKjk3JaSCYy8CxgZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIER9ozqR2MKxssDjEKcDAq8fC+UNwfIsSaWFZcmXuI
	UYKDWUmEV1ECKMSbklhZlVqUH19UmpNafIjRFOimicxSosn5wCSQVxJvaGxiZmRpZG5oYWRs
	riTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXA2DSDfempmEM2Dou+J/l/Ud5k9mPbwYxmrpmu
	kl+3sLZ1/3+6ekLATYko8xk8FRfNl7HM29C5fUWX2MerX9RvpaVHmC1TCbnItOvgmrQv+8xj
	vMRXr2haG6OkXmoUpiyryCFW8P5EZX/xFW05Q/cyxo+SrV7Vp+tZzLNvJRRLB4VzLF7uvppV
	iaU4I9FQi7moOBEAP3tzl8oCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing gate clocks of CMU_PERIS domain
which includes TMU/TZPC/SECKEY/CHIPID/TOPRTC/EFUSE IPs.
The special clocks of CMU_PERIS use fin_pll source clock directly.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/samsung/clk-exynos5433.c   | 151 ++++++++++++++++++++++++++++++++-
 include/dt-bindings/clock/exynos5433.h |  33 ++++++-
 2 files changed, 181 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index cfc9d69..88e8651 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -245,6 +245,10 @@ PNAME(mout_sclk_audio1_p)	= { "ioclk_audiocdclk1", "fin_pll",
 PNAME(mout_sclk_audio0_p)	= { "ioclk_audiocdclk0", "fin_pll",
 				    "mout_aud_pll_user_t",};
 
+static struct samsung_fixed_factor_clock top_fixed_factor_clks[] __initdata = {
+	FFACTOR(0, "oscclk_efuse_common", "fin_pll", 1, 1, 0),
+};
+
 static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
 	/* Xi2s{0|1}CDCLK input clock for I2S/PCM */
 	FRATE(0, "ioclk_audiocdclk1", NULL, CLK_IS_ROOT, 100000000),
@@ -614,6 +618,8 @@ static struct samsung_cmu_info top_cmu_info __initdata = {
 	.nr_gate_clks		= ARRAY_SIZE(top_gate_clks),
 	.fixed_clks		= top_fixed_clks,
 	.nr_fixed_clks		= ARRAY_SIZE(top_fixed_clks),
+	.fixed_factor_clks	= top_fixed_factor_clks,
+	.nr_fixed_factor_clks	= ARRAY_SIZE(top_fixed_factor_clks),
 	.nr_clk_ids		= TOP_NR_CLK,
 	.clk_regs		= top_clk_regs,
 	.nr_clk_regs		= ARRAY_SIZE(top_clk_regs),
@@ -954,15 +960,69 @@ CLK_OF_DECLARE(exynos5433_cmu_peric, "samsung,exynos5433-cmu-peric",
 /*
  * Register offset definitions for CMU_PERIS
  */
-#define ENABLE_ACLK_PERIS		0x0800
-#define ENABLE_PCLK_PERIS		0x0900
+#define ENABLE_ACLK_PERIS				0x0800
+#define ENABLE_PCLK_PERIS				0x0900
+#define ENABLE_PCLK_PERIS_SECURE_TZPC			0x0904
+#define ENABLE_PCLK_PERIS_SECURE_SECKEY_APBIF		0x0908
+#define ENABLE_PCLK_PERIS_SECURE_CHIPID_APBIF		0x090c
+#define ENABLE_PCLK_PERIS_SECURE_TOPRTC			0x0910
+#define ENABLE_PCLK_PERIS_SECURE_CUSTOM_EFUSE_APBIF	0x0914
+#define ENABLE_PCLK_PERIS_SECURE_ANTIRBK_CNT_APBIF	0x0918
+#define ENABLE_PCLK_PERIS_SECURE_OTP_CON_APBIF		0x091c
+#define ENABLE_SCLK_PERIS				0x0a00
+#define ENABLE_SCLK_PERIS_SECURE_SECKEY			0x0a04
+#define ENABLE_SCLK_PERIS_SECURE_CHIPID			0x0a08
+#define ENABLE_SCLK_PERIS_SECURE_TOPRTC			0x0a0c
+#define ENABLE_SCLK_PERIS_SECURE_CUSTOM_EFUSE		0x0a10
+#define ENABLE_SCLK_PERIS_SECURE_ANTIRBK_CNT		0x0a14
+#define ENABLE_SCLK_PERIS_SECURE_OTP_CON		0x0a18
+#define ENABLE_IP_PERIS0				0x0b00
+#define ENABLE_IP_PERIS1				0x0b04
+#define ENABLE_IP_PERIS_SECURE_TZPC			0x0b08
+#define ENABLE_IP_PERIS_SECURE_SECKEY			0x0b0c
+#define ENABLE_IP_PERIS_SECURE_CHIPID			0x0b10
+#define ENABLE_IP_PERIS_SECURE_TOPRTC			0x0b14
+#define ENABLE_IP_PERIS_SECURE_CUSTOM_EFUSE		0x0b18
+#define ENABLE_IP_PERIS_SECURE_ANTIBRK_CNT		0x0b1c
+#define ENABLE_IP_PERIS_SECURE_OTP_CON			0x0b20
 
 static unsigned long peris_clk_regs[] __initdata = {
 	ENABLE_ACLK_PERIS,
 	ENABLE_PCLK_PERIS,
+	ENABLE_PCLK_PERIS_SECURE_TZPC,
+	ENABLE_PCLK_PERIS_SECURE_SECKEY_APBIF,
+	ENABLE_PCLK_PERIS_SECURE_CHIPID_APBIF,
+	ENABLE_PCLK_PERIS_SECURE_TOPRTC,
+	ENABLE_PCLK_PERIS_SECURE_CUSTOM_EFUSE_APBIF,
+	ENABLE_PCLK_PERIS_SECURE_ANTIRBK_CNT_APBIF,
+	ENABLE_PCLK_PERIS_SECURE_OTP_CON_APBIF,
+	ENABLE_SCLK_PERIS,
+	ENABLE_SCLK_PERIS_SECURE_SECKEY,
+	ENABLE_SCLK_PERIS_SECURE_CHIPID,
+	ENABLE_SCLK_PERIS_SECURE_TOPRTC,
+	ENABLE_SCLK_PERIS_SECURE_CUSTOM_EFUSE,
+	ENABLE_SCLK_PERIS_SECURE_ANTIRBK_CNT,
+	ENABLE_SCLK_PERIS_SECURE_OTP_CON,
+	ENABLE_IP_PERIS0,
+	ENABLE_IP_PERIS1,
+	ENABLE_IP_PERIS_SECURE_TZPC,
+	ENABLE_IP_PERIS_SECURE_SECKEY,
+	ENABLE_IP_PERIS_SECURE_CHIPID,
+	ENABLE_IP_PERIS_SECURE_TOPRTC,
+	ENABLE_IP_PERIS_SECURE_CUSTOM_EFUSE,
+	ENABLE_IP_PERIS_SECURE_ANTIBRK_CNT,
+	ENABLE_IP_PERIS_SECURE_OTP_CON,
 };
 
 static struct samsung_gate_clock peris_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_PERIS */
+	GATE(CLK_ACLK_AHB2APB_PERIS1P, "aclk_ahb2apb_peris1p", "aclk_peris_66",
+			ENABLE_ACLK_PERIS, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_PERIS0P, "aclk_ahb2apb_peris0p", "aclk_peris_66",
+			ENABLE_ACLK_PERIS, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_PERISNP_66, "aclk_perisnp_66", "aclk_peris_66",
+			ENABLE_ACLK_PERIS, 0, CLK_IGNORE_UNUSED, 0),
+
 	/* ENABLE_PCLK_PERIS */
 	GATE(CLK_PCLK_HPM_APBIF, "pclk_hpm_apbif", "aclk_peris_66",
 			ENABLE_PCLK_PERIS, 30, CLK_IGNORE_UNUSED, 0),
@@ -984,6 +1044,93 @@ static struct samsung_gate_clock peris_gate_clks[] __initdata = {
 			ENABLE_PCLK_PERIS, 15, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_PCLK_HDMI_CEC, "pclk_hdmi_cec", "aclk_peris_66",
 			ENABLE_PCLK_PERIS, 14, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_TZPC */
+	GATE(CLK_PCLK_TZPC12, "pclk_tzpc12", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 12, 0, 0),
+	GATE(CLK_PCLK_TZPC11, "pclk_tzpc11", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 11, 0, 0),
+	GATE(CLK_PCLK_TZPC10, "pclk_tzpc10", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 10, 0, 0),
+	GATE(CLK_PCLK_TZPC9, "pclk_tzpc9", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 9, 0, 0),
+	GATE(CLK_PCLK_TZPC8, "pclk_tzpc8", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 8, 0, 0),
+	GATE(CLK_PCLK_TZPC7, "pclk_tzpc7", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 7, 0, 0),
+	GATE(CLK_PCLK_TZPC6, "pclk_tzpc6", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 6, 0, 0),
+	GATE(CLK_PCLK_TZPC5, "pclk_tzpc5", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 5, 0, 0),
+	GATE(CLK_PCLK_TZPC4, "pclk_tzpc4", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 4, 0, 0),
+	GATE(CLK_PCLK_TZPC3, "pclk_tzpc3", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 3, 0, 0),
+	GATE(CLK_PCLK_TZPC2, "pclk_tzpc2", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 2, 0, 0),
+	GATE(CLK_PCLK_TZPC1, "pclk_tzpc1", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 1, 0, 0),
+	GATE(CLK_PCLK_TZPC0, "pclk_tzpc0", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_SECKEY_APBIF */
+	GATE(CLK_PCLK_SECKEY_APBIF, "pclk_seckey_apbif", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_SECKEY_APBIF, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_CHIPID_APBIF */
+	GATE(CLK_PCLK_CHIPID_APBIF, "pclk_chipid_apbif", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_CHIPID_APBIF, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_TOPRTC */
+	GATE(CLK_PCLK_TOPRTC, "pclk_toprtc", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TOPRTC, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_CUSTOM_EFUSE_APBIF */
+	GATE(CLK_PCLK_CUSTOM_EFUSE_APBIF, "pclk_custom_efuse_apbif",
+			"aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_CUSTOM_EFUSE_APBIF, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_ANTIRBK_CNT_APBIF */
+	GATE(CLK_PCLK_ANTIRBK_CNT_APBIF, "pclk_antirbk_cnt_apbif",
+			"aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_ANTIRBK_CNT_APBIF, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_OTP_CON_APBIF */
+	GATE(CLK_PCLK_OTP_CON_APBIF, "pclk_otp_con_apbif",
+			"aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_OTP_CON_APBIF, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS */
+	GATE(CLK_SCLK_ASV_TB, "sclk_asv_tb", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS, 10, 0, 0),
+	GATE(CLK_SCLK_TMU1, "sclk_tmu1", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS, 4, 0, 0),
+	GATE(CLK_SCLK_TMU0, "sclk_tmu0", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS, 3, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_SECKEY */
+	GATE(CLK_SCLK_SECKEY, "sclk_seckey", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_SECKEY, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_CHIPID */
+	GATE(CLK_SCLK_CHIPID, "sclk_chipid", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_CHIPID, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_TOPRTC */
+	GATE(CLK_SCLK_TOPRTC, "sclk_toprtc", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_TOPRTC, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_CUSTOM_EFUSE */
+	GATE(CLK_SCLK_CUSTOM_EFUSE, "sclk_custom_efuse", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_CUSTOM_EFUSE, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_ANTIRBK_CNT */
+	GATE(CLK_SCLK_ANTIRBK_CNT, "sclk_antirbk_cnt", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_ANTIRBK_CNT, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_OTP_CON */
+	GATE(CLK_SCLK_OTP_CON, "sclk_otp_con", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_OTP_CON, 0, 0, 0),
 };
 
 static struct samsung_cmu_info peris_cmu_info __initdata = {
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 62d3ec7..e9fc243 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -227,8 +227,39 @@
 #define	CLK_PCLK_WDT_ATLAS		8
 #define	CLK_PCLK_MCT			9
 #define	CLK_PCLK_HDMI_CEC		10
+#define CLK_ACLK_AHB2APB_PERIS1P	11
+#define CLK_ACLK_AHB2APB_PERIS0P	12
+#define CLK_ACLK_PERISNP_66		13
+#define CLK_PCLK_TZPC12			14
+#define CLK_PCLK_TZPC11			15
+#define CLK_PCLK_TZPC10			16
+#define CLK_PCLK_TZPC9			17
+#define CLK_PCLK_TZPC8			18
+#define CLK_PCLK_TZPC7			19
+#define CLK_PCLK_TZPC6			20
+#define CLK_PCLK_TZPC5			21
+#define CLK_PCLK_TZPC4			22
+#define CLK_PCLK_TZPC3			23
+#define CLK_PCLK_TZPC2			24
+#define CLK_PCLK_TZPC1			25
+#define CLK_PCLK_TZPC0			26
+#define CLK_PCLK_SECKEY_APBIF		27
+#define CLK_PCLK_CHIPID_APBIF		28
+#define CLK_PCLK_TOPRTC			29
+#define CLK_PCLK_CUSTOM_EFUSE_APBIF	30
+#define CLK_PCLK_ANTIRBK_CNT_APBIF	31
+#define CLK_PCLK_OTP_CON_APBIF		32
+#define CLK_SCLK_ASV_TB			33
+#define CLK_SCLK_TMU1			34
+#define CLK_SCLK_TMU0			35
+#define CLK_SCLK_SECKEY			36
+#define CLK_SCLK_CHIPID			37
+#define CLK_SCLK_TOPRTC			38
+#define CLK_SCLK_CUSTOM_EFUSE		39
+#define CLK_SCLK_ANTIRBK_CNT		40
+#define CLK_SCLK_OTP_CON		41
 
-#define PERIS_NR_CLK			11
+#define PERIS_NR_CLK			42
 
 /* CMU_FSYS */
 #define CLK_MOUT_ACLK_FSYS_200_USER	1
-- 
1.8.5.5

