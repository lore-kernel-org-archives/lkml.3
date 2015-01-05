Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbbAEMkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:40:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51646 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbbAEMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:40:43 -0500
X-AuditID: cbfee68e-f79b46d000002b74-05-54aa8648e32a
Date: Mon, 05 Jan 2015 21:40:39 +0900
From: Inha Song <ideal.song@samsung.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: alsa-devel@alsa-project.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, sbkim73@samsung.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, lgirdwood@gmail.com,
        tiwai@suse.de, broonie@kernel.org, kgene@kernel.org,
        s.nawrocki@samsung.com, galak@codeaurora.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: samsung: Add machine driver for
 Trats2
Message-id: <20150105214039.2f6065fe@songinha-Samsung-DeskTop-System>
In-reply-to: <54AA7A0B.2070004@metafoo.de>
References: <1420457117-11030-1-git-send-email-ideal.song@samsung.com>
 <1420457117-11030-2-git-send-email-ideal.song@samsung.com>
 <54AA7A0B.2070004@metafoo.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42JZI2JSqOvRtirE4NVaK4srFw8xWUx9+ITN
	Yv6Rc6wW/W8Wsloc+LOD0eLcq5WMFv2PXzNbLJk8n9Xi25UOJotNj6+xWlzeNYfNYsb5fUwW
	ty/zWiy9fpHJYsL0tSwWrXuPsFscftPOanFxxRcmi5eb3zA5CHts+NzE5rFm3hpGj5bmHjaP
	y329TB47Z91l91i5/Aubx6ZVnWwed67tYfPYvKTeY8mbQ6wefVtWMXpsPl3t8XmTXABvFJdN
	SmpOZllqkb5dAlfG/yPXmAtapCt2tp5hbGDsFe1i5OSQEDCRePh5AjOELSZx4d56ti5GLg4h
	gaWMEruWbmGCKdpzqoMVIrGIUeLxiT3sEE4/k8SlF2fB2lkEVCVW/7rNBmKzCWhIfP+8GSwu
	AmT/fzMJrIFZ4CSzxP8Z28HGCguESMxddAysgVfAVaJhSxdYA6eAlsTSH8dZQWwhgcWMEmsa
	JCHOsJFYvXMdM0S9oMSPyfdYQGxmoPrN25pYIWx5ic1r3jKDLJMQuMEhcbn1AhvEdQIS3yYf
	AmrgAErISmw6APWzpMTBFTdYJjCKzUIydhaSsbOQjF3AyLyKUTS1ILmgOCm9yEivODG3uDQv
	XS85P3cTIzB5nP73rG8H480D1ocYBTgYlXh4PU6sDBFiTSwrrsw9xGgKdMVEZinR5Hxgisor
	iTc0NjOyMDUxNTYytzRTEudNkPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxfUrCe6e5
	M/oC/DvZ+CLebIitXHT0IEdn6LUD542mi1f6ljDc0hDWkvNqm9Bs8aaxP+igJvN16R+Xdy8U
	+B23I2mntZbWU7O3FU5r/sgk2pdFzjC4KDU789HC2Ln50VfsZhivtWP5Ejt7Q5HfzL8r+I+V
	9TT360c/YVZ33FP2KL58LfscRSElluKMREMt5qLiRAACzpJmGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jAV2PtlUhBmuPGlhcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBbnXq1ktOh//JrZYsnk+awW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2WxaN17hN3i8Jt2VouLK74wWbzc/IbJQdhjw+cmNo8189YwerQ097B5
	XO7rZfLYOesuu8fK5V/YPDat6mTzuHNtD5vH5iX1HkveHGL16NuyitFj8+lqj8+b5AJ4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAHlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZvw/co25oEW6YmfrGcYGxl7RLkZO
	DgkBE4k9pzpYIWwxiQv31rN1MXJxCAksYpR4fGIPO4TTzyRx6cVZZpAqFgFVidW/brOB2GwC
	GhLfP28Gi4sA2f/fTAJrYBY4ySzxf8Z2JpCEsECIxNxFx8AaeAVcJRq2dIE1cApoSSz9cRxs
	tZDAYkaJNQ2SEGfYSKzeuY4Zol5Q4sfkeywgNjNQ/eZtTawQtrzE5jVvmScwCsxCUjYLSdks
	JGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSnpmfSOxhXNVgcYhTgYFTi4fU4sTJE
	iDWxrLgy9xCjBAezkgjvq/RVIUK8KYmVValF+fFFpTmpxYcYTYHBMZFZSjQ5H5g280riDY1N
	zIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGKPr3V7X1qfcu6k36Tz/EXMx
	Fz8vJ3E33mdbt3wMf6nykOnlzayAHMOWo3ExkydPmGOYZd2ytfqD5AKNoFevdFe0iN5QyO45
	76xVzxpzMbLe5vndXO4+BtUAUW2bJyovTn21vLyY+Xn/f6ULVVZ+Mz3OB//4OGX/iU2v/edv
	m9f4z6I77drmE0osxRmJhlrMRcWJAHHPPZ1jAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your comments.


> Hi,
> 
> A few small comments inline.
> 
> On 01/05/2015 12:25 PM, Inha Song wrote:
> > --- /dev/null
> > +++ b/sound/soc/samsung/trats2_wm1811.c
> > @@ -0,0 +1,216 @@
> >[...]
> > +#include <linux/of.h>
> > +#include <linux/module.h>
> > +#include <linux/clk.h>
> > +#include <sound/soc.h>
> > +#include <sound/pcm_params.h>
> > +#include "i2s.h"
> > +#include "i2s-regs.h"
> 
> You probably don't need i2s-regs.h

OK, I will remove.

> 
> > +#include "../codecs/wm8994.h"
> > +
> > +struct trats2_machine_priv {
> > +	struct clk *clk_mclk;
> > +};
> > +
> > +static struct trats2_machine_priv trats2_wm1811_priv;
> > +
> > +static const struct snd_kcontrol_new trats2_controls[] = {
> > +	SOC_DAPM_PIN_SWITCH("SPK"),
> > +};
> > +
> > +const struct snd_soc_dapm_widget trats2_dapm_widgets[] = {
> 
> static

Sorry for my mistake.

> 
> > +	SND_SOC_DAPM_SPK("SPK", NULL),
> > +};
> > +
> > +static int trats2_aif1_hw_params(struct snd_pcm_substream *substream,
> > +				 struct snd_pcm_hw_params *params)
> > +{
> > +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> > +	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
> > +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
> > +	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(rtd->card);
> > +	unsigned int sysclk_rate;
> > +	unsigned int mclk_rate =
> > +			(unsigned int)clk_get_rate(priv->clk_mclk);
> > +	int ret;
> > +
> > +	/* Set the codec DAI configuration to Master*/
> > +	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S
> > +					| SND_SOC_DAIFMT_NB_NF
> > +					| SND_SOC_DAIFMT_CBM_CFM);
> > +	if (ret < 0) {
> > +		dev_err(codec_dai->dev,
> > +			"Failed to set codec dai format: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	/* Set the cpu DAI configuration to Slave */
> > +	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S
> > +					| SND_SOC_DAIFMT_NB_NF
> > +					| SND_SOC_DAIFMT_CBM_CFM);
> > +	if (ret < 0) {
> > +		dev_err(cpu_dai->dev,
> > +			"Failed to set cpu dai format: %d\n", ret);
> > +		return ret;
> > +	}
> 
> 
> Use the dai_fmt field in the dai_link struct to setup the DAI link format. 
> This will configure both the CPU and the CODEC DAI with the specified 
> format, no need to do it manually.

Ok, move to dai_fmt.

> 
> >[...]
> > +static struct snd_soc_ops trats2_aif1_ops = {
> 
> const

I will fix this.

> 
> > +	.hw_params = trats2_aif1_hw_params,
> > +};
> > +
> > +static int trats2_init_paiftx(struct snd_soc_pcm_runtime *rtd)
> > +{
> > +	struct snd_soc_codec *codec = rtd->codec;
> > +	struct snd_soc_card *card = rtd->card;
> > +	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(card);
> > +	int ret;
> > +
> > +	ret = clk_prepare_enable(priv->clk_mclk);
> 
> Maybe just do this in the platform device probe handler and you should have 
> a matching disable call somewhere.

Ok, I will move clk_prepare_enable call to snd_soc_ops->startup
and clk_disable_unprepare call to snd_soc_ops->shutdown.

Best Regards,
Inha Song.

> 
> > +	if (ret) {
> > +		dev_err(codec->dev, "Failed to enable mclk: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> >[...]
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
