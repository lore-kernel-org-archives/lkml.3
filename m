Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaIJCvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:51:22 -0400
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:55104
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751501AbaIJCvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:51:20 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jyri Sarha <jsarha@ti.com>, Mark Brown <broonie@kernel.org>
CC: "perex@perex.cz" <perex@perex.cz>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "moinejf@free.fr" <moinejf@free.fr>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv3 3/3] ASoC: simple-card: binding: update binding to
 support the new style.
Thread-Topic: [PATCHv3 3/3] ASoC: simple-card: binding: update binding to
 support the new style.
Thread-Index: AQHPxyVImtPJK8G7w0mobWGXStMBE5v4v5wAgAAVJYCAAM7iEA==
Date: Wed, 10 Sep 2014 02:51:16 +0000
Message-ID: <755d5dc6d85243c0bd209aea49eef6c0@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409711021-19277-1-git-send-email-Li.Xiubo@freescale.com>
 <1409711021-19277-4-git-send-email-Li.Xiubo@freescale.com>
 <20140909120948.GZ2601@sirena.org.uk> <540EFFC9.4050207@ti.com>
In-Reply-To: <540EFFC9.4050207@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019019)(6009001)(377454003)(479174003)(189002)(51704005)(24454002)(199003)(164054003)(77096002)(99286002)(95666004)(74316001)(107046002)(106116001)(105586002)(90102001)(108616004)(81542001)(80022001)(66066001)(97736003)(106356001)(31966008)(33646002)(21056001)(93886004)(85306004)(99396002)(86362001)(92566001)(83322001)(76576001)(54356999)(76176999)(50986999)(2656002)(87936001)(74502001)(83072002)(85852003)(74662001)(79102001)(81342001)(64706001)(20776003)(76482001)(46102001)(4396001)(77982001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Subject: Re: [PATCHv3 3/3] ASoC: simple-card: binding: update binding to
> support the new style.
> 
> On 09/09/2014 03:09 PM, Mark Brown wrote:
> > On Wed, Sep 03, 2014 at 10:23:41AM +0800, Xiubo Li wrote:
> >> This update patch will split the DT node into old style and new style:
> >> The new style will will be easier to add muti DAI links from old single
> >> DAI link DTs.
> >
> >> This patch will maintian compatibility with the old DTs.
> >
> > Is everyone happy with this new style binding?
> >
> 
> If I read the diff correctly the only change in the syntax is moving the
> bitclock-inversion and frame-inversion properties to DAI nodes also for
> the new style bindings.
> 
> I am Ok with that.
> 
> The document does not indicate that the same properties could be also
> placed to DAI link level like they used to, from where they would apply
> to both DAI nodes.
> 

I will post one new version of this patch with some very small fix, and
I will also add this.

> I am Ok with this too, but this breaks the backwards compatibility,
> which I guess is generally considered a problem. However, I doubt anyone
> but me has yet used this part of the new syntax and I am happy to fix my
> dts files.
> 
> Best regards,
> Jyri
> 
> ps. I could not find the corresponding code changes in the previous
> patch, so I assume they are coming later.

Yes, I have one patch about the new style in my local machine, for some
reason I will post it later.

Thanks,

BRs
Xiubo



