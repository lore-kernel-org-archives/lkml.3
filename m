Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaH0HCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:02:48 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:31424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751315AbaH0HCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:02:47 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "timur@tabi.org" <timur@tabi.org>,
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
Thread-Index: AQHPwDUK14r1GsQH/EGJmKvgOz4mE5vimQ4AgAEbmICAAFJHAIAAAdrA
Date: Wed, 27 Aug 2014 07:02:43 +0000
Message-ID: <cd9a50c81d3a402594a30cdd39220614@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1408950961-19177-1-git-send-email-Li.Xiubo@freescale.com>
	<20140826090426.GA31558@leverpostej>
	<cf0e029ae99d4b48a432e5c1669ddc15@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <CAGoOwPSTJaT0UA4yaYR0x49C8UHbmKAR8PzUfV9ZWVW5XBfV5w@mail.gmail.com>
In-Reply-To: <CAGoOwPSTJaT0UA4yaYR0x49C8UHbmKAR8PzUfV9ZWVW5XBfV5w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(164054003)(189002)(24454002)(377454003)(199003)(99286002)(101416001)(105586002)(99396002)(79102001)(107046002)(83322001)(19580405001)(19580395003)(106116001)(76176999)(86362001)(2656002)(54356999)(74316001)(106356001)(50986999)(21056001)(31966008)(85852003)(92566001)(83072002)(87936001)(77982001)(76482001)(1411001)(77096002)(74502001)(74662001)(110136001)(93886004)(230783001)(85306004)(33646002)(80022001)(66066001)(20776003)(64706001)(46102001)(108616004)(76576001)(90102001)(95666004)(81542001)(81342001)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
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
> On Tue, Aug 26, 2014 at 7:12 PM, Li.Xiubo@freescale.com
> <Li.Xiubo@freescale.com> wrote:
> > > > This property used for configuring whether the LSB or the MSB is
> transmitted
> > > > first for the fifo data.
> > >
> > > I don't follow the rationale for this change.
> > >
> > > This looks like a pointless renaming.
> > >
> > > Why is this any better?
> > >
> >
> > This is originally to indicate whether the LSB firstly or MSB firstly will
> be
> > transmitted to the CODEC or received from the CODEC, and there has nothing
> > Relation to the memory data.
> >
> > Generally, if the audio data in big endian format, which will be using the
> bytes
> > Reversion ? Here this can only be used to bits reversion.
> 
> That's why I suggested previously: mention it in the commit comment.
> 
> People will have no idea about what's the exact reason for this change.
> Any functional enhancement? Or a bug fix(more likely for this one).
> I'm not sure what I described in the previous mail is correct or not.
> But you probably should have added it into the commit comments.
> 
> And Xiubo, this patch still hasn't fixed the issue of breaking the old DT,
> although system can pass during the probe() section.
> 

Beside LS1+, who else is using this now ? And the LS1 dts files are still doing
The upstream for now.

Thanks,

BRs
Xiubo


