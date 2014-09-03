Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaICDhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:37:11 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:56940
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754465AbaICDhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:37:08 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "moinejf@free.fr" <moinejf@free.fr>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "jsarha@ti.com" <jsarha@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCHv2 1/4] ASoC: simple-card: add
	asoc_simple_card_fmt_master() to simplify the code.
Thread-Topic: [alsa-devel] [PATCHv2 1/4] ASoC: simple-card: add
	asoc_simple_card_fmt_master() to simplify the code.
Thread-Index: AQHPxw3FkVXoEiy3Ik67hTArHzRsZZvuqWVggAAYOuA=
Date: Wed, 3 Sep 2014 03:37:04 +0000
Message-ID: <df7936d5863948b0a0a33aa8283d6a67@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
 <87egvt7dmd.wl%kuninori.morimoto.gx@gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199003)(13464003)(164054003)(377454003)(51704005)(76176999)(46102001)(33646002)(101416001)(74502001)(90102001)(50986999)(54356999)(106356001)(20776003)(95666004)(31966008)(99286002)(107046002)(83072002)(74662001)(105586002)(85852003)(85306004)(77982001)(77096002)(74316001)(83322001)(80022001)(81542001)(19580405001)(76576001)(106116001)(19580395003)(87936001)(66066001)(92566001)(575784001)(4396001)(81342001)(108616004)(79102001)(21056001)(86362001)(99396002)(2656002)(76482001)(64706001)(15866825004)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kuninori-san,

Yes your patch has fixed the bug Jyri has pointed out.

So I has discard my [PATCHv2 1/4] patch.

Please send your patch out to replace this one.

Thanks,

BRs
Xiubo



> -----Original Message-----
> From: Xiubo Li-B47053
> Sent: Wednesday, September 03, 2014 10:22 AM
> To: 'Kuninori Morimoto'
> Cc: broonie@kernel.org; perex@perex.cz; lgirdwood@gmail.com; tiwai@suse.de;
> moinejf@free.fr; andrew@lunn.ch; kuninori.morimoto.gx@renesas.com;
> jsarha@ti.com; devicetree@vger.kernel.org; alsa-devel@alsa-project.org;
> robh+dt@kernel.org; pawel.moll@arm.com; mark.rutland@arm.com;
> ijc+devicetree@hellion.org.uk; galak@codeaurora.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [alsa-devel] [PATCHv2 1/4] ASoC: simple-card: add
> asoc_simple_card_fmt_master() to simplify the code.
> 
> Hi Kuninori-san,
> 
> Yes, I think it make sense to set all fmt in one function, and will
> Be more readable.
> 
> I agree with you, could you please just wait, because there has many
> Replications and good Ideas about this patch, and I will revise it.
> Then you can improve it as your patch blow.
> 
> 
> Thanks,
> 
> BRs
> Xiubo
> 
> 
> > Subject: Re: [alsa-devel] [PATCHv2 1/4] ASoC: simple-card: add
> > asoc_simple_card_fmt_master() to simplify the code.
> >
> >
> > Hi Xiubo
> >
> > I was very surprised about this patch
> > because the idea is same as my local patch
> > (I was planned to send it to ML :)
> >
> > I attached my local patch to sharing idea.
> >
> > > +static inline unsigned int
> > > +asoc_simple_card_fmt_master(struct device_node *np,
> > > +			    struct device_node *bitclkmaster,
> > > +			    struct device_node *framemaster)
> > > +{
> > > +	switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
> > > +	case 0x11:
> > > +		return SND_SOC_DAIFMT_CBS_CFS;
> > > +	case 0x10:
> > > +		return SND_SOC_DAIFMT_CBS_CFM;
> > > +	case 0x01:
> > > +		return SND_SOC_DAIFMT_CBM_CFS;
> > > +	default:
> > > +		return SND_SOC_DAIFMT_CBM_CFM;
> > > +	}
> > > +
> > > +	/* Shouldn't be here */
> > > +	return -EINVAL;
> > > +}
> >
> > I think this concept is nice,
> > but setting all fmt in this function is good for me
> > see my local patch
> >
> > ----------
> > From 85562eb1587e5c184e4f4e0b183bd7063aaa81b7 Mon Sep 17 00:00:00 2001
> > From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > Date: Thu, 28 Aug 2014 19:20:14 +0900
> > Subject: [PATCH] ASoC: simple-card: add asoc_simple_card_parse_daifmt()
> >
> > Current daifmt setting method in simple-card driver is
> > placed to many places, and using un-readable/confusable method.
> > This patch adds new asoc_simple_card_parse_daifmt()
> > and tidyup code.
> >
> > Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> >
> > diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-
> card.c
> > index bea5901..c932103 100644
> > --- a/sound/soc/generic/simple-card.c
> > +++ b/sound/soc/generic/simple-card.c
> > @@ -167,6 +167,64 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
> >  	return 0;
> >  }
> >
> > +static int asoc_simple_card_parse_daifmt(struct device_node *node,
> > +					 struct simple_card_data *priv,
> > +					 struct device_node *cpu,
> > +					 struct device_node *codec,
> > +					 char *prefix, int idx)
> > +{
> > +	struct device *dev = simple_priv_to_dev(priv);
> > +	struct device_node *bitclkmaster = NULL;
> > +	struct device_node *framemaster = NULL;
> > +	struct simple_dai_props *dai_props = simple_priv_to_props(priv, idx);
> > +	struct asoc_simple_dai *cpu_dai = &dai_props->cpu_dai;
> > +	struct asoc_simple_dai *codec_dai = &dai_props->codec_dai;
> > +	unsigned int daifmt;
> > +
> > +	daifmt = snd_soc_of_parse_daifmt(node, prefix,
> > +					 &bitclkmaster, &framemaster);
> > +	daifmt &= ~SND_SOC_DAIFMT_MASTER_MASK;
> > +
> > +	if (strlen(prefix) && !bitclkmaster && !framemaster) {
> > +		/*
> > +		 * No dai-link level and master setting was not found from
> > +		 * sound node level, revert back to legacy DT parsing and
> > +		 * take the settings from codec node.
> > +		 */
> > +		dev_dbg(dev, "Revert to legacy daifmt parsing\n");
> > +
> > +		cpu_dai->fmt = codec_dai->fmt =
> > +			snd_soc_of_parse_daifmt(codec, NULL, NULL, NULL) |
> > +			(daifmt & ~SND_SOC_DAIFMT_CLOCK_MASK);
> > +	} else {
> > +
> > +		switch (((codec == bitclkmaster) << 4) | (codec == framemaster))
> > {
> > +		case 0x11:
> > +			daifmt |= SND_SOC_DAIFMT_CBM_CFM;
> > +			break;
> > +		case 0x10:
> > +			daifmt |= SND_SOC_DAIFMT_CBM_CFS;
> > +			break;
> > +		case 0x01:
> > +			daifmt |= SND_SOC_DAIFMT_CBS_CFM;
> > +			break;
> > +		default:
> > +			daifmt |= SND_SOC_DAIFMT_CBS_CFS;
> > +			break;
> > +		}
> > +
> > +		cpu_dai->fmt = daifmt;
> > +		codec_dai->fmt = daifmt;
> > +	}
> > +
> > +	if (bitclkmaster)
> > +		of_node_put(bitclkmaster);
> > +	if (framemaster)
> > +		of_node_put(framemaster);
> > +
> > +	return 0;
> > +}
> > +
> >  static int asoc_simple_card_dai_link_of(struct device_node *node,
> >  					struct simple_card_data *priv,
> >  					int idx,
> > @@ -175,10 +233,8 @@ static int asoc_simple_card_dai_link_of(struct
> > device_node *node,
> >  	struct device *dev = simple_priv_to_dev(priv);
> >  	struct snd_soc_dai_link *dai_link = simple_priv_to_link(priv, idx);
> >  	struct simple_dai_props *dai_props = simple_priv_to_props(priv, idx);
> > -	struct device_node *np = NULL;
> > -	struct device_node *bitclkmaster = NULL;
> > -	struct device_node *framemaster = NULL;
> > -	unsigned int daifmt;
> > +	struct device_node *cpu = NULL;
> > +	struct device_node *codec = NULL;
> >  	char *name;
> >  	char prop[128];
> >  	char *prefix = "";
> > @@ -187,82 +243,35 @@ static int asoc_simple_card_dai_link_of(struct
> > device_node *node,
> >  	if (is_top_level_node)
> >  		prefix = "simple-audio-card,";
> >
> > -	daifmt = snd_soc_of_parse_daifmt(node, prefix,
> > -					 &bitclkmaster, &framemaster);
> > -	daifmt &= ~SND_SOC_DAIFMT_MASTER_MASK;
> > -
> >  	snprintf(prop, sizeof(prop), "%scpu", prefix);
> > -	np = of_get_child_by_name(node, prop);
> > -	if (!np) {
> > +	cpu = of_get_child_by_name(node, prop);
> > +
> > +	snprintf(prop, sizeof(prop), "%scodec", prefix);
> > +	codec = of_get_child_by_name(node, prop);
> > +
> > +	if (!cpu || !codec) {
> >  		ret = -EINVAL;
> >  		dev_err(dev, "%s: Can't find %s DT node\n", __func__, prop);
> >  		goto dai_link_of_err;
> >  	}
> >
> > -	ret = asoc_simple_card_sub_parse_of(np, &dai_props->cpu_dai,
> > -					    &dai_link->cpu_of_node,
> > -					    &dai_link->cpu_dai_name);
> > +	ret = asoc_simple_card_parse_daifmt(node, priv,
> > +					    cpu, codec, prefix, idx);
> >  	if (ret < 0)
> >  		goto dai_link_of_err;
> >
> > -	dai_props->cpu_dai.fmt = daifmt;
> > -	switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
> > -	case 0x11:
> > -		dai_props->cpu_dai.fmt |= SND_SOC_DAIFMT_CBS_CFS;
> > -		break;
> > -	case 0x10:
> > -		dai_props->cpu_dai.fmt |= SND_SOC_DAIFMT_CBS_CFM;
> > -		break;
> > -	case 0x01:
> > -		dai_props->cpu_dai.fmt |= SND_SOC_DAIFMT_CBM_CFS;
> > -		break;
> > -	default:
> > -		dai_props->cpu_dai.fmt |= SND_SOC_DAIFMT_CBM_CFM;
> > -		break;
> > -	}
> > -
> > -	of_node_put(np);
> > -	snprintf(prop, sizeof(prop), "%scodec", prefix);
> > -	np = of_get_child_by_name(node, prop);
> > -	if (!np) {
> > -		ret = -EINVAL;
> > -		dev_err(dev, "%s: Can't find %s DT node\n", __func__, prop);
> > +	ret = asoc_simple_card_sub_parse_of(cpu, &dai_props->cpu_dai,
> > +					    &dai_link->cpu_of_node,
> > +					    &dai_link->cpu_dai_name);
> > +	if (ret < 0)
> >  		goto dai_link_of_err;
> > -	}
> >
> > -	ret = asoc_simple_card_sub_parse_of(np, &dai_props->codec_dai,
> > +	ret = asoc_simple_card_sub_parse_of(codec, &dai_props->codec_dai,
> >  					    &dai_link->codec_of_node,
> >  					    &dai_link->codec_dai_name);
> >  	if (ret < 0)
> >  		goto dai_link_of_err;
> >
> > -	if (strlen(prefix) && !bitclkmaster && !framemaster) {
> > -		/* No dai-link level and master setting was not found from
> > -		   sound node level, revert back to legacy DT parsing and
> > -		   take the settings from codec node. */
> > -		dev_dbg(dev, "%s: Revert to legacy daifmt parsing\n",
> > -			__func__);
> > -		dai_props->cpu_dai.fmt = dai_props->codec_dai.fmt =
> > -			snd_soc_of_parse_daifmt(np, NULL, NULL, NULL) |
> > -			(daifmt & ~SND_SOC_DAIFMT_CLOCK_MASK);
> > -	} else {
> > -		dai_props->codec_dai.fmt = daifmt;
> > -		switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
> > -		case 0x11:
> > -			dai_props->codec_dai.fmt |= SND_SOC_DAIFMT_CBM_CFM;
> > -			break;
> > -		case 0x10:
> > -			dai_props->codec_dai.fmt |= SND_SOC_DAIFMT_CBM_CFS;
> > -			break;
> > -		case 0x01:
> > -			dai_props->codec_dai.fmt |= SND_SOC_DAIFMT_CBS_CFM;
> > -			break;
> > -		default:
> > -			dai_props->codec_dai.fmt |= SND_SOC_DAIFMT_CBS_CFS;
> > -			break;
> > -		}
> > -	}
> > -
> >  	if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name) {
> >  		ret = -EINVAL;
> >  		goto dai_link_of_err;
> > @@ -304,12 +313,10 @@ static int asoc_simple_card_dai_link_of(struct
> > device_node *node,
> >  	dai_link->cpu_dai_name = NULL;
> >
> >  dai_link_of_err:
> > -	if (np)
> > -		of_node_put(np);
> > -	if (bitclkmaster)
> > -		of_node_put(bitclkmaster);
> > -	if (framemaster)
> > -		of_node_put(framemaster);
> > +	if (cpu)
> > +		of_node_put(cpu);
> > +	if (codec)
> > +		of_node_put(codec);
> >  	return ret;
> >  }
> >
> > ---------
> >
> > Best regards
> > ---
> > Kuninori Morimoto
