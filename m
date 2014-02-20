Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaBTCGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:06:24 -0500
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:27863
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751998AbaBTCGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:06:23 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
CC: "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@linaro.org>
Subject: RE: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be
 visible in Kconfig
Thread-Topic: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be
 visible in Kconfig
Thread-Index: AQHPJtx7vjnlwG7hYkWLGSOUXx6EvJq9cbFA
Date: Thu, 20 Feb 2014 02:06:20 +0000
Message-ID: <36d9c0a870604fbe87b129e95fea9da1@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392086825-15737-1-git-send-email-Li.Xiubo@freescale.com>
 <1392086825-15737-2-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1392086825-15737-2-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.215]
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(51704005)(164054003)(81342001)(81542001)(69226001)(93136001)(59766001)(77982001)(74366001)(19580395003)(56776001)(19580405001)(2201001)(53806001)(83072002)(85852003)(51856001)(54356001)(46102001)(76796001)(76786001)(81686001)(92566001)(81816001)(95416001)(86362001)(93516002)(95666001)(94946001)(76482001)(76576001)(54316002)(94316002)(80976001)(56816005)(85306002)(87936001)(90146001)(66066001)(31966008)(74502001)(47446002)(83322001)(74316001)(33646001)(2656002)(87266001)(47736001)(47976001)(50986001)(63696002)(74662001)(65816001)(4396001)(74876001)(49866001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB441;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.215;FPR:7CD8E25D.3BD227F1.C6559C.84D4AAF3.2020D;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I'm not very sure of this patch, maybe should we add one menu
in Kconfig for all visible CPU DAIs firstly like for code drivers?

Thanks,

--
Best Regards,
Xiubo


> Subject: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be visible in
> Kconfig
> 
> For simple card since the whole idea is to support any CODEC and
> any CPU DAI with the same driver, we should probably just make sure
> that all the individual CODEC and CPU DAI drivers can be enabled in
> Kconfig. That way we don't have to have specific Kconfig entries for
> boards and loose some of the benefit of the generic card.
> 
> This will make the Freescale SAI/ESAI/SPDIF device be visible in
> Kconfig.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Nicolin Chen <Guangyu.Chen@freescale.com>
> Cc: Mark Brown <broonie@linaro.org>
> ---
>  sound/soc/fsl/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
> index d0914c0..f397144 100644
> --- a/sound/soc/fsl/Kconfig
> +++ b/sound/soc/fsl/Kconfig
> @@ -1,5 +1,5 @@
>  config SND_SOC_FSL_SAI
> -	tristate
> +	tristate "ALSA SoC support for the Freescale SAI device"
>  	select REGMAP_MMIO
>  	select SND_SOC_GENERIC_DMAENGINE_PCM
> 
> @@ -7,11 +7,11 @@ config SND_SOC_FSL_SSI
>  	tristate
> 
>  config SND_SOC_FSL_SPDIF
> -	tristate
> +	tristate "ALSA SoC support for the Freescale SPDIF device"
>  	select REGMAP_MMIO
> 
>  config SND_SOC_FSL_ESAI
> -	tristate
> +	tristate "ALSA SoC support for the Freescale ESAI device"
>  	select REGMAP_MMIO
> 
>  config SND_SOC_FSL_UTILS
> --
> 1.8.4
> 

