Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbbAVLT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:19:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15666 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbbAVLSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:18:23 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-30-54c0dc7cc575
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
Subject: [alsa-devel] [PATCH v3 1/4] ASoC: samsung: Add machine driver for
 Trats2
Date: Thu, 22 Jan 2015 20:17:59 +0900
Message-id: <1421925482-15861-2-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
References: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkRLfmzoEQg65zhhZXLh5ispj68Amb
	xfwj51gt+t8sZLU48GcHo8Wuv/cZLc69Wslo0f/4NbPFtysdTBabHl9jtbi8aw6bxYzz+5gs
	bl/mtVh6/SKTxYTpa1ksOnf1s1q07j3CbnH4TTurxcUVX5gsXm5+w+Qg4rHhcxObx5p5axg9
	Wpp72Dwu9/UyeeycdZfdY+XyL2wem1Z1snncubaHzWPzknqPfW+XsXn0bVnF6LH5dLXH501y
	AbxRXDYpqTmZZalF+nYJXBm9218wFrxzqLi7PauBcYpZFyMnh4SAicSTFT+ZIWwxiQv31rN1
	MXJxCAksZZQ48KCTpYuRA6xo90IpiPgiRonFL1ZBFc1hktg08ylYN5uAhsT3z5uZQRpEBOQl
	Dr3PA6lhFrjCLPFxxSywGmGBYIm5B2eygNgsAqoSR7/tAbN5BdwkNi24yApxhbbEvoaZbCA2
	p4C7xM27W8FsIaCatX2TGCFq1nJIPLiqCTFHQOLb5ENQh8pKbDoA9YykxMEVN1gmMAovYGRY
	xSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREYr6f/PZuwg/HeAetDjAIcjEo8vBnFB0KEWBPL
	iitzDzGaAm2YyCwlmpwPTAp5JfGGxmZGFqYmpsZG5pZmSuK8r6V+BgsJpCeWpGanphakFsUX
	leakFh9iZOLglGpgFFuymHM9K+tvsboJG0+E3Cr6r/G6pc0+27VhyvcV8ea72QVcvSwi3v/f
	oXF5WdCUU1afyhhXtLasSt7y4fYBoYMu1w98CTtuPdPZcoZvTIj00/lsk2tbc8NPTbsiU/o2
	Q1CcQelz6pxfC0QL5T7cVboSvubnsvBbE6fUKF6e1D1pupbKhyXr0pRYijMSDbWYi4oTARW7
	X6rSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG7NnQMhBsfnqFlcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM6N3+grHgnUPF3e1ZDYxT
	zLoYOTgkBEwkdi+U6mLkBDLFJC7cW8/WxcjFISSwiFFi8YtVUM4cJolNM58yg1SxCWhIfP+8
	mRmkWURAXuLQ+zyQGmaBK8wSH1fMAqsRFgiWmHtwJguIzSKgKnH02x4wm1fATWLTgousENu0
	JfY1zGQDsTkF3CVu3t0KZgsB1aztm8Q4gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95Pzc
	TYzgdPBMegfjqgaLQ4wCHIxKPLwZxQdChFgTy4orcw8xSnAwK4nwmp4ACvGmJFZWpRblxxeV
	5qQWH2I0BbpqIrOUaHI+MFXllcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphakFsH0
	MXFwSjUwWjwuyGnX41UzepHox8p3z1l2g4+7RI3WwcSc/BvdlSHibl5/L/I2ux3s3KryZOvO
	w4sm5SjZX/p2pU+g+Jm9U2/p8o6lD7vb4uvsC+7pL1/Yknz/TNOPR957nE0abXh2b31seuUv
	c4K39HHOoBcdwcE/ZG9kyfE0HnkrNcnsbtuxmGUHClOUWIozEg21mIuKEwEg+cR5HQMAAA==
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

