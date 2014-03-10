Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaCJH4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:56:22 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:23449
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752445AbaCJH4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:56:21 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe
 code.
Thread-Topic: [alsa-devel] [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe
 code.
Thread-Index: AQHPNpOHBWw5RTyHRUi7LlXismLKZJrOzasAgAAnM/CAAWR6gIAJX3lQgAA2EwCAAAtmAIAAAqUAgAABkcA=
Date: Mon, 10 Mar 2014 07:56:17 +0000
Message-ID: <dda8dfdd78154f9ab68a2b1639727493@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
 <1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com>
 <20140303045952.GO2411@sirena.org.uk>
 <5bc570ec866541a68df5813ffbe3168e@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140304043603.GI2411@sirena.org.uk>
 <0dbba1debfd149a6a5e3985349a95793@BY2PR03MB505.namprd03.prod.outlook.com>
 <531D6262.3070201@metafoo.de> <20140310073826.GA28112@sirena.org.uk>
 <531D6E2A.9060606@metafoo.de>
In-Reply-To: <531D6E2A.9060606@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 014617085B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(479174003)(377454003)(189002)(199002)(164054003)(95416001)(94946001)(15202345003)(87936001)(81342001)(69226001)(65816001)(81542001)(85852003)(80022001)(63696002)(66066001)(85306002)(56776001)(80976001)(83072002)(49866001)(97336001)(56816005)(90146001)(54356001)(47736001)(76786001)(74366001)(51856001)(76796001)(47446002)(53806001)(77982001)(59766001)(92566001)(33646001)(19580405001)(76576001)(97186001)(47976001)(50986001)(15975445006)(81816001)(95666003)(79102001)(74502001)(74706001)(81686001)(31966008)(94316002)(46102001)(2656002)(74662001)(83322001)(4396001)(74316001)(76482001)(54316002)(87266001)(93516002)(74876001)(93136001)(19580395003)(86362001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB412;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:ECE4F820.ADD21D29.31D0B3CC.CE44DE0.201DD;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [alsa-devel] [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
> 
> On 03/10/2014 08:38 AM, Mark Brown wrote:
> > On Mon, Mar 10, 2014 at 07:57:38AM +0100, Lars-Peter Clausen wrote:
> >> On 03/10/2014 04:51 AM, Li.Xiubo@freescale.com wrote:
> >
> >>> Has there any other problems about this patch series? And this I had
> tested on
> >>> our Vybrid-Twr board based on SGTL5000 codec and SAI drivers. If not, I
> can
> >>> continue with my second patches series about " Remove set_cache_io
> entirely from
> >>> ASoC probe".
> >
> >> It looks good to me.
> >
> > I don't have the patches any more.
> 
> Xiubo, when you resend the patch series can you make refresh your patch 3
> against these two patches. They should preferably go in before we change the
> signature.
> 
> http://mailman.alsa-project.org/pipermail/alsa-devel/2014-March/073785.html
> http://mailman.alsa-project.org/pipermail/alsa-devel/2014-March/073786.html
> 

@Lars,
Yes, certainly.

@Mark, @Lars,
This two patch above should be applied firstly. And I will resent my patch
Series later.

Thanks,

--
Best Regards,
Xiubo

