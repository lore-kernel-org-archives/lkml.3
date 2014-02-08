Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaBHIUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:20:23 -0500
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:52802
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaBHIUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:20:21 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "rob@landley.net" <rob@landley.net>, "perex@perex.cz" <perex@perex.cz>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH v2 7/7] ASoC: binding: for new properties documenting
 and usage
Thread-Topic: [PATCH v2 7/7] ASoC: binding: for new properties documenting
 and usage
Thread-Index: AQHPGOC7atn95H5vhk+Pbym9hVN2p5qZAqAAgBIYYpA=
Date: Sat, 8 Feb 2014 08:20:16 +0000
Message-ID: <28c66e24e8744a6789788600b6a412f5@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
 <1390549386-4702-8-git-send-email-Li.Xiubo@freescale.com>
 <20140127195848.GB11841@sirena.org.uk>
In-Reply-To: <20140127195848.GB11841@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(164054003)(189002)(199002)(51704005)(2656002)(87936001)(33646001)(76796001)(83322001)(63696002)(80976001)(79102001)(59766001)(77982001)(76576001)(85852003)(83072002)(76786001)(56816005)(90146001)(95416001)(92566001)(19580395003)(81816001)(81686001)(47446002)(93136001)(69226001)(74876001)(86362001)(94316002)(65816001)(80022001)(66066001)(49866001)(47976001)(47736001)(50986001)(74662001)(74502001)(53806001)(46102001)(31966008)(4396001)(51856001)(74366001)(56776001)(81542001)(54316002)(87266001)(81342001)(85306002)(93516002)(94946001)(54356001)(74706001)(74316001)(76482001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:BDCCC78D.F1374A4.4BF49340.86E52E61.2016A;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This add the following three new properties documenting and usage
> > for simple card:
> >
> > 	"simple-audio-card,name",
> > 	"simple-audio-card,widgets",
> > 	"simple-audio-card,tdm-slot".
> 
> name and widgets are basically fine modulo the comment about "Hp".
> tdm-slot needs further study, when resubmitting can you please split
> that into a second patch so that the name and widgets properties can be
> merged even if that needs more work?
>

Yes, I will.

 
> For widgets it might be good to create a separate document widgets.txt
> and refer to that - since the code in the kernel can be shared and
> extended we should share the binding document too.

I will send another patch series about this.


Thanks,

--
Best Regards,
Xiubo

