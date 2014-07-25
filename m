Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbaGYLsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:48:35 -0400
Received: from [207.46.163.210] ([207.46.163.210]:15123 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751805AbaGYLsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:48:33 -0400
Date: Fri, 25 Jul 2014 19:28:08 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Varka Bhadram <varkabhadram@gmail.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <shawn.guo@linaro.org>, <b02247@freescale.com>, <b42378@freescale.com>,
        <tklauser@distanz.ch>
Subject: Re: [PATCH v5 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and
 platform drivers
Message-ID: <20140725112807.GA29852@MrMyself>
References: <cover.1406276436.git.nicoleotsuka@gmail.com>
 <2288e61e600e28448905e32dd4f74a954110248f.1406276436.git.nicoleotsuka@gmail.com>
 <53D240B3.8060203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53D240B3.8060203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(51704005)(189002)(24454002)(479174003)(377454003)(24434003)(1411001)(19580395003)(106466001)(74662001)(4396001)(97756001)(81342001)(80022001)(81542001)(26826002)(64706001)(50466002)(31966008)(46102001)(77982001)(47776003)(83322001)(85306003)(76482001)(68736004)(74502001)(50986999)(86362001)(105606002)(79102001)(20776003)(19580405001)(84676001)(83506001)(76176999)(92566001)(54356999)(23726002)(83072002)(104016003)(21056001)(97736001)(110136001)(85852003)(102836001)(33716001)(107046002)(95666004)(46406003)(6806004)(92726001)(44976005)(33656002)(99396002)(87936001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB447;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,

On Fri, Jul 25, 2014 at 05:04:11PM +0530, Varka Bhadram wrote:
> On 07/25/2014 02:16 PM, Nicolin Chen wrote:
> >The Asynchronous Sample Rate Converter (ASRC) converts the sampling rate of a
> >signal associated with an input clock into a signal associated with a different
> >output clock. The driver currently works as a Front End of DPCM with other Back
> >Ends DAI links such as ESAI<->CS42888 and SSI<->WM8962 and SAI. It converts the
> >original sample rate to a common rate supported by Back Ends for playback while
> >converts the common rate of Back Ends to a desired rate for capture. It has 3
> >pairs to support three different substreams within totally 10 channels.
> >
> >Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> >---
> >  .../devicetree/bindings/sound/fsl,asrc.txt         |  60 ++
> >  sound/soc/fsl/Kconfig                              |   9 +
> >  sound/soc/fsl/Makefile                             |   2 +
> >  sound/soc/fsl/fsl_asrc.c                           | 992 +++++++++++++++++++++
> >  sound/soc/fsl/fsl_asrc.h                           | 461 ++++++++++
> >  sound/soc/fsl/fsl_asrc_dma.c                       | 386 ++++++++
> >  6 files changed, 1910 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/sound/fsl,asrc.txt
> >  create mode 100644 sound/soc/fsl/fsl_asrc.c
> >  create mode 100644 sound/soc/fsl/fsl_asrc.h
> >  create mode 100644 sound/soc/fsl/fsl_asrc_dma.c
> >
> >
> check patch warnings on this patch...

[...]

./scripts/checkpatch.pl --max-line-length=128 0002-ASoC-fsl_a....patch
total: 0 errors, 0 warnings, 1928 lines checked

0002-ASoC....patch has no obvious style problems and is ready for submission

[...]

I think there's no need to be so strict by wrapping all lines inside
80 characters, especially for those that will be less readable if being
wrapped and for those in header file.

Thank you
Nicolin
