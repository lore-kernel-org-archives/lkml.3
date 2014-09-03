Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbaICDlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:41:55 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:5086
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752062AbaICDlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:41:53 -0400
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
Thread-Index: AQHPxw3FkVXoEiy3Ik67hTArHzRsZZvuqWVggAAY9wCAAABu8A==
Date: Wed, 3 Sep 2014 03:41:50 +0000
Message-ID: <e79f0dc1c43145f093b2497aed680056@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
	<87egvt7dmd.wl%kuninori.morimoto.gx@gmail.com>
	<b0ce0040e47a4ea8ab00ae7e113ecb41@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <87y4u15qa2.wl%kuninori.morimoto.gx@gmail.com>
In-Reply-To: <87y4u15qa2.wl%kuninori.morimoto.gx@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(189002)(40764003)(199003)(2656002)(80022001)(79102001)(66066001)(20776003)(106116001)(110136001)(76482001)(76576001)(86362001)(90102001)(85852003)(101416001)(64706001)(83072002)(95666004)(105586002)(74316001)(99286002)(106356001)(81342001)(107046002)(81542001)(87936001)(4396001)(77982001)(92566001)(85306004)(93886004)(31966008)(74502001)(74662001)(77096002)(108616004)(50986999)(83322001)(76176999)(46102001)(21056001)(99396002)(54356999)(33646002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0616;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
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
> > Yes, I think it make sense to set all fmt in one function, and will
> > Be more readable.
> >
> > I agree with you, could you please just wait, because there has many
> > Replications and good Ideas about this patch, and I will revise it.
> > Then you can improve it as your patch blow.
> 
> Thank you for your help
> I don't care so much about my local patch.
> You can re-use it if you want.
> Of course I can do it if you want
> 

Please send it out of your local patch.

Please also consider the ideas about Jyri, Jean-Francios, Varka and
Takashi's advice as previous emails about my patch.


BRs
Xiubo

