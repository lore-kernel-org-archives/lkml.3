Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbbAQHTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 02:19:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44356 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbbAQHTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 02:19:15 -0500
X-AuditID: cbfee68d-f79296d000004278-4b-54ba0cf0f5e3
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: rui.zhang@intel.com, edubezval@gmail.com, kgene.kim@samsung.com,
        linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        l.majewski@samsung.com, amit.daniel@samsung.com,
        kesavan.abhilash@gmail.com, linux-samsung-soc@vger.kernel.org
Subject: [PATCH v3] thermal: exynos: Add TMU support for Exynos7 SoC
Date: Sat, 17 Jan 2015 12:49:24 +0530
Message-id: <1421479164-30055-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWyRsSkRvcDz64Qg/edihYNV0MsNs5Yz2ox
	/8o1Vos1f5UsehdcZbN483Azo8XlXXPYLD73HmG0mHF+H5PFk4d9bA5cHjtn3WX3WLznJZNH
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZSxae5mx4E95xaHNj5gbGC8ldjFyckgImEgs2nyE
	EcIWk7hwbz1bFyMXh5DAUkaJGV+fMsEUtR1cA5WYzijRcu8pI4TTxyTx820rG0gVm4CexIJ/
	X5lBbBGBeIllK7ezgBQxC6xjlHjyeBcrSEJYwEViVetKFhCbRUBVYu6Ht2BxXgFXiYU9Lexd
	jBxA6xQk5kyyAemVEOhml5gz7wkTRL2AxLfJh1ggamQlNh1ghrhOUuLgihssExgFFzAyrGIU
	TS1ILihOSi8y1CtOzC0uzUvXS87P3cQIDOTT/5717mC8fcD6EKMAB6MSD2/Cr50hQqyJZcWV
	uYcYTYE2TGSWEk3OB8ZLXkm8obGZkYWpiamxkbmlmZI4r6LUz2AhgfTEktTs1NSC1KL4otKc
	1OJDjEwcnFINjBYP5xm0LpKK4uTxk1zmNfsFo8j+fVPXxkUZrbS4c1JoU8Smf0ovg9Tjz6x6
	dFuNhz9mFbu16Kk3W99F2J6efGLf/b7mvtUCta6LDpU6XJ6z5Nxbkxzec3Mr/6RuFMhS0ZnK
	MHnmuoj4Fz1/leau/zBbv8+8sF3ttXGOFNfKBQdSvaqOdf85NEWJpTgj0VCLuag4EQCVpH5a
	XwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jQd0PPLtCDO7uELFouBpisXHGelaL
	+VeusVqs+atk0bvgKpvFm4ebGS0u75rDZvG59wijxYzz+5gsnjzsY3Pg8tg56y67x+I9L5k8
	+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGorWXGQv+
	lFcc2vyIuYHxUmIXIyeHhICJRNvBNWwQtpjEhXvrgWwuDiGB6YwSLfeeMkI4fUwSP9+2glWx
	CehJLPj3lRnEFhGIl1i2cjsLSBGzwDpGiSePd7GCJIQFXCRWta5kAbFZBFQl5n54CxbnFXCV
	WNjTwt7FyAG0TkFiziSbCYzcCxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx8kzqR2M
	KxssDjEKcDAq8fAm/NoZIsSaWFZcmXuIUYKDWUmEdyFIiDclsbIqtSg/vqg0J7X4EKMp0PKJ
	zFKiyfnAGM4riTc0NjE3NTa1NLEwMbNUEudVsm8LERJITyxJzU5NLUgtgulj4uCUamAUrdg0
	JdopWXbDq64V7nt+FDyr3nrraCerisf/0gKuDS+U5b5YNiy1YG3w8tA7wJ95dLvHu77sJwY1
	vmmNZ1W4Z23ymsQ022bWZDfrf3c755oL/3iW5/xr5zOGuz6e93tavaLsa24vnvv2hMmmDadm
	uOhf0Es+P2UR261E6cTtO7h0An+s2eOtxFKckWioxVxUnAgAIc36SKkCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add registers, bit fields and compatible strings for Exynos7 TMU
(Thermal Management Unit). Following are a few of the differences
in the Exynos7 TMU from earlier SoCs:
        - 8 trigger levels
        - Different bit offsets and more registers for the rising
        and falling thresholds.
        - New power down detection bit in the TMU_CONTROL register
        which does not update the CURRENT_TEMP0 when tmu power down
        is detected.
        - Change in bit offset for the NEXT_DATA field of EMUL_CON
        register. EMUL_CON register address has also changed.
        - INTSTAT and INTCLEAR registers present in earlier SoCs
        have been combined into one INTPEND register. The register
        address for INTCLEAR and INTPEND is also different.
        - Since there are 8 rising/falling interrupts as against
        at most 4 in earlier SoCs the INTEN bit offsets are different.
        - Multiple probe support which is handled by a TMU_CONTROL1
        register (No support for this in the current patch).

This patch adds special clock support required only for Exynos7
and updates the bindings documentation appropriately. It also updates
the "code_to_temp" prototype as Exynos7 has 9 bit code-temp mapping.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
This patch is based on Lukasz Majewski's Exynos TMU v4 patchset:
http://www.spinics.net/lists/linux-samsung-soc/msg41183.html

Changes since v2:
	- Rebased on top of Lukasz' latest exynos tmu series (v4).
	- Added new exynos7 soc_type.
Changes since v1:
	- Rebased on top of Lukasz' latest exynos tmu series (v2).
	- Added sclk support to patch adding Exynos7 tmu support.
	Previously, it was a separate patch.
	- Used the SOC type to decide if sclk is present.

 .../devicetree/bindings/thermal/exynos-thermal.txt |    4 +
 drivers/thermal/samsung/exynos_tmu.c               |  203 +++++++++++++++++++-
 drivers/thermal/samsung/exynos_tmu.h               |    1 +
 3 files changed, 199 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index 0f44932..695150a 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -12,6 +12,7 @@
 	       "samsung,exynos5420-tmu-ext-triminfo" for TMU channels 2, 3 and 4
 			Exynos5420 (Must pass triminfo base and triminfo clock)
 	       "samsung,exynos5440-tmu"
+	       "samsung,exynos7-tmu"
 - interrupt-parent : The phandle for the interrupt controller
 - reg : Address range of the thermal registers. For soc's which has multiple
 	instances of TMU and some registers are shared across all TMU's like
@@ -32,10 +33,13 @@
 - clocks : The main clocks for TMU device
 	-- 1. operational clock for TMU channel
 	-- 2. optional clock to access the shared registers of TMU channel
+	-- 3. optional special clock for functional operation
 - clock-names : Thermal system clock name
 	-- "tmu_apbif" operational clock for current TMU channel
 	-- "tmu_triminfo_apbif" clock to access the shared triminfo register
 		for current TMU channel
+	-- "tmu_sclk" clock for functional operation of the current TMU
+		channel
 - vtmu-supply: This entry is optional and provides the regulator node supplying
 		voltage to TMU. If needed this entry can be placed inside
 		board/platform specific dts file.
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 633a9e2..8b26acb 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -119,6 +119,26 @@
 #define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
 #define EXYNOS5440_EFUSE_SWAP_OFFSET		8
 
+/* Exynos7 specific registers */
+#define EXYNOS7_THD_TEMP_RISE7_6		0x50
+#define EXYNOS7_THD_TEMP_FALL7_6		0x60
+#define EXYNOS7_TMU_REG_INTEN			0x110
+#define EXYNOS7_TMU_REG_INTPEND			0x118
+#define EXYNOS7_TMU_REG_EMUL_CON		0x160
+
+#define EXYNOS7_TMU_TEMP_MASK			0x1ff
+#define EXYNOS7_PD_DET_EN_SHIFT			23
+#define EXYNOS7_TMU_INTEN_RISE0_SHIFT		0
+#define EXYNOS7_TMU_INTEN_RISE1_SHIFT		1
+#define EXYNOS7_TMU_INTEN_RISE2_SHIFT		2
+#define EXYNOS7_TMU_INTEN_RISE3_SHIFT		3
+#define EXYNOS7_TMU_INTEN_RISE4_SHIFT		4
+#define EXYNOS7_TMU_INTEN_RISE5_SHIFT		5
+#define EXYNOS7_TMU_INTEN_RISE6_SHIFT		6
+#define EXYNOS7_TMU_INTEN_RISE7_SHIFT		7
+#define EXYNOS7_EMUL_DATA_SHIFT			7
+#define EXYNOS7_EMUL_DATA_MASK			0x1ff
+
 #define MCELSIUS	1000
 /**
  * struct exynos_tmu_data : A structure to hold the private data of the TMU
@@ -133,6 +153,7 @@
  * @lock: lock to implement synchronization.
  * @clk: pointer to the clock structure.
  * @clk_sec: pointer to the clock structure for accessing the base_second.
+ * @sclk: pointer to the clock structure for accessing the tmu special clk.
  * @temp_error1: fused value of the first point trim.
  * @temp_error2: fused value of the second point trim.
  * @regulator: pointer to the TMU regulator structure.
@@ -152,8 +173,8 @@ struct exynos_tmu_data {
 	enum soc_type soc;
 	struct work_struct irq_work;
 	struct mutex lock;
-	struct clk *clk, *clk_sec;
-	u8 temp_error1, temp_error2;
+	struct clk *clk, *clk_sec, *sclk;
+	u16 temp_error1, temp_error2;
 	struct regulator *regulator;
 	struct thermal_zone_device *tzd;
 
@@ -223,7 +244,7 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
  * Calculate a temperature value from a temperature code.
  * The unit of the temperature is degree Celsius.
  */
-static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
+static int code_to_temp(struct exynos_tmu_data *data, u16 temp_code)
 {
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp;
@@ -513,6 +534,81 @@ static int exynos5440_tmu_initialize(struct platform_device *pdev)
 	return ret;
 }
 
+static int exynos7_tmu_initialize(struct platform_device *pdev)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct thermal_zone_device *tz = data->tzd;
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	unsigned int status, trim_info;
+	unsigned int rising_threshold = 0, falling_threshold = 0;
+	int ret = 0, threshold_code, i;
+	unsigned long temp, temp_hist;
+	unsigned int reg_off, bit_off;
+
+	status = readb(data->base + EXYNOS_TMU_REG_STATUS);
+	if (!status) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
+
+	data->temp_error1 = trim_info & EXYNOS7_TMU_TEMP_MASK;
+	if (!data->temp_error1 ||
+		(pdata->min_efuse_value > data->temp_error1) ||
+		(data->temp_error1 > pdata->max_efuse_value))
+		data->temp_error1 = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
+
+	/* Write temperature code for rising and falling threshold */
+	for (i = (of_thermal_get_ntrips(tz) - 1); i >= 0; i--) {
+		/*
+		 * On exynos7 there are 4 rising and 4 falling threshold
+		 * registers (0x50-0x5c and 0x60-0x6c respectively). Each
+		 * register holds the value of two threshold levels (at bit
+		 * offsets 0 and 16). Based on the fact that there are atmost
+		 * eight possible trigger levels, calculate the register and
+		 * bit offsets where the threshold levels are to be written.
+		 *
+		 * e.g. EXYNOS7_THD_TEMP_RISE7_6 (0x50)
+		 * [24:16] - Threshold level 7
+		 * [8:0] - Threshold level 6
+		 * e.g. EXYNOS7_THD_TEMP_RISE5_4 (0x54)
+		 * [24:16] - Threshold level 5
+		 * [8:0] - Threshold level 4
+		 *
+		 * and similarly for falling thresholds.
+		 */
+		reg_off = ((7 - i) / 2) * 4;
+		bit_off = ((8 - i) % 2);
+
+		tz->ops->get_trip_temp(tz, i, &temp);
+		temp /= MCELSIUS;
+
+		tz->ops->get_trip_hyst(tz, i, &temp_hist);
+		temp_hist = temp - (temp_hist / MCELSIUS);
+
+		threshold_code = temp_to_code(data, temp);
+		rising_threshold = readl(data->base +
+			EXYNOS7_THD_TEMP_RISE7_6 + reg_off);
+		rising_threshold &= ~(0x1ff << (16 * bit_off));
+		rising_threshold |= threshold_code << (16 * bit_off);
+		writel(rising_threshold,
+			data->base + EXYNOS7_THD_TEMP_RISE7_6 + reg_off);
+
+		threshold_code = temp_to_code(data, temp_hist);
+		falling_threshold = readl(data->base +
+			EXYNOS7_THD_TEMP_FALL7_6 + reg_off);
+		falling_threshold &= ~(0x1ff << (16 * bit_off));
+		falling_threshold |= threshold_code << (16 * bit_off);
+		writel(falling_threshold,
+			data->base + EXYNOS7_THD_TEMP_FALL7_6 + reg_off);
+	}
+
+	data->tmu_clear_irqs(data);
+out:
+	return ret;
+}
+
 static void exynos4210_tmu_control(struct platform_device *pdev, bool on)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
@@ -573,6 +669,46 @@ static void exynos5440_tmu_control(struct platform_device *pdev, bool on)
 	writel(con, data->base + EXYNOS5440_TMU_S0_7_CTRL);
 }
 
+static void exynos7_tmu_control(struct platform_device *pdev, bool on)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct thermal_zone_device *tz = data->tzd;
+	unsigned int con, interrupt_en;
+
+	con = get_con_reg(data, readl(data->base + EXYNOS_TMU_REG_CONTROL));
+
+	if (on) {
+		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
+		interrupt_en =
+			(of_thermal_is_trip_valid(tz, 7)
+			<< EXYNOS7_TMU_INTEN_RISE7_SHIFT) |
+			(of_thermal_is_trip_valid(tz, 6)
+			<< EXYNOS7_TMU_INTEN_RISE6_SHIFT) |
+			(of_thermal_is_trip_valid(tz, 5)
+			<< EXYNOS7_TMU_INTEN_RISE5_SHIFT) |
+			(of_thermal_is_trip_valid(tz, 4)
+			<< EXYNOS7_TMU_INTEN_RISE4_SHIFT) |
+			(of_thermal_is_trip_valid(tz, 3)
+			<< EXYNOS7_TMU_INTEN_RISE3_SHIFT) |
+			(of_thermal_is_trip_valid(tz, 2)
+			<< EXYNOS7_TMU_INTEN_RISE2_SHIFT) |
+			(of_thermal_is_trip_valid(tz, 1)
+			<< EXYNOS7_TMU_INTEN_RISE1_SHIFT) |
+			(of_thermal_is_trip_valid(tz, 0)
+			<< EXYNOS7_TMU_INTEN_RISE0_SHIFT);
+
+		interrupt_en |=
+			interrupt_en << EXYNOS_TMU_INTEN_FALL0_SHIFT;
+	} else {
+		con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
+		interrupt_en = 0; /* Disable all interrupts */
+	}
+	con |= 1 << EXYNOS7_PD_DET_EN_SHIFT;
+
+	writel(interrupt_en, data->base + EXYNOS7_TMU_REG_INTEN);
+	writel(con, data->base + EXYNOS_TMU_REG_CONTROL);
+}
+
 int exynos_get_temp(void *p, long *temp)
 {
 	struct exynos_tmu_data *data = p;
@@ -602,9 +738,19 @@ static u32 get_emul_con_reg(struct exynos_tmu_data *data, unsigned int val,
 			val &= ~(EXYNOS_EMUL_TIME_MASK << EXYNOS_EMUL_TIME_SHIFT);
 			val |= (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT);
 		}
-		val &= ~(EXYNOS_EMUL_DATA_MASK << EXYNOS_EMUL_DATA_SHIFT);
-		val |= (temp_to_code(data, temp) << EXYNOS_EMUL_DATA_SHIFT) |
-			EXYNOS_EMUL_ENABLE;
+		if (data->soc == SOC_ARCH_EXYNOS7) {
+			val &= ~(EXYNOS7_EMUL_DATA_MASK <<
+				EXYNOS7_EMUL_DATA_SHIFT);
+			val |= (temp_to_code(data, temp) <<
+				EXYNOS7_EMUL_DATA_SHIFT) |
+				EXYNOS_EMUL_ENABLE;
+		} else {
+			val &= ~(EXYNOS_EMUL_DATA_MASK <<
+				EXYNOS_EMUL_DATA_SHIFT);
+			val |= (temp_to_code(data, temp) <<
+				EXYNOS_EMUL_DATA_SHIFT) |
+				EXYNOS_EMUL_ENABLE;
+		}
 	} else {
 		val &= ~EXYNOS_EMUL_ENABLE;
 	}
@@ -620,6 +766,8 @@ static void exynos4412_tmu_set_emulation(struct exynos_tmu_data *data,
 
 	if (data->soc == SOC_ARCH_EXYNOS5260)
 		emul_con = EXYNOS5260_EMUL_CON;
+	else if (data->soc == SOC_ARCH_EXYNOS7)
+		emul_con = EXYNOS7_TMU_REG_EMUL_CON;
 	else
 		emul_con = EXYNOS_EMUL_CON;
 
@@ -683,6 +831,12 @@ static int exynos5440_tmu_read(struct exynos_tmu_data *data)
 	return readb(data->base + EXYNOS5440_TMU_S0_7_TEMP);
 }
 
+static int exynos7_tmu_read(struct exynos_tmu_data *data)
+{
+	return readw(data->base + EXYNOS_TMU_REG_CURRENT_TEMP) &
+		EXYNOS7_TMU_TEMP_MASK;
+}
+
 static void exynos_tmu_work(struct work_struct *work)
 {
 	struct exynos_tmu_data *data = container_of(work,
@@ -721,6 +875,8 @@ static void exynos4210_tmu_clear_irqs(struct exynos_tmu_data *data)
 	if (data->soc == SOC_ARCH_EXYNOS5260) {
 		tmu_intstat = EXYNOS5260_TMU_REG_INTSTAT;
 		tmu_intclear = EXYNOS5260_TMU_REG_INTCLEAR;
+	} else if (data->soc == SOC_ARCH_EXYNOS7) {
+		tmu_intstat = tmu_intclear = EXYNOS7_TMU_REG_INTPEND;
 	} else {
 		tmu_intstat = EXYNOS_TMU_REG_INTSTAT;
 		tmu_intclear = EXYNOS_TMU_REG_INTCLEAR;
@@ -782,6 +938,9 @@ static const struct of_device_id exynos_tmu_match[] = {
 	{
 		.compatible = "samsung,exynos5440-tmu",
 	},
+	{
+		.compatible = "samsung,exynos7-tmu",
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_tmu_match);
@@ -805,6 +964,8 @@ static int exynos_of_get_soc_type(struct device_node *np)
 		return SOC_ARCH_EXYNOS5420_TRIMINFO;
 	else if (of_device_is_compatible(np, "samsung,exynos5440-tmu"))
 		return SOC_ARCH_EXYNOS5440;
+	else if (of_device_is_compatible(np, "samsung,exynos7-tmu"))
+		return SOC_ARCH_EXYNOS7;
 
 	return -EINVAL;
 }
@@ -928,6 +1089,13 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 		data->tmu_set_emulation = exynos5440_tmu_set_emulation;
 		data->tmu_clear_irqs = exynos5440_tmu_clear_irqs;
 		break;
+	case SOC_ARCH_EXYNOS7:
+		data->tmu_initialize = exynos7_tmu_initialize;
+		data->tmu_control = exynos7_tmu_control;
+		data->tmu_read = exynos7_tmu_read;
+		data->tmu_set_emulation = exynos4412_tmu_set_emulation;
+		data->tmu_clear_irqs = exynos4210_tmu_clear_irqs;
+		break;
 	default:
 		dev_err(&pdev->dev, "Platform not supported\n");
 		return -EINVAL;
@@ -1017,27 +1185,43 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		goto err_clk_sec;
 	}
 
+	if (data->soc == SOC_ARCH_EXYNOS7) {
+		data->sclk = devm_clk_get(&pdev->dev, "tmu_sclk");
+		if (IS_ERR(data->sclk)) {
+			dev_err(&pdev->dev, "Failed to get sclk\n");
+			goto err_clk;
+		} else {
+			ret = clk_prepare_enable(data->sclk);
+			if (ret) {
+				dev_err(&pdev->dev, "Failed to enable sclk\n");
+				goto err_clk;
+			}
+		}
+	}
+
 	ret = exynos_tmu_initialize(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize TMU\n");
-		goto err_clk;
+		goto err_sclk;
 	}
 
 	ret = devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
 		IRQF_TRIGGER_RISING | IRQF_SHARED, dev_name(&pdev->dev), data);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
-		goto err_clk;
+		goto err_sclk;
 	}
 
 	ret = exynos_tmu_initialize(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize TMU\n");
-		goto err_clk;
+		goto err_sclk;
 	}
 	exynos_tmu_control(pdev, true);
 	return 0;
 
+err_sclk:
+	clk_disable_unprepare(data->sclk);
 err_clk:
 	clk_unprepare(data->clk);
 err_clk_sec:
@@ -1057,6 +1241,7 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 	thermal_zone_of_sensor_unregister(&pdev->dev, tzd);
 	exynos_tmu_control(pdev, false);
 
+	clk_disable_unprepare(data->sclk);
 	clk_unprepare(data->clk);
 	if (!IS_ERR(data->clk_sec))
 		clk_unprepare(data->clk_sec);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index d876d4c..d7c34bd 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -34,6 +34,7 @@ enum soc_type {
 	SOC_ARCH_EXYNOS5420,
 	SOC_ARCH_EXYNOS5420_TRIMINFO,
 	SOC_ARCH_EXYNOS5440,
+	SOC_ARCH_EXYNOS7,
 };
 
 /**
-- 
1.7.9.5

