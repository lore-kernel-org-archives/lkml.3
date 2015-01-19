Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbbASJtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:49:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44908 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbbASJtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:49:21 -0500
X-AuditID: cbfee691-f79b86d000004a5a-67-54bcd2f32e52
From: Inha Song <ideal.song@samsung.com>
To: alsa-devel@alsa-project.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        s.nawrocki@samsung.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, kgene@kernel.org,
        sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        ideal.song@samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [alsa-devel] [PATCH v2 1/3] ASoC: samsung: Add machine driver for
 Trats2
Date: Mon, 19 Jan 2015 18:48:20 +0900
Message-id: <1421660902-29679-2-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421660902-29679-1-git-send-email-ideal.song@samsung.com>
References: <1421660902-29679-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkSPfzpT0hBl/2C1pcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGcdmkpOZklqUW6dslcGX0bn/BWPDOoeLu9qwGxilmXYycHBICJhK7Z+1lgrDFJC7cW8/W
	xcjFISSwlFHi674rLDBF0zYsZ4VITGeUmP/0LwuEM4dJ4tynF8wgVWwCGhLfP28Gsjk4RATk
	JQ69zwOpYRa4wizxccUssBphgWCJy7/ngNksAqoSd1Z/YASxeQXcJH5cfAR1hrbEvoaZbCA2
	p4C7RNONk2A1QkA15yYuYIOoWcshcagvHWKOgMS3yYdYQPZKCMhKbDrADFEiKXFwxQ2WCYzC
	CxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIERuzpf88m7mC8f8D6EKMAB6MSD+9G3z0h
	QqyJZcWVuYcYTYE2TGSWEk3OB6aFvJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakF
	qUXxRaU5qcWHGJk4OKUaGM9N5zYyShLRvsKhP9n8mYJACfu1k1MCT36Ky1G4e3158nrL32d8
	Pr3nWLj9EesZAd3/FuejNCxvXuZQXSbzOqTMTdRSg+FizaFDM3Ut+Kax9bGK7f/bXqHmL+ly
	l3Pmav75i388q2dw/7Bw5pV3CrNeaSxmqlzNrW7OoxduOn9Kz0zFp58v6imxFGckGmoxFxUn
	AgBHTgiG0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO7nS3tCDFo62SyuXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4C+
	VVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm9G5/wVjwzqHi7vasBsYp
	Zl2MnBwSAiYS0zYsZ4WwxSQu3FvP1sXIxSEkMJ1RYv7TvywQzhwmiXOfXjCDVLEJaEh8/7wZ
	yObgEBGQlzj0Pg+khlngCrPExxWzwGqEBYIlLv+eA2azCKhK3Fn9gRHE5hVwk/hx8RETxDZt
	iX0NM9lAbE4Bd4mmGyfBaoSAas5NXMA2gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95Pzc
	TYzghPBMagfjygaLQ4wCHIxKPLwcAXtChFgTy4orcw8xSnAwK4nwMl4ACvGmJFZWpRblxxeV
	5qQWH2I0BbpqIrOUaHI+MFnllcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphakFsH0
	MXFwSjUwhrGeU/t305Xv6O7mJe7Wf9qEOicLPo1/OX+y/mumGuEbp7dJ7F0x90h1RYU8O3Mr
	H9eHD+u4Mx2mHH9Xzr9T66PfhTnHG49K3jBkyXF4nFXfIqhuErbUYb3+RUsPU/uFAi8uxK1s
	31qyJsg5WsCDyU/lwcRX7S5Wr9gOLdDbFiXgGmn6gSVCiaU4I9FQi7moOBEAuE5QXB4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the sound machine driver for Trats2 board.
The codec operate in master mode.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 sound/soc/samsung/Kconfig         |   8 ++
 sound/soc/samsung/Makefile        |   2 +
 sound/soc/samsung/trats2_wm1811.c | 218 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 228 insertions(+)
 create mode 100644 sound/soc/samsung/trats2_wm1811.c

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index fc67f97..8031423 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -245,3 +245,11 @@ config SND_SOC_ARNDALE_RT5631_ALC5631
         depends on SND_SOC_SAMSUNG
         select SND_SAMSUNG_I2S
         select SND_SOC_RT5631
+
+config SND_SOC_SAMSUNG_TRATS2_WM1811
+	tristate "SoC I2S Audio support for WM1811 on Tizen Trats2 board"
+	depends on SND_SOC_SAMSUNG
+	select SND_SOC_WM8994
+	select SND_SAMSUNG_I2S
+	help
+	  Say Y if you want to add support for SoC audio on the Tizen Trats2 board.
diff --git a/sound/soc/samsung/Makefile b/sound/soc/samsung/Makefile
index 31e3dba..e2b7b1b 100644
--- a/sound/soc/samsung/Makefile
+++ b/sound/soc/samsung/Makefile
@@ -46,6 +46,7 @@ snd-soc-littlemill-objs := littlemill.o
 snd-soc-bells-objs := bells.o
 snd-soc-odroidx2-max98090-objs := odroidx2_max98090.o
 snd-soc-arndale-rt5631-objs := arndale_rt5631.o
+snd-soc-trats2-wm1811-objs := trats2_wm1811.o
 
 obj-$(CONFIG_SND_SOC_SAMSUNG_JIVE_WM8750) += snd-soc-jive-wm8750.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_NEO1973_WM8753) += snd-soc-neo1973-wm8753.o
@@ -73,3 +74,4 @@ obj-$(CONFIG_SND_SOC_LITTLEMILL) += snd-soc-littlemill.o
 obj-$(CONFIG_SND_SOC_BELLS) += snd-soc-bells.o
 obj-$(CONFIG_SND_SOC_ODROIDX2) += snd-soc-odroidx2-max98090.o
 obj-$(CONFIG_SND_SOC_ARNDALE_RT5631_ALC5631) += snd-soc-arndale-rt5631.o
+obj-$(CONFIG_SND_SOC_SAMSUNG_TRATS2_WM1811) += snd-soc-trats2-wm1811.o
diff --git a/sound/soc/samsung/trats2_wm1811.c b/sound/soc/samsung/trats2_wm1811.c
new file mode 100644
index 0000000..b937612
--- /dev/null
+++ b/sound/soc/samsung/trats2_wm1811.c
@@ -0,0 +1,218 @@
+/*
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <sound/soc.h>
+#include <sound/pcm_params.h>
+#include "i2s.h"
+#include "../codecs/wm8994.h"
+
+struct trats2_machine_priv {
+	struct clk *clk_mclk;
+};
+
+static struct trats2_machine_priv trats2_wm1811_priv;
+
+static const struct snd_kcontrol_new trats2_controls[] = {
+	SOC_DAPM_PIN_SWITCH("SPK"),
+};
+
+static const struct snd_soc_dapm_widget trats2_dapm_widgets[] = {
+	SND_SOC_DAPM_SPK("SPK", NULL),
+};
+
+static int trats2_aif1_hw_params(struct snd_pcm_substream *substream,
+				 struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(rtd->card);
+	unsigned int sysclk_rate;
+	unsigned int mclk_rate =
+			(unsigned int)clk_get_rate(priv->clk_mclk);
+	int ret;
+
+	/* SYSCLK must be greater than 4.096MHz */
+	if (params_rate(params) == 8000 || params_rate(params) == 11025)
+		sysclk_rate = params_rate(params) * 512;
+	else
+		sysclk_rate = params_rate(params) * 256;
+
+	/* Set the codec FLL1 */
+	ret = snd_soc_dai_set_pll(codec_dai, WM8994_FLL1, WM8994_FLL_SRC_MCLK1,
+				  mclk_rate, sysclk_rate);
+	if (ret < 0) {
+		dev_err(codec_dai->dev, "Failed to set FLL1: %d\n", ret);
+		return ret;
+	}
+
+	/* Set the codec SYSCLK */
+	ret = snd_soc_dai_set_sysclk(codec_dai, WM8994_SYSCLK_FLL1,
+				     sysclk_rate, SND_SOC_CLOCK_IN);
+	if (ret < 0) {
+		dev_err(codec_dai->dev, "Failed to set SYSCLK: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int trats2_aif1_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(rtd->card);
+	int ret;
+
+	ret = clk_prepare_enable(priv->clk_mclk);
+	if (ret) {
+		dev_err(rtd->card->dev, "Failed to enable mclk: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void trats2_aif1_shutdown(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(rtd->card);
+
+	clk_disable_unprepare(priv->clk_mclk);
+}
+
+static const struct snd_soc_ops trats2_aif1_ops = {
+	.startup = trats2_aif1_startup,
+	.shutdown = trats2_aif1_shutdown,
+	.hw_params = trats2_aif1_hw_params,
+};
+
+static struct snd_soc_dai_link trats2_dai[] = {
+	{
+		.name		= "WM1811 AIF1",
+		.stream_name	= "Pri_Dai",
+		.codec_dai_name = "wm8994-aif1",
+		.codec_name	= "wm8994-codec",
+		.ops		= &trats2_aif1_ops,
+		.dai_fmt	= SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
+				  SND_SOC_DAIFMT_CBM_CFM,
+	},
+};
+
+static struct snd_soc_card trats2_card = {
+	.owner			= THIS_MODULE,
+
+	.dai_link		= trats2_dai,
+	.num_links		= ARRAY_SIZE(trats2_dai),
+
+	.controls		= trats2_controls,
+	.num_controls		= ARRAY_SIZE(trats2_controls),
+	.dapm_widgets		= trats2_dapm_widgets,
+	.num_dapm_widgets	= ARRAY_SIZE(trats2_dapm_widgets),
+
+	.drvdata		= &trats2_wm1811_priv,
+};
+
+static int trats2_audio_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct snd_soc_card *card = &trats2_card;
+	struct device_node *codec_node;
+	struct snd_soc_dai_link *dai_link = card->dai_link;
+	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(card);
+	int ret;
+
+	if (!np) {
+		dev_err(&pdev->dev, "of node is missing.\n");
+		return -ENODEV;
+	}
+
+	card->dev = &pdev->dev;
+
+	ret = snd_soc_of_parse_card_name(card, "samsung,model");
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Card name is not provided\n");
+		return ret;
+	}
+
+	ret = snd_soc_of_parse_audio_routing(card, "samsung,audio-routing");
+	if (ret) {
+		dev_err(&pdev->dev, "Audio routing is not provided\n");
+		return ret;
+	}
+
+	dai_link->cpu_of_node = of_parse_phandle(np,
+						 "samsung,i2s-controller", 0);
+	if (dai_link->cpu_of_node == NULL) {
+		dev_err(&pdev->dev, "i2s-controller property parse error\n");
+		return -EINVAL;
+	}
+
+	dai_link->platform_of_node = dai_link->cpu_of_node;
+
+	codec_node = of_parse_phandle(np, "samsung,audio-codec", 0);
+	if (codec_node == NULL) {
+		dev_err(&pdev->dev, "audio-codec property parse error\n");
+		return -EINVAL;
+	}
+
+	priv->clk_mclk =  of_clk_get_by_name(codec_node, "MCLK1");
+	if (IS_ERR(priv->clk_mclk)) {
+		dev_err(&pdev->dev, "Failed to get mclk clock\n");
+		of_node_put(codec_node);
+		return PTR_ERR(priv->clk_mclk);
+	}
+	of_node_put(codec_node);
+
+	ret = devm_snd_soc_register_card(&pdev->dev, card);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register card: %d\n", ret);
+		goto clk_put;
+	}
+	return 0;
+
+clk_put:
+	clk_put(priv->clk_mclk);
+	return ret;
+}
+
+static int trats2_audio_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(card);
+
+	clk_put(priv->clk_mclk);
+
+	return 0;
+}
+
+static const struct of_device_id trats2_audio_of_match[] = {
+	{ .compatible	= "samsung,trats2-audio", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, trats2_audio_of_match);
+
+static struct platform_driver trats2_audio_driver = {
+	.driver = {
+		.name		= "trats2-audio",
+		.owner		= THIS_MODULE,
+		.pm		= &snd_soc_pm_ops,
+		.of_match_table	= trats2_audio_of_match,
+	},
+	.probe	= trats2_audio_probe,
+	.remove	= trats2_audio_remove,
+};
+
+module_platform_driver(trats2_audio_driver);
+
+MODULE_AUTHOR("Inha Song <ideal.song@samsung.com>");
+MODULE_DESCRIPTION("ALSA SoC Trats2 Audio Support");
+MODULE_LICENSE("GPL v2");
-- 
2.0.0.390.gcb682f8

