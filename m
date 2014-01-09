Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaAIHnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:43:51 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:18236
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753725AbaAIHnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:43:45 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 3/4] ASoC: fsl: Add VF610 simple audio card widgets
 driver.
Thread-Topic: [PATCH 3/4] ASoC: fsl: Add VF610 simple audio card widgets
 driver.
Thread-Index: AQHPDEeRsrwa/WcpkkSC4pOFwyzCb5p7IDAAgADe3jA=
Date: Thu, 9 Jan 2014 07:43:42 +0000
Message-ID: <3ebbe152f0a94858a24a97f6251e5715@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389164556-2728-1-git-send-email-Li.Xiubo@freescale.com>
 <1389164556-2728-3-git-send-email-Li.Xiubo@freescale.com>
 <20140108180638.GS31886@sirena.org.uk>
In-Reply-To: <20140108180638.GS31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(51704005)(199002)(189002)(74366001)(46102001)(51856001)(2656002)(87936001)(65816001)(80022001)(66066001)(33646001)(85306002)(77982001)(59766001)(47976001)(50986001)(4396001)(47736001)(54316002)(49866001)(79102001)(53806001)(54356001)(87266001)(56776001)(63696002)(76482001)(74316001)(31966008)(74662001)(69226001)(76796001)(81342001)(81686001)(74502001)(47446002)(85852003)(19580395003)(80976001)(83072002)(83322001)(19580405001)(74706001)(74876001)(76576001)(76786001)(81542001)(81816001)(92566001)(56816005)(90146001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > This is the SGTL5000 codec based off-CODEC widgets supports.
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  sound/soc/fsl/Kconfig                     | 25 ++++++++++++++++++
> >  sound/soc/fsl/Makefile                    |  3 +++
> >  sound/soc/fsl/snd-soc-simple-card-vf610.c | 44
> +++++++++++++++++++++++++++++++
> 
> If we're needing to add explict code for a simple audio card that seems
> to defeat the point of using the simple audio card - we may as well just
> have an explicit machine driver.
>

IMHO, the simple audio card driver could fulfil most of machine driver's work. 
And will make some machine driver simpler and eaiser to code.

Thanks,

--
Best Regards,
Xiubo 
