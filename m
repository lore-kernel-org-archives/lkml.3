Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaBJEMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:12:23 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:34506
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750742AbaBJEMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:12:22 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/8] ASoC: fsl: Add VF610 soc audio card Kconfig
Thread-Topic: [PATCH 1/8] ASoC: fsl: Add VF610 soc audio card Kconfig
Thread-Index: AQHPGACe38Tl6mwl1kmbGGGNjIkpNpqSpJ2AgAPVlSCAAH4mgIAXAtnA
Date: Mon, 10 Feb 2014 04:12:19 +0000
Message-ID: <d774da5b38ff47b6a350d92d1ffb362a@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-2-git-send-email-Li.Xiubo@freescale.com>
 <20140123183829.GB11727@sirena.org.uk>
 <88ad355def5f440eb92ca921b17aabb9@DM2PR03MB509.namprd03.prod.outlook.com>
 <20140126124313.GF11727@sirena.org.uk>
In-Reply-To: <20140126124313.GF11727@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0118CD8765
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(51704005)(199002)(189002)(81686001)(87266001)(81816001)(65816001)(63696002)(76796001)(76786001)(2656002)(90146001)(87936001)(76576001)(92566001)(56816005)(83072002)(85852003)(47446002)(80022001)(74316001)(66066001)(85306002)(74662001)(31966008)(69226001)(74502001)(93136001)(86362001)(95416001)(93516002)(94946001)(94316002)(81542001)(74706001)(46102001)(53806001)(74876001)(54316002)(56776001)(54356001)(76482001)(4396001)(49866001)(47736001)(47976001)(50986001)(51856001)(81342001)(33646001)(74366001)(79102001)(59766001)(77982001)(80976001)(19580405001)(19580395003)(83322001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:8CD9F6EF.231E6F32.B0E5B6BF.C8F4BDE1.201FC;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH 1/8] ASoC: fsl: Add VF610 soc audio card Kconfig
> 
> On Sun, Jan 26, 2014 at 05:15:05AM +0000, Li.Xiubo@freescale.com wrote:
> 
> > > ...for simple card since the whole idea is to support any CODEC with the
> > > same driver we should probably just make sure that all the individual
> > > drivers can be enabled in Kconfig, that way we don't have to have
> > > specific Kconfig entries for boards and loose some of the benefit of the
> > > generic card.  I sent a patch earlier exposing the OF supporting CODEC
> > > drivers, one for at least some of the Freescale CPU drivers was sent to
> > > the list recently too but there were some review comments.
> 
> > I hadn't found the patches, could you tell me the titles of them please?
> 
> My patch was "ASoC: codecs: Make OF supported CODECs visible in
> Kconfig".  I can't remember offhand what the patch for i.MX was called.

Yes, found it.

If so, shouldn't the CPU DAIs(such as I2S) also be invisible in Kconfig like
CODECs ?


Thanks very much.
--
Best Regards,
Xiubo

