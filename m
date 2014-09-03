Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaICBzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:55:44 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:53792
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753271AbaICBzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:55:43 -0400
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
Subject: RE: [PATCHv2 3/4] ASoC: simple-card: Adjust the comments of simple
 card.
Thread-Topic: [PATCHv2 3/4] ASoC: simple-card: Adjust the comments of simple
 card.
Thread-Index: AQHPxpclMn+mhp+GpEqX5AILTLnbPZvtqJoAgAD+NRA=
Date: Wed, 3 Sep 2014 01:55:38 +0000
Message-ID: <37e5ba204cb340bc9fe01b7473721a9d@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-4-git-send-email-Li.Xiubo@freescale.com>
 <20140902124438.36da4b85@armhf>
In-Reply-To: <20140902124438.36da4b85@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199003)(164054003)(24454002)(51704005)(31966008)(74662001)(74502001)(76176999)(77096002)(83322001)(108616004)(50986999)(85306004)(99396002)(33646002)(54356999)(19580405001)(19580395003)(46102001)(21056001)(64706001)(101416001)(85852003)(83072002)(90102001)(79102001)(80022001)(66066001)(2656002)(86362001)(110136001)(20776003)(106116001)(76482001)(76576001)(87936001)(77982001)(4396001)(81342001)(81542001)(92566001)(99286002)(95666004)(74316001)(105586002)(107046002)(106356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0616;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s831tnUM017851

> Subject: Re: [PATCHv2 3/4] ASoC: simple-card: Adjust the comments of simple
> card.
> 
> On Tue, 2 Sep 2014 17:26:08 +0800
> Xiubo Li <Li.Xiubo@freescale.com> wrote:
> 
> > @@ -285,11 +287,11 @@ static int asoc_simple_card_dai_link_of(struct
> device_node *node,
> >  		dai_props->codec_dai.sysclk);
> >
> >  	/*
> > -	 * soc_bind_dai_link() will check cpu name
> > -	 * after of_node matching if dai_link has cpu_dai_name.
> > -	 * but, it will never match if name was created by fmt_single_name()
> > -	 * remove cpu_dai_name to escape name matching.
> > -	 * see
> > +	 * In soc_bind_dai_link() will check cpu name after
> > +	 * of_node matching if dai_link has cpu_dai_name.
> > +	 * but, it will never match if name was created by
> > +	 * fmt_single_name() remove cpu_dai_name to escape
> > +	 * name matching. Please see:
> >  	 *	fmt_single_name()
> >  	 *	fmt_multiple_name()
> >  	 */
> 
> The patch done by Kuninori, setting the cpu_dai_name to NULL in all
> cases, does not work. This sequence should be replaced where is was
> previously.
> 

If so, it should be another issue here, should we send another patch for
It ?


Thanks,

BRs
Xiubo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
