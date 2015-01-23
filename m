Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbbAWFED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:04:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11979 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbbAWFDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:03:51 -0500
X-AuditID: cbfee691-f79b86d000004a5a-9e-54c1d631543c
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
Subject: [alsa-devel] [PATCH v4 1/3] ASoC: samsung: Add machine driver for
 Trats2
Date: Fri, 23 Jan 2015 14:03:28 +0900
Message-id: <1421989410-12490-2-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
References: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWyRsSkUNfw2sEQg7+vuC2uXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijuGxSUnMyy1KL9O0SuDJ27Z7JUtDjUDF12Q/GBsbzpl2MnBwSAiYSnz9tZoKwxSQu3FvP
	1sXIxSEksJRRYsPCflaYotnvzjFBJKYzSiy+doAZwpnDJDFxxmo2kCo2AQ2J7583AyU4OEQE
	5CUOvc8DqWEWuMIs8XHFLGaQGmGBYIk/i16DrWMRUJX41vsVrJdXwE1i3apVjBDbtCX2Ncxk
	A5nDKeAu8fsQL0hYCKjk4M2bYHslBLZwSOw9PA9qjoDEt8mHWEDqJQRkJTYdYIYYIylxcMUN
	lgmMwgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBMbs6X/PJu5gvH/A+hCjAAejEg9v
	w5aDIUKsiWXFlbmHGE2BNkxklhJNzgcmhrySeENjMyMLUxNTYyNzSzMlcV4d6Z/BQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhjXTUldMsnmUYeHt7IX85TcoEMvqqb9Wrfj0x/tMzv3FZ1n
	MT4sLbXQ7uyuLy4v1T//0XscImd1u/hJ14P0HW8ueRcGnnqilT5fnys4tLMxt7tlHlPmY8eL
	VtL+x14wqVoc2Su8JD43d1vEg+2VV5tqmde8DTW6OmXWU7Gvp4WPbNM7nbwwlK1GiaU4I9FQ
	i7moOBEArsaMFtQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoK7htYMhBg1eFlcuHmKymPrwCZvF
	/CPnWC363yxktTjwZwejxa6/9xktzr1ayWjR//g1s8W3Kx1MFpseX2O1uLxrDpvFjPP7mCxu
	X+a1WHr9IpPFhOlrWSw6d/WzWrTuPcJucfhNO6vFxRVfmCxebn7D5CDiseFzE5vHmnlrGD1a
	mnvYPC739TJ57Jx1l91j5fIvbB6bVnWyedy5tofNY/OSeo99b5exefRtWcXosfl0tcfnTXIB
	vFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QM8q
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDN27Z7JUtDjUDF12Q/GBsbz
	pl2MnBwSAiYSs9+dY4KwxSQu3FvP1sXIxSEkMJ1RYvG1A8wQzhwmiYkzVrOBVLEJaEh8/7wZ
	KMHBISIgL3HofR5IDbPAFWaJjytmMYPUCAsES/xZ9BpsKouAqsS33q9gvbwCbhLrVq1ihNim
	LbGvYSYbyBxOAXeJ34d4QcJCQCUHb95knsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcDp4JrWDcWWDxSFGAQ5GJR7ehi0HQ4RYE8uKK3MPMUpwMCuJ8D45ABTiTUmsrEotyo8v
	Ks1JLT7EaAp01ERmKdHkfGCqyiuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C
	6WPi4JRqYJwW3v1y30teX76ifKNwjeeSM28Knfi6m0G0S4G/LvS0vI+d1sE10eelFr5Tbbhv
	uPn9K4m5T3fach3nExYtjund87aFP+evkUjmylvPPvfMX6U2f63n02UmylqZUtEpG7Q/pXYF
	N+r8deWWVWx4u/l889OLynMeyU17+jZv3nljAY1d20W+FiixFGckGmoxFxUnAgCHLsk1HQMA	AA==
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
 sound/soc/samsung/Kconfig         |   9 ++
 sound/soc/samsung/Makefile        |   2 +
 sound/soc/samsung/trats2_wm1811.c | 211 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 222 insertions(+)
 create mode 100644 sound/soc/samsung/trats2_wm1811.c

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index fc67f97..df6734d 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -245,3 +245,12 @@ config SND_SOC_ARNDALE_RT5631_ALC5631
         depends on SND_SOC_SAMSUNG
         select SND_SAMSUNG_I2S
         select SND_SOC_RT5631
+
+config SND_SOC_SAMSUNG_TRATS2_WM1811
+	tristate "SoC I2S Audio support for WM1811 on Tizen Trats2 board"
+	depends on SND_SOC_SAMSUNG
+	select SND_SAMSUNG_I2S
+	select MFD_WM8994
+	select SND_SOC_WM8994
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
index 0000000..e87ea1f
--- /dev/null
+++ b/sound/soc/samsung/trats2_wm1811.c
@@ -0,0 +1,211 @@
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
+		.stream_name	= "HiFi Primary",
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
+	card->dev = &pdev->dev;
+
+	ret = snd_soc_of_parse_card_name(card, "samsung,model");
+	if (ret) {
+		dev_err(&pdev->dev, "Card name is not provided\n");
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

