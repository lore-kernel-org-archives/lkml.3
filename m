Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaH0HKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:10:52 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:19376
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751848AbaH0HKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:10:51 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>, Nicolin Chen <nicoleotsuka@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>, "timur@tabi.org" <timur@tabi.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
Thread-Topic: [PATCH] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
Thread-Index: AQHPwDUK14r1GsQH/EGJmKvgOz4mE5vimQ4AgAEbmICAAFJHAIAAA0wAgAABItA=
Date: Wed, 27 Aug 2014 07:10:35 +0000
Message-ID: <b4efadd81cae4b66ad484866bb56df40@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1408950961-19177-1-git-send-email-Li.Xiubo@freescale.com>
 <20140826090426.GA31558@leverpostej>
 <cf0e029ae99d4b48a432e5c1669ddc15@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <CAGoOwPSTJaT0UA4yaYR0x49C8UHbmKAR8PzUfV9ZWVW5XBfV5w@mail.gmail.com>
 <20140827070544.GO17528@sirena.org.uk>
In-Reply-To: <20140827070544.GO17528@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199003)(189002)(164054003)(24454002)(51704005)(46102001)(66066001)(80022001)(20776003)(64706001)(76576001)(108616004)(230783001)(93886004)(33646002)(85306004)(81542001)(4396001)(81342001)(90102001)(95666004)(2656002)(54356999)(74316001)(76176999)(86362001)(50986999)(106356001)(101416001)(99286002)(83322001)(107046002)(106116001)(99396002)(105586002)(79102001)(77982001)(83072002)(87936001)(76482001)(77096002)(74502001)(74662001)(31966008)(21056001)(92566001)(85852003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH] ASoC: fsl-sai: using 'lsb-first' property instead of
> 'big-endian-data'.
> 
> On Tue, Aug 26, 2014 at 11:53:56PM -0700, Nicolin Chen wrote:
> 
> > That's why I suggested previously: mention it in the commit comment.
> 
> > People will have no idea about what's the exact reason for this change.
> > Any functional enhancement? Or a bug fix(more likely for this one).
> > I'm not sure what I described in the previous mail is correct or not.
> > But you probably should have added it into the commit comments.
> 
> Right, this is a good idea - make sure people can understand what the
> goal of the change is.
> 

Okay, I will add this.

Thanks,

BRs
Xiubo
