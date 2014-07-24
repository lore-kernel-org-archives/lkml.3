Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbaGXIpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:45:15 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:49193
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751874AbaGXIpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:45:10 -0400
Date: Thu, 24 Jul 2014 16:25:46 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: <broonie@kernel.org>, <vinod.koul@intel.com>, <s.hauer@pengutronix.de>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <b38343@freescale.com>,
        <b02247@freescale.com>, <b42378@freescale.com>
Subject: Re: [RFC][PATCH 0/2] Add ASRC Peripheral to Peripheral driver
Message-ID: <20140724082545.GA27595@MrMyself>
References: <cover.1402653667.git.nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1402653667.git.nicoleotsuka@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(24454002)(51704005)(110136001)(81342001)(64706001)(68736004)(85306003)(80022001)(76482001)(54356999)(102836001)(81542001)(26826002)(95666004)(83072002)(74662001)(77982001)(6806004)(84676001)(92566001)(4396001)(46102001)(83322001)(74502001)(83506001)(87936001)(47776003)(33656002)(81156004)(31966008)(50466002)(23726002)(76176999)(99396002)(97756001)(85852003)(92726001)(69596002)(86362001)(20776003)(79102001)(1411001)(19580395003)(104016003)(107046002)(106466001)(105606002)(44976005)(97736001)(50986999)(46406003)(21056001)(33716001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB326;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 06:07:03PM +0800, Nicolin Chen wrote:
> This series of patches have a direct dependency between them. So we might
> need to push them into one branch. And sorry for this :(
> 
> Patch-1 adds device to device support in SDMA driver along with a secondary
> request in struct imx_dma_data which's requred in the Patch-2 ASRC driver.

I just sent a new version V2. So please disregard this version.

Thanks all,
Nicolin

> 
> Nicolin Chen (2):
>   dma: imx-sdma: Add device to device support
>   ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and platform drivers
> 
>  .../devicetree/bindings/sound/fsl,asrc.txt         |   62 ++
>  drivers/dma/imx-sdma.c                             |   40 +-
>  include/linux/platform_data/dma-imx.h              |    1 +
>  sound/soc/fsl/Kconfig                              |    9 +
>  sound/soc/fsl/Makefile                             |    2 +
>  sound/soc/fsl/fsl_asrc.c                           | 1031 ++++++++++++++++++++
>  sound/soc/fsl/fsl_asrc.h                           |  431 ++++++++
>  sound/soc/fsl/fsl_asrc_dma.c                       |  385 ++++++++
>  8 files changed, 1956 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/sound/fsl,asrc.txt
>  create mode 100644 sound/soc/fsl/fsl_asrc.c
>  create mode 100644 sound/soc/fsl/fsl_asrc.h
>  create mode 100644 sound/soc/fsl/fsl_asrc_dma.c
> 
> -- 
> 1.8.4
> 
