Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaHYHPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:15:00 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:53487
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932071AbaHYHO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:14:59 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "timur@tabi.org" <timur@tabi.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
CC: "galak@codeaurora.org" <galak@codeaurora.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv3] ASoC: fsl-sai: rename big_endian_data to is_lsb_first.
Thread-Topic: [PATCHv3] ASoC: fsl-sai: rename big_endian_data to is_lsb_first.
Thread-Index: AQHPwDPa2Tc+TuCOsEqSU2Bf6tDbA5vg58eg
Date: Mon, 25 Aug 2014 07:14:38 +0000
Message-ID: <bfd6fcf7ff004d60ad97ce051434aae2@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1408950191-15809-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1408950191-15809-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(199003)(189002)(164054003)(53754006)(51704005)(377454003)(74662001)(31966008)(99286002)(85852003)(106356001)(92566001)(76482001)(95666004)(90102001)(50986999)(46102001)(81542001)(81342001)(80022001)(4396001)(74502001)(107046002)(2656002)(21056001)(76576001)(83072002)(77982001)(76176999)(19580395003)(105586002)(20776003)(33646002)(77096002)(83322001)(79102001)(54356999)(575784001)(106116001)(86362001)(101416001)(19580405001)(66066001)(99396002)(87936001)(85306004)(64706001)(108616004)(74316001)(2201001)(2501001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please ignore this patch.

Have sent the wrong one.

Thanks,

BRs
Xiubo



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Monday, August 25, 2014 3:03 PM
> To: broonie@kernel.org; nicoleotsuka@gmail.com; timur@tabi.org;
> lgirdwood@gmail.com; perex@perex.cz; tiwai@suse.de; alsa-devel@alsa-
> project.org
> Cc: galak@codeaurora.org; mark.rutland@arm.com; robh+dt@kernel.org;
> pawel.moll@arm.com; linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCHv3] ASoC: fsl-sai: rename big_endian_data to is_lsb_first.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  Documentation/devicetree/bindings/sound/fsl-sai.txt | 8 ++++----
>  sound/soc/fsl/fsl_sai.c                             | 6 +++---
>  sound/soc/fsl/fsl_sai.h                             | 2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt
> b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> index 06a405e..929ca74 100644
> --- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
> +++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> @@ -20,9 +20,9 @@ Required properties:
>    See ../pinctrl/pinctrl-bindings.txt for details of the property values.
>  - big-endian: Boolean property, required if all the FTM_PWM registers
>    are big-endian rather than little-endian.
> -- big-endian-data: If this property is absent, the little endian mode will
> -  be in use as default, or the big endian mode will be in use for all the
> -  fifo data.
> +- lsb-first: Configures whether the LSB or the MSB is transmitted first for
> +  the fifo data. If this property is absent, the LSB is transmitted first as
> +  default, or the MSB is transmitted first.
>  - fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
>    that SAI will work in the synchronous mode (sync Tx with Rx) which means
>    both the transimitter and receiver will send and receive data by following
> @@ -53,5 +53,5 @@ sai2: sai@40031000 {
>  	      dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
>  		   <&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;
>  	      big-endian;
> -	      big-endian-data;
> +	      lsb-first;
>  };
> diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> index a6eb784..7eeb1dd 100644
> --- a/sound/soc/fsl/fsl_sai.c
> +++ b/sound/soc/fsl/fsl_sai.c
> @@ -175,7 +175,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai
> *cpu_dai,
>  	bool tx = fsl_dir == FSL_FMT_TRANSMITTER;
>  	u32 val_cr2 = 0, val_cr4 = 0;
> 
> -	if (!sai->big_endian_data)
> +	if (!sai->is_lsb_first)
>  		val_cr4 |= FSL_SAI_CR4_MF;
> 
>  	/* DAI mode */
> @@ -304,7 +304,7 @@ static int fsl_sai_hw_params(struct snd_pcm_substream
> *substream,
>  	val_cr5 |= FSL_SAI_CR5_WNW(word_width);
>  	val_cr5 |= FSL_SAI_CR5_W0W(word_width);
> 
> -	if (sai->big_endian_data)
> +	if (sai->is_lsb_first)
>  		val_cr5 |= FSL_SAI_CR5_FBT(0);
>  	else
>  		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
> @@ -573,7 +573,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
>  	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx6sx-sai"))
>  		sai->sai_on_imx = true;
> 
> -	sai->big_endian_data = of_property_read_bool(np, "big-endian-data");
> +	sai->is_lsb_first = of_property_read_bool(np, "lsb-first");
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	base = devm_ioremap_resource(&pdev->dev, res);
> diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
> index 2cded44..3466720 100644
> --- a/sound/soc/fsl/fsl_sai.h
> +++ b/sound/soc/fsl/fsl_sai.h
> @@ -132,7 +132,7 @@ struct fsl_sai {
>  	struct clk *bus_clk;
>  	struct clk *mclk_clk[FSL_SAI_MCLK_MAX];
> 
> -	bool big_endian_data;
> +	bool is_lsb_first;
>  	bool is_dsp_mode;
>  	bool sai_on_imx;
>  	bool synchronous[2];
> --
> 1.8.5

