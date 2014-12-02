Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaLBIuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:50:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52358 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaLBIuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:00 -0500
X-AuditID: cbfee691-f79b86d000004a5a-82-547d7d363277
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/19] clk: samsung: exynos5433: Add clocks for CMU_PERIS domain
Date: Tue, 02 Dec 2014 17:49:41 +0900
Message-id: <1417510196-6714-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkSNestjbE4M5jZYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGVMvj+Z
	sWCbT8Wf1Q+ZGxj3OnUxcnJICJhI/Pl+kQXCFpO4cG89WxcjF4eQwFJGiY/z+hhhiu5vf8sO
	kZjOKNG1fhUTSEJIoIlJYvY9IRCbTUBLYv+LG2wgtoiAs0TD1EYmkAZmgTfMEnvu7wZbISwQ
	INHfNAmoiIODRUBV4u9rPZAwr4CLxLwn+6GuUJBYtnwmK4jNKeAq0XWmjx1il4vEr9aPYEdI
	CMzkkPj6sJsZJMEiICDxbfIhFpCZEgKyEpsOMEPMkZQ4uOIGywRG4QWMDKsYRVMLkguKk9KL
	TPWKE3OLS/PS9ZLzczcxAqPx9L9nE3cw3j9gfYhRgINRiYf3xPmaECHWxLLiytxDjKZAGyYy
	S4km5wNjPq8k3tDYzMjC1MTU2Mjc0kxJnFdH+mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BsZk35MNYS2x62rtXAXm7mJKWt0gYv3itcWeQs3E6ZJM05c3/Nqcp1zScG7rpvUzrx2Y2LJj
	ZswaAZXKaYd/aap/zuFOtbO+u+Xyn8Jj/kpVk5nfi68M4mhk+LtbKIv/xrPeBf1OO1ZUi77w
	cS2x/jop+FgK587DZje9Tybs0T9lJpm3aGPz/X9KLMUZiYZazEXFiQD0aaC5wQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV2z2toQg6fzJSwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYxY/L9yYwF23wq/qx+yNzAuNepi5GTQ0LAROL+9rfsELaYxIV7
	69m6GLk4hASmM0p0rV/FBJIQEmhikph9TwjEZhPQktj/4gYbiC0i4CzRMLWRCaSBWeANs8Se
	+7tZQBLCAgES/U2TgIo4OFgEVCX+vtYDCfMKuEjMe7KfBWKZgsSy5TNZQWxOAVeJrjN97BC7
	XCR+tX5kn8DIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcKw/k9rBuLLB4hCjAAej
	Eg/vifM1IUKsiWXFlbmHGCU4mJVEeH8Z14YI8aYkVlalFuXHF5XmpBYfYjQFOmois5Rocj4w
	DeWVxBsam5gZWRqZG1oYGZsrifPeuJkbIiSQnliSmp2aWpBaBNPHxMEp1cB4IoMvseJa3gN3
	8eaLDptfz7791Ofj/huvO56f2ej275CtWfjqg+VdWyIWB2rXTGvykneN6u7m9j6TU2KSGmL/
	7vfrxzcfJvg8i71krJiZxlrVIMUt6NatGLhIv+S/orKAx1U7xmmfltqJq3YFLHFarruO5XLf
	pxkH4/4fFax9LbYtwyj3cYISS3FGoqEWc1FxIgDZEN+tCwMAAA==
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
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 drivers/clk/samsung/clk-exynos5433.c   | 146 ++++++++++++++++++++++++++++++++-
 include/dt-bindings/clock/exynos5433.h |  33 +++++++-
 2 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index a48b36c..7e4612f 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -248,6 +248,7 @@ PNAME(mout_sclk_audio0_p)	= { "ioclk_audiocdclk0", "fin_pll",
 static struct samsung_fixed_factor_clock top_fixed_factor_clks[] __initdata = {
 	FFACTOR(0, "sclk_bus_pll", "fout_bus_pll", 1, 1, 0),
 	FFACTOR(0, "sclk_mfc_pll", "fout_mfc_pll", 1, 1, 0),
+	FFACTOR(0, "oscclk_efuse_common", "fin_pll", 1, 1, 0),
 };
 
 static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
@@ -957,15 +958,69 @@ CLK_OF_DECLARE(exynos5433_cmu_peric, "samsung,exynos5433-cmu-peric",
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
@@ -987,6 +1042,93 @@ static struct samsung_gate_clock peris_gate_clks[] __initdata = {
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
index 8535917..48eb6f3 100644
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

