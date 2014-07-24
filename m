Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbaGXNan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:30:43 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:41702
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932723AbaGXNai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:30:38 -0400
Date: Thu, 24 Jul 2014 21:30:04 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: <broonie@kernel.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rdunlap@infradead.org>, <lgirdwood@gmail.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <timur@tabi.org>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <b02247@freescale.com>,
        <b42378@freescale.com>
Subject: Re: [PATCH v2 1/2] ARM: imx: Add the secondary request into the
 structure for imx-sdma
Message-ID: <20140724133002.GC6827@dragon>
References: <cover.1406189745.git.nicoleotsuka@gmail.com>
 <e47c36814695fd8c88ef063a9771cf097a128ec0.1406189745.git.nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e47c36814695fd8c88ef063a9771cf097a128ec0.1406189745.git.nicoleotsuka@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130506822318242154;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(448002)(189002)(199002)(51704005)(24454002)(104016003)(95666004)(20776003)(46102001)(26826002)(44976005)(81156004)(79102001)(64706001)(83322001)(84676001)(76482001)(19580405001)(99396002)(74662001)(33656002)(68736004)(92566001)(87936001)(81542001)(106466001)(86362001)(23726002)(1411001)(107046002)(50466002)(57986006)(21056001)(4396001)(33716001)(97756001)(81342001)(83072002)(85852003)(85306003)(83506001)(77982001)(46406003)(47776003)(76176999)(97736001)(69596002)(31966008)(6806004)(80022001)(85326001)(102836001)(92726001)(74502001)(110136001)(19580395003)(50986999)(54356999);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB363;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=permerror (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:35:28PM +0800, Nicolin Chen wrote:
> SDMA supports device to device (per_2_per) scripts to handle DMA transfering
> between two peripheral devices. The per_2_per script, however, needs two dma
> requests from two sides while the current structure only defined one request.
> 
> So this patch just simply adds the secondary request so as to let SDMA and
> its user to add its implementation later.
> 
> [ Both change in the SDMA driver and its users like Freescale ASRC ASoC driver
>   should be taken along with this change in order to truly support per_2_per
>   sciprts. However, we here make an expediency by adding this first so that
>   we can add either side later since this patch won't break any function and
>   meanwhile it can make merge window more smoothly: we don't need to apply the
>   change inside dmaengine branch via ASoC tree any more. -- Nicolin ]
> 
> Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
