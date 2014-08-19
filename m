Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaHSJFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:05:08 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:4669
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbaHSJFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:05:05 -0400
From: "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "xobs@kosagi.com" <xobs@kosagi.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "timur@tabi.org" <timur@tabi.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove dependence
 of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
Thread-Topic: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove
 dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
Thread-Index: AQHPur/mrX82EQZhOUuGX5y08up0h5vWlCwAgAF+TAD//4LigIAAiFAA//+ExwCAAACLUA==
Date: Tue, 19 Aug 2014 09:05:01 +0000
Message-ID: <e58402508f0d4df68bea74bdcde6ade0@BY2PR03MB332.namprd03.prod.outlook.com>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
 <f30ba4e2c4eb6702fa40bd255036e6e9ad6eb47d.1408350626.git.shengjiu.wang@freescale.com>
 <53F22F5E.2090601@metafoo.de> <20140819074103.GA5806@audiosh1>
 <d7b06608abcc4f098789f63cb9f36eef@BN1PR0301MB0609.namprd03.prod.outlook.com>
 <20140819082108.GB5806@audiosh1>
 <3a0c98ca698e4d38b3e92f339049b883@BN1PR0301MB0609.namprd03.prod.outlook.com>
In-Reply-To: <3a0c98ca698e4d38b3e92f339049b883@BN1PR0301MB0609.namprd03.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0308EE423E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019006)(979002)(6009001)(13464003)(189002)(51704005)(164054003)(24454002)(45984002)(199003)(377454003)(479174003)(81542001)(85852003)(105586002)(85306004)(79102001)(86362001)(54356999)(99396002)(99286002)(83072002)(81342001)(19580405001)(93886004)(64706001)(33646002)(106356001)(83322001)(50986999)(77982001)(19580395003)(4396001)(108616004)(76176999)(87936001)(2656002)(20776003)(15202345003)(101416001)(74316001)(21056001)(74662001)(74502001)(31966008)(95666004)(15975445006)(92566001)(66066001)(76482001)(107046002)(76576001)(110136001)(106116001)(80022001)(46102001)(241875001)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB256;H:BY2PR03MB332.namprd03.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xiubo Li

     Lars-Peter has point out the root cause. It is caused by the SND_SOC_FSL_ASOC_CARD, which will select SND_SOC_IMX_PCM_DMA.

     Thank you very much anyway.

Best regards
Wang shengjiu

-----Original Message-----
From: Xiubo Li-B47053 
Sent: Tuesday, August 19, 2014 5:00 PM
To: Wang Shengjiu-B02247
Cc: Lars-Peter Clausen; lgirdwood@gmail.com; broonie@kernel.org; perex@perex.cz; tiwai@suse.de; nicoleotsuka@gmail.com; shc_work@mail.ru; Estevam Fabio-R49496; xobs@kosagi.com; arnd@arndb.de; sfr@canb.auug.org.au; timur@tabi.org; alsa-devel@alsa-project.org; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
Subject: RE: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA

How about the following :


diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig index 5ae777a..d42f18c 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -15,7 +15,7 @@ config SND_SOC_FSL_ASRC  config SND_SOC_FSL_SAI
        tristate "Synchronous Audio Interface (SAI) module support"
        select REGMAP_MMIO
-       select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
+       select SND_SOC_IMX_PCM_DMA
        select SND_SOC_GENERIC_DMAENGINE_PCM
        help
          Say Y if you want to add Synchronous Audio Interface (SAI) @@ -25,7 +25,7 @@ config SND_SOC_FSL_SAI

 config SND_SOC_FSL_SSI
        tristate "Synchronous Serial Interface module support"
-       select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
+       select SND_SOC_IMX_PCM_DMA
        select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && (MXC_TZIC || MXC_AVIC)
        select REGMAP_MMIO
        help
@@ -37,7 +37,7 @@ config SND_SOC_FSL_SSI  config SND_SOC_FSL_SPDIF
        tristate "Sony/Philips Digital Interface module support"
        select REGMAP_MMIO
-       select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
+       select SND_SOC_IMX_PCM_DMA
        select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && (MXC_TZIC || MXC_AVIC)
        help
          Say Y if you want to add Sony/Philips Digital Interface (SPDIF) @@ -48,7 +48,7 @@ config SND_SOC_FSL_SPDIF  config SND_SOC_FSL_ESAI
        tristate "Enhanced Serial Audio Interface (ESAI) module support"
        select REGMAP_MMIO
-       select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
+       select SND_SOC_IMX_PCM_DMA
        help
          Say Y if you want to add Enhanced Synchronous Audio Interface
          (ESAI) support for the Freescale CPUs.
@@ -76,6 +76,7 @@ config SND_SOC_FSL_ASOC_CARD

 config SND_SOC_IMX_PCM_DMA
        tristate
+       depends on SND_IMX_SOC
        select SND_SOC_GENERIC_DMAENGINE_PCM

 config SND_SOC_IMX_AUDMUX

Thanks,


BRs
Xiubo



> -----Original Message-----
> From: Shengjiu Wang [mailto:shengjiu.wang@freescale.com]
> Sent: Tuesday, August 19, 2014 4:21 PM
> To: Xiubo Li-B47053
> Cc: Lars-Peter Clausen; lgirdwood@gmail.com; broonie@kernel.org; 
> perex@perex.cz; tiwai@suse.de; nicoleotsuka@gmail.com; 
> shc_work@mail.ru; Estevam Fabio-R49496; xobs@kosagi.com; 
> arnd@arndb.de; sfr@canb.auug.org.au; timur@tabi.org; 
> alsa-devel@alsa-project.org; linuxppc-dev@lists.ozlabs.org; 
> linux-kernel@vger.kernel.org
> Subject: Re: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove 
> dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
> 
> On Tue, Aug 19, 2014 at 04:13:15PM +0800, Xiubo Li-B47053 wrote:
> > > Subject: Re: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: 
> > > remove
> dependence
> > > of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
> > >
> > > On Mon, Aug 18, 2014 at 06:52:46PM +0200, Lars-Peter Clausen wrote:
> > > > On 08/18/2014 10:38 AM, Shengjiu Wang wrote:
> > > > >Build kernel with SND_SOC_IMC_PCM_DMA=m && SND_IMX_SOC=n leads 
> > > > >the
> > > following
> > > > >error:
> > > > >
> > > > >    sound/built-in.o: In function `fsl_sai_probe':
> > > > >>>fsl_sai.c:(.text+0x5f662): undefined reference to `imx_pcm_dma_init'
> > > > >    sound/built-in.o: In function `fsl_esai_probe':
> > > > >>>fsl_esai.c:(.text+0x6044b): undefined reference to `imx_pcm_dma_init'
> > > > >
> > > > >Most cpu driver in soc/fsl has use the function 'imx_pcm_dma_init'
> which is
> > > > >defined in imx-pcm-dma.c, so need to select 
> > > > >SND_SOC_IMX_PCM_DMA, but it
> > > depends
> > > > >on SND_IMX_SOC, if SND_IMX_SOC=n, then SND_SOC_IMX_PCM_DMA will 
> > > > >not be selected.
> > > > >So remove the dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA.
> > > > >
> > > > >Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > > > >Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> > > >
> > > > Those if conditions where just added[1] by Arnd to avoid other 
> > > > build failures. So just removing them again makes little sense.
> > > >
> > > > As far as I can see imx_pcm_dma_init() should be stubbed out 
> > > > when SND_SOC_IMX_PCM_DMA is not selected. So what's going on here?
> > > >
> > > > [1]
> > >
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/
> ?id=ff40
> > > 260f79dc0436604452bccd449bffd25ebafb
> > > >
> > > Lars-Peter Clausen & Arnd
> > >
> > > The purpose of Arnd's patch is same with me, which is to resolve 
> > > the build error when SND_SOC_IMX_PCM_DMA=m & 
> > > SND_SOC_FSL_SSI/SAI/ESAI/SPDIF=y, the error is "undefined reference to `imx_pcm_dma_init'".
> > > But Arnd's patch didn't involve this situation that SND_IMX_SOC=n 
> > > & SND_SOC_IMX_PCM_DMA=m.
> > >
> > > Currently I think out a solution for this issue is to change
> > >
> > > select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
> > >
> > > to
> > >
> > > depends on SND_SOC_IMX_PCM_DMA != m
> > >
> > > How do you think about this?
> > >
> >
> > What will happen if to build both SAI/ESAI and IMX_PCM_DMA as 
> > modules at the
> same
> > time ?
> >
> > Thanks,
> >
> > BRs
> > Xiubo
> 
> I didn't find error/warning when SAI/ESAI and IMX_PCM_DMA are as 
> modules. The build is successful.
> 
> >
> >
> > > best regards
> > > Wang shengjiu
