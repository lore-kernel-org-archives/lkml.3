Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbbAWA5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:57:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18223 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbAWA46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:56:58 -0500
X-AuditID: cbfee68d-f79296d000004278-4b-54c19c5867fc
Date: Fri, 23 Jan 2015 09:56:55 +0900
From: Inha Song <ideal.song@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: alsa-devel@alsa-project.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, kgene@kernel.org,
        sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v3 1/4] ASoC: samsung: Add machine driver for
 Trats2
Message-id: <20150123095655.15779875@songinha-Samsung-DeskTop-System>
In-reply-to: <54C0EA03.703@samsung.com>
References: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
 <1421925482-15861-2-git-send-email-ideal.song@samsung.com>
 <54C0EA03.703@samsung.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42JZI2JSpBsx52CIwcWzGhZXLh5ispj68Amb
	xfwj51gt+t8sZLU48GcHo8W5VysZLfofv2a2+Halg8li0+NrrBaXd81hs5hxfh+Txe3LvBZL
	r19kspgwfS2LReeuflaL1r1H2C0Ov2lntbi44guTxcvNb5gchD02fG5i81gzbw2jR0tzD5vH
	5b5eJo+ds+6ye6xc/oXNY9OqTjaPO9f2sHlsXlLvse/tMjaPvi2rGD02n672+LxJLoA3issm
	JTUnsyy1SN8ugSvjxKZlLAWdkhVfJgc2MO4S7mLk5JAQMJG48buDCcIWk7hwbz1bFyMXh5DA
	UkaJSzduscIU7fu/AyqxiFHi/clj7BBOP5PEjKszGEGqWARUJc6vfcMGYrMJaEh8/7yZGcQW
	EdCXWLLqIlg3s8BBZolHLQfBGoQFwiUeHFoFZvMKuEpM2LoIbB2ngLrE06tNzBAbFjBKXJnQ
	ywZxh43E6p3rmCEaBCV+TL7HAmIzC2hJbN7WxAphy0tsXvMWrFlC4AaHxIrGNiaI8wQkvk0+
	BNTAAZSQldh0gBlipqTEwRU3WCYwis1CMnYWkrGzkIxdwMi8ilE0tSC5oDgpvchQrzgxt7g0
	L10vOT93EyMweZz+96x3B+PtA9aHGAU4GJV4eF/OOBAixJpYVlyZe4jRFOiKicxSosn5wBSV
	VxJvaGxmZGFqYmpsZG5ppiTOqyj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD48HjCxm/
	bgxsn+5v961dqCl6vur6Hael5lTnbDvOGefnwzH3tdeTY5Oei59eopc00UhGpHUdayTLDK0N
	269q/dBb9qD1z40e2/u1KU9NL102e+zAd7VT3j1H4Vbi80M/+xdX7sz0Uvp6MkokmIfpz9Gl
	W5Z3LC67mL8qRLuvkvmo++zWvUu3mCqxFGckGmoxFxUnAgDawoTCGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jAd2IOQdDDN4ukLO4cvEQk8XUh0/Y
	LOYfOcdq0f9mIavFgT87GC3OvVrJaNH/+DWzxbcrHUwWmx5fY7W4vGsOm8WM8/uYLG5f5rVY
	ev0ik8WE6WtZLDp39bNatO49wm5x+E07q8XFFV+YLF5ufsPkIOyx4XMTm8eaeWsYPVqae9g8
	Lvf1MnnsnHWX3WPl8i9sHptWdbJ53Lm2h81j85J6j31vl7F59G1Zxeix+XS1x+dNcgG8UQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAjyoplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM05sWsZS0ClZ8WVyYAPjLuEuRk4O
	CQETiX3/d7BB2GISF+6tB7K5OIQEFjFKvD95jB3C6WeSmHF1BiNIFYuAqsT5tW/AOtgENCS+
	f97MDGKLCOhLLFl1EaybWeAgs8SjloNgDcIC4RIPDq0Cs3kFXCUmbF3ECmJzCqhLPL3axAyx
	YQGjxJUJvVB32Eis3rmOGaJBUOLH5HssIDazgJbE5m1NrBC2vMTmNW+ZJzAKzEJSNgtJ2Swk
	ZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKemZ1I7GFc2WBxiFOBgVOLhzSg+ECLE
	mlhWXJl7iFGCg1lJhHdzwcEQId6UxMqq1KL8+KLSnNTiQ4ymwPCYyCwlmpwPTJt5JfGGxiZm
	RpZG5oYWRsbmSuK8SvZtIUIC6YklqdmpqQWpRTB9TBycUg2MR/PqUg943Pc7/kIjwaLqQvyN
	xWtVV09l33Ci5OQpqbk72Po95L4sFOs1/nlMUmADz+Zfc0/INzO91b6x6PqON091rI+zfKlu
	W2H2+uuElGMbdnuFe3p2uLGUpv22Pqk7lcd17vRtTx1f/bsXq+Eq/On21zuTDokvVL331fS0
	oZDLCVvt+dkyy5RYijMSDbWYi4oTAePOAkdjAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for your review.

On Thu, 22 Jan 2015 13:16:03 +0100
Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:

> On 22/01/15 12:17, Inha Song wrote:
> > diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
> > index fc67f97..8031423 100644
> > --- a/sound/soc/samsung/Kconfig
> > +++ b/sound/soc/samsung/Kconfig
> > @@ -245,3 +245,11 @@ config SND_SOC_ARNDALE_RT5631_ALC5631
> >          depends on SND_SOC_SAMSUNG
> >          select SND_SAMSUNG_I2S
> >          select SND_SOC_RT5631
> > +
> > +config SND_SOC_SAMSUNG_TRATS2_WM1811
> > +	tristate "SoC I2S Audio support for WM1811 on Tizen Trats2 board"
> > +	depends on SND_SOC_SAMSUNG
> > +	select SND_SOC_WM8994
> > +	select SND_SAMSUNG_I2S
> 
> Shouldn't you also select the MFD part of WM8994 here ?
Maybe, I will add also "select MFD_WM8994"

> 
> > +++ b/sound/soc/samsung/trats2_wm1811.c
> > @@ -0,0 +1,218 @@
> 
> > +static struct snd_soc_dai_link trats2_dai[] = {
> > +	{
> > +		.name		= "WM1811 AIF1",
> > +		.stream_name	= "Pri_Dai",
> 
> Could we have a less cryptic name here, e.g. "HiFi Primary" ?

Looks like "HiFi Primary", I will fix.

> 
> > +		.codec_dai_name = "wm8994-aif1",
> > +		.codec_name	= "wm8994-codec",
> > +		.ops		= &trats2_aif1_ops,
> > +		.dai_fmt	= SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
> > +				  SND_SOC_DAIFMT_CBM_CFM,
> > +	},
> > +};
> 
> > +static int trats2_audio_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct snd_soc_card *card = &trats2_card;
> > +	struct device_node *codec_node;
> > +	struct snd_soc_dai_link *dai_link = card->dai_link;
> > +	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(card);
> > +	int ret;
> > +
> > +	if (!np) {
> > +		dev_err(&pdev->dev, "of node is missing.\n");
> > +		return -ENODEV;
> 
> I'd say this whole np test could be dropped, we will fail right below
> at the snd_soc_of_parse_card_name() function call if np is NULL.
> Such a situation seems highly unlikely anyway.
I will remove :)

> 
> > +	}
> > +
> > +	card->dev = &pdev->dev;
> > +
> > +	ret = snd_soc_of_parse_card_name(card, "samsung,model");
> > +	if (ret) {
> > +		dev_err(&pdev->dev,
> > +			"Card name is not provided\n");
> 
> I guess it would fit in a single line.
Oh, Thanks.

> 
> > +		return ret;
> > +	}
> > +
> 
> > +static struct platform_driver trats2_audio_driver = {
> > +	.driver = {
> > +		.name		= "trats2-audio",
> > +		.owner		= THIS_MODULE,
> 
> You can drop this .owner field assignment, it's also done in
> module_platform_driver() macro.
> 
Yes, I will fix based on your comments :)
Thanks,

Best Regards,
Inha Song.

> > +		.pm		= &snd_soc_pm_ops,
> > +		.of_match_table	= trats2_audio_of_match,
> > +	},
> > +	.probe	= trats2_audio_probe,
> > +	.remove	= trats2_audio_remove,
> > +};
> > +
> > +module_platform_driver(trats2_audio_driver);
> 
> --
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
