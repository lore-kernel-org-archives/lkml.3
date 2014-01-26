Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaAZFPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 00:15:11 -0500
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:42162
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751972AbaAZFPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 00:15:09 -0500
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
Thread-Index: AQHPGACe38Tl6mwl1kmbGGGNjIkpNpqSpJ2AgAPVlSA=
Date: Sun, 26 Jan 2014 05:15:05 +0000
Message-ID: <88ad355def5f440eb92ca921b17aabb9@DM2PR03MB509.namprd03.prod.outlook.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-2-git-send-email-Li.Xiubo@freescale.com>
 <20140123183829.GB11727@sirena.org.uk>
In-Reply-To: <20140123183829.GB11727@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(189002)(63696002)(33646001)(74662001)(74502001)(47446002)(31966008)(93516002)(86362001)(93136001)(69226001)(76796001)(76786001)(76576001)(49866001)(54356001)(51856001)(53806001)(76482001)(83322001)(56776001)(50986001)(47976001)(47736001)(54316002)(81342001)(81542001)(80976001)(79102001)(4396001)(77982001)(46102001)(59766001)(83072002)(85852003)(74876001)(81686001)(2656002)(85306002)(80022001)(66066001)(74366001)(65816001)(87266001)(90146001)(87936001)(56816005)(81816001)(74706001)(74316001)(92566001)(94316002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB511;H:DM2PR03MB509.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> > +config SND_SOC_VF610_SGTL5000
> > +       tristate "SoC Audio support for VF610 boards with SGTL5000"
> > +       depends on OF && I2C
> > +       select SND_SOC_FSL_SAI
> > +       select SND_SOC_SGTL5000
> > +       select SND_SIMPLE_CARD
> 
> ...for simple card since the whole idea is to support any CODEC with the
> same driver we should probably just make sure that all the individual
> drivers can be enabled in Kconfig, that way we don't have to have
> specific Kconfig entries for boards and loose some of the benefit of the
> generic card.  I sent a patch earlier exposing the OF supporting CODEC
> drivers, one for at least some of the Freescale CPU drivers was sent to
> the list recently too but there were some review comments.

I hadn't found the patches, could you tell me the titles of them please?

Thanks very much,

--
* Happy New Year *

Best Regards,
Xiubo


