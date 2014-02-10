Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaBJIYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:24:49 -0500
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:10749
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750797AbaBJIYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:24:47 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: fsl-esai: fix ESAI TDM slot setting
Thread-Topic: [PATCH] ASoC: fsl-esai: fix ESAI TDM slot setting
Thread-Index: AQHPJjS7Y4SjfJU+qkicZ0YluXSuwJquHSIAgAAGMMCAAAL8wA==
Date: Mon, 10 Feb 2014 08:24:43 +0000
Message-ID: <5e5bb7d466fc4197939379273f11c4b6@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392014837-22308-1-git-send-email-Li.Xiubo@freescale.com>
 <20140210075031.GA16453@MrMyself> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0118CD8765
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(189002)(164054003)(54356001)(76482001)(4396001)(46102001)(74876001)(53806001)(54316002)(56776001)(51856001)(81342001)(33646001)(50986001)(49866001)(47736001)(47976001)(95416001)(81542001)(74706001)(93516002)(94316002)(76796001)(94946001)(76786001)(80976001)(77982001)(59766001)(83322001)(79102001)(74366001)(90146001)(69226001)(63696002)(2656002)(86362001)(76576001)(56816005)(92566001)(87936001)(87266001)(81816001)(81686001)(65816001)(31966008)(85306002)(66066001)(74662001)(93136001)(74502001)(83072002)(85852003)(47446002)(74316001)(80022001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB442;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:FEC8E71F.B2294F6.817A3194.900CDA3B.200F5;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, my misunderstanding about your comment.

Please ignore the last mail.

I will send v2 of this patch.

Thanks very much.

> > > diff --git a/sound/soc/fsl/fsl_esai.h b/sound/soc/fsl/fsl_esai.h
> > > index 9c9f957..75e1403 100644
> > > --- a/sound/soc/fsl/fsl_esai.h
> > > +++ b/sound/soc/fsl/fsl_esai.h
> > > @@ -322,7 +322,7 @@
> > >  #define ESAI_xSMB_xS_SHIFT	0
> > >  #define ESAI_xSMB_xS_WIDTH	16
> > >  #define ESAI_xSMB_xS_MASK	(((1 << ESAI_xSMB_xS_WIDTH) - 1) <<
> > ESAI_xSMB_xS_SHIFT)
> > > -#define ESAI_xSMB_xS(v)		(((v) >> ESAI_xSMA_xS_WIDTH) &
> > ESAI_xSMA_xS_MASK)
> > > +#define ESAI_xSMB_xS(v)		(((v) >> ESAI_xSMA_xS_WIDTH) &
> > ESAI_xSMB_xS_MASK)
> >
> > It should use ESAI_xSMB_xS_WIDTH.
> >
> 
> Well, the ESAI_xSMB_xS_WIDTH is 0x0010(16), and ESAI_xSMB_xS_MASK will
> be 0xFFFF.
> 
> 
> 
> Thanks,
> 
> --
> Best Regards,
> Xiubo
