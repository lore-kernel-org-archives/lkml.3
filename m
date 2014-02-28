Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaB1F5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:57:03 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:47043
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750798AbaB1F5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:57:01 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: RE: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
Thread-Topic: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
Thread-Index: AQHPM6qACYVR5A4ww0ayWu7DY52qF5rKCb6AgAAA4rCAABoHAIAAB6RA
Date: Fri, 28 Feb 2014 05:56:58 +0000
Message-ID: <1b89016263c84e0297655034a648032f@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
 <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com>
 <20140228035244.GJ9383@sirena.org.uk>
 <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140228052904.GP9383@sirena.org.uk>
In-Reply-To: <20140228052904.GP9383@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(51704005)(24454002)(189002)(199002)(66066001)(76796001)(76786001)(83072002)(85852003)(74706001)(74876001)(63696002)(74316001)(81816001)(76576001)(81686001)(65816001)(90146001)(56816005)(80022001)(31966008)(95666003)(94946001)(54356001)(79102001)(95416001)(77982001)(94316002)(2656002)(87266001)(69226001)(19580405001)(19580395003)(76482001)(83322001)(54316002)(56776001)(86362001)(81342001)(47446002)(47976001)(47736001)(81542001)(74662001)(51856001)(53806001)(59766001)(74366001)(85306002)(74502001)(87936001)(4396001)(46102001)(80976001)(33646001)(49866001)(93136001)(92566001)(93516002)(50986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB427;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:BE7AF94C.15207C09.33E5BF7F.C4E5BCE0.20132;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
> 
> On Fri, Feb 28, 2014 at 04:00:38AM +0000, Li.Xiubo@freescale.com wrote:
> 
> > I'll send another patches to applied to use this for another CODEC drivers.
> > And there almost 80 files, Should I send them in one patch or split them
> into
> > individual patch for each CODEC driver ?
> 
> I'd suggest doing one patch that covers the boring drivers where the
> first thing they do is call set_cache_io() but split out the others into
> one patch per driver since the need more examination.

Got it.

Thanks,

--
Best Regards,
Xiubo
