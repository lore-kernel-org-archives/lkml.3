Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaICFeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:34:03 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:29008
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750918AbaICFeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:34:00 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
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
Thread-Index: AQHPxw3FkVXoEiy3Ik67hTArHzRsZZvuqWVggAAYOuCAAAs1AIAAFhbw
Date: Wed, 3 Sep 2014 05:33:56 +0000
Message-ID: <fa9b9bf4a2fc45da818d8627b3408b8e@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
	<87egvt7dmd.wl%kuninori.morimoto.gx@gmail.com>
	<df7936d5863948b0a0a33aa8283d6a67@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <87wq9l5ojn.wl%kuninori.morimoto.gx@gmail.com>
In-Reply-To: <87wq9l5ojn.wl%kuninori.morimoto.gx@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(164054003)(189002)(199003)(76482001)(101416001)(80022001)(74662001)(77096002)(20776003)(79102001)(77982001)(106116001)(99396002)(105586002)(110136001)(87936001)(31966008)(74502001)(85852003)(21056001)(76176999)(92566001)(93886004)(66066001)(64706001)(46102001)(107046002)(83072002)(76576001)(90102001)(95666004)(2656002)(85306004)(106356001)(54356999)(4396001)(74316001)(86362001)(108616004)(83322001)(81342001)(99286002)(81542001)(50986999)(33646002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [alsa-devel] [PATCHv2 1/4] ASoC: simple-card: add
> asoc_simple_card_fmt_master() to simplify the code.
> 
> 
> Hi Xiubo
> 
> > Yes your patch has fixed the bug Jyri has pointed out.
> >
> > So I has discard my [PATCHv2 1/4] patch.
> >
> > Please send your patch out to replace this one.
> (snip)
> > Please send it out of your local patch.
> >
> > Please also consider the ideas about Jyri, Jean-Francios, Varka and
> > Takashi's advice as previous emails about my patch.
> 
> OK, will do.
> To avoid confusion/conflict, I will post it after Mark applied it.
> Because many simple-card patches are posted in these days...
> 

Yes, Get it.

Thanks,

BRs
Xiubo

