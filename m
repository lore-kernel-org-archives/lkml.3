Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289AbaGPOfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:35:11 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:42603
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759250AbaGPOfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:35:09 -0400
Date: Wed, 16 Jul 2014 09:38:20 -0500
From: Brian Austin <brian.austin@cirrus.com>
X-X-Sender: heelrod@heelrod
To: "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>
CC: "brian.austin@cirrus.com" <brian.austin@cirrus.com>,
        "Paul.Handrigan@cirrus.com" <Paul.Handrigan@cirrus.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH] ASoC: cs42xx8: Add SND_SOC_DAIFMT_DSP_A
 support
In-Reply-To: <415792f55c1340179171516ba0c25242@BY2PR03MB332.namprd03.prod.outlook.com>
Message-ID: <alpine.DEB.2.02.1407160937460.7394@heelrod>
References: <1405334371-4248-1-git-send-email-shengjiu.wang@freescale.com>
 <415792f55c1340179171516ba0c25242@BY2PR03MB332.namprd03.prod.outlook.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:141.131.128.20;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(51704005)(53754006)(377454003)(13464003)(189002)(199002)(6806004)(83322001)(44976005)(99396002)(21056001)(4396001)(81342001)(79102001)(110136001)(47776003)(77096002)(77982001)(20776003)(106466001)(107046002)(64706001)(92726001)(19580405001)(102836001)(54356999)(81542001)(46102001)(76176999)(83072002)(76482001)(85852003)(80022001)(74662001)(83506001)(85306003)(50986999)(86362001)(87936001)(95666004)(92566001)(33716001)(2351001)(74502001)(23726002)(31966008)(50466002)(19580395003);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB039;H:mail2.cirrus.com;FPR:;MLV:sfv;PTR:mail2.cirrus.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: cirrus4.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0274272F87
Authentication-Results: spf=pass (sender IP is 141.131.128.20)
 smtp.mailfrom=Brian.Austin@cirrus.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, shengjiu.wang@freescale.com wrote:

> Hi all
>
>    Sorry, add more maintainers.
>
> Best regards
> Wang shengjiu
>
> -----Original Message-----
> From: alsa-devel-bounces@alsa-project.org [mailto:alsa-devel-bounces@alsa-project.org] On Behalf Of Shengjiu Wang
> Sent: Monday, July 14, 2014 6:40 PM
> To: broonie@linaro.org
> Cc: alsa-devel@alsa-project.org
> Subject: [alsa-devel] [PATCH] ASoC: cs42xx8: Add SND_SOC_DAIFMT_DSP_A support
>
> According to the spec, the definition of TDM and ONELINE_24 for CS42XX8_INTF_DAC and CS42XX8_INTF_ADC is wrong. correct them and enable SND_SOC_DAIFMT_DSP_A support.
>
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> ---
Acked-by: Brian Austin <brian.austin@cirrus.com>
