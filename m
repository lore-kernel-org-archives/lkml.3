Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaICByZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:54:25 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:19901
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750871AbaICByX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:54:23 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "andrew@lunn.ch" <andrew@lunn.ch>,
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
Subject: RE: [PATCHv2 4/4] ASoC: simple-card: binding: update binding to
 support the new style.
Thread-Topic: [PATCHv2 4/4] ASoC: simple-card: binding: update binding to
 support the new style.
Thread-Index: AQHPxpcn/VF4lOdKb0mYvX7nVz27m5vtp6cAgAD+u1A=
Date: Wed, 3 Sep 2014 01:54:07 +0000
Message-ID: <80a8421c4c51407ba24d4e9c6c5f3309@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-5-git-send-email-Li.Xiubo@freescale.com>
 <20140902124114.6d95e0c5@armhf>
In-Reply-To: <20140902124114.6d95e0c5@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(189002)(199003)(164054003)(51704005)(4396001)(106116001)(105586002)(95666004)(106356001)(31966008)(74662001)(77096002)(77982001)(74502001)(79102001)(87936001)(74316001)(86362001)(46102001)(99286002)(107046002)(108616004)(33646002)(76576001)(50986999)(21056001)(85306004)(54356999)(76176999)(83322001)(99396002)(101416001)(110136001)(81542001)(19580405001)(90102001)(2656002)(83072002)(85852003)(64706001)(92566001)(76482001)(80022001)(66066001)(81342001)(19580395003)(20776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s831sTYh017843

> Subject: Re: [PATCHv2 4/4] ASoC: simple-card: binding: update binding to
> support the new style.
> 
> On Tue, 2 Sep 2014 17:26:09 +0800
> Xiubo Li <Li.Xiubo@freescale.com> wrote:
> 
> > +Example 4 - many DAI links:
> >  sound {
> >  	compatible = "simple-audio-card";
> >  	simple-audio-card,name = "Cubox Audio";
> > @@ -128,6 +195,7 @@ sound {
> >  		};
> >  		codec {
> >  			sound-dai = <&tda998x 0>;
> > +			frame-inversion;
> >  		};
> >  	};
> 
> This is not useful: there is no clock/frame handling in the kirkwood
> audio controller.
> 


Okay, just for one example, if it really matter here I will remove this.

Thanks,

BRs
Xiubo


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
