Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaAXH2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 02:28:22 -0500
Received: from [207.46.163.182] ([207.46.163.182]:18950 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751457AbaAXH2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 02:28:20 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH Resend 3/8] ASoC: simple-card: simplify the daifmt code
Thread-Topic: [PATCH Resend 3/8] ASoC: simple-card: simplify the daifmt code
Thread-Index: AQHPGACffXgzi+gyqUiy9RaxtU3PTZqSsDsAgADJidA=
Date: Fri, 24 Jan 2014 07:26:26 +0000
Message-ID: <bd116a4f66f14933a9f018e3f37343b4@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-4-git-send-email-Li.Xiubo@freescale.com>
 <20140123192004.GD11727@sirena.org.uk>
In-Reply-To: <20140123192004.GD11727@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(164054003)(199002)(189002)(24454002)(51704005)(76482001)(83072002)(63696002)(47446002)(19580395003)(74502001)(46102001)(54356001)(74876001)(74316001)(51856001)(90146001)(56816005)(54316002)(93516002)(74662001)(86362001)(66066001)(31966008)(74706001)(80022001)(94316002)(2656002)(77982001)(80976001)(74366001)(47736001)(85852003)(83322001)(79102001)(85306002)(76786001)(87936001)(53806001)(87266001)(81816001)(47976001)(4396001)(81686001)(59766001)(76576001)(65816001)(33646001)(93136001)(49866001)(76796001)(81542001)(50986001)(81342001)(56776001)(92566001)(69226001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH Resend 3/8] ASoC: simple-card: simplify the daifmt code
> 
> On Thu, Jan 23, 2014 at 01:02:45PM +0800, Xiubo Li wrote:
> > In the asoc_simple_card_parse_of() will parse the device node's CPU/CODEC
> > DAI commone fmts, and then in asoc_simple_card_sub_parse_of() will parse
> > the CPU/CODEC DAI's sub-node fmts, so we can combine the info->daifmt and
> > info->set.fmt in asoc_simple_card_sub_parse_of() not while just before
> > _set_fmt().
> 
> This doesn't apply against the current topic/simple, can you please
> check and resend?

Yes, it's caused by the dependency of PATCH 2/8, and the PATCH 2/8 needs to
be revised.

I will resend them, which hasn't been applied, and also adding one binding
patch.

Thanks,

--
Best Regards,
Xiubo

