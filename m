Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaICCYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:24:12 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:48957
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbaICCYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:24:11 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "jsarha@ti.com" <jsarha@ti.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>
Subject: RE: [alsa-devel] [PATCHv2 3/4] ASoC: simple-card: Adjust the comments
 of simple card.
Thread-Topic: [alsa-devel] [PATCHv2 3/4] ASoC: simple-card: Adjust the
 comments of simple card.
Thread-Index: AQHPxpclMn+mhp+GpEqX5AILTLnbPZvtqJoAgAD+NRCAAAWUAIAAAjow
Date: Wed, 3 Sep 2014 02:24:07 +0000
Message-ID: <92afbaa4e7fd40f0a9a26dd89d350f53@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-4-git-send-email-Li.Xiubo@freescale.com>
	<20140902124438.36da4b85@armhf>
	<37e5ba204cb340bc9fe01b7473721a9d@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <87zjeh5u2o.wl%kuninori.morimoto.gx@gmail.com>
In-Reply-To: <87zjeh5u2o.wl%kuninori.morimoto.gx@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199003)(164054003)(51704005)(74502001)(31966008)(74662001)(76176999)(77096002)(83322001)(108616004)(50986999)(93886004)(85306004)(99396002)(33646002)(54356999)(46102001)(21056001)(64706001)(101416001)(85852003)(83072002)(90102001)(79102001)(80022001)(66066001)(2656002)(86362001)(110136001)(20776003)(106116001)(76482001)(76576001)(87936001)(77982001)(4396001)(81342001)(81542001)(92566001)(99286002)(95666004)(74316001)(105586002)(107046002)(106356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0616;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [alsa-devel] [PATCHv2 3/4] ASoC: simple-card: Adjust the comments
> of simple card.
> 
> 
> Hi Xiubo
> 
> > > >  	/*
> > > > -	 * soc_bind_dai_link() will check cpu name
> > > > -	 * after of_node matching if dai_link has cpu_dai_name.
> > > > -	 * but, it will never match if name was created by
> fmt_single_name()
> > > > -	 * remove cpu_dai_name to escape name matching.
> > > > -	 * see
> > > > +	 * In soc_bind_dai_link() will check cpu name after
> > > > +	 * of_node matching if dai_link has cpu_dai_name.
> > > > +	 * but, it will never match if name was created by
> > > > +	 * fmt_single_name() remove cpu_dai_name to escape
> > > > +	 * name matching. Please see:
> > > >  	 *	fmt_single_name()
> > > >  	 *	fmt_multiple_name()
> > > >  	 */
> > >
> > > The patch done by Kuninori, setting the cpu_dai_name to NULL in all
> > > cases, does not work. This sequence should be replaced where is was
> > > previously.
> > >
> >
> > If so, it should be another issue here, should we send another patch for
> > It ?
> 
> I posted patch yesterday, and Jean tested it
> 
> Subject: [PATCH][RFC] ASoC: simple-card: fixup cpu_dai_name clear case
> Date: Tue, 02 Sep 2014 20:05:32 +0900
> 

Nice.

I think I just missed it.

Thanks,

BRs
Xiubo


