Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaBKH1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:27:24 -0500
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:41416
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaBKH1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:27:23 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] ASoC: fsl-esai: big-endian support
Thread-Topic: [PATCH 2/2] ASoC: fsl-esai: big-endian support
Thread-Index: AQHPJvTSEFg6RWzcTkmmrdhNU0siNJqvo8WAgAADXDA=
Date: Tue, 11 Feb 2014 07:27:19 +0000
Message-ID: <32151e3d675b44e4812fe852a66832a6@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392097276-14705-1-git-send-email-Li.Xiubo@freescale.com>
 <1392097276-14705-2-git-send-email-Li.Xiubo@freescale.com>
 <20140211071403.GB18803@MrMyself>
In-Reply-To: <20140211071403.GB18803@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0119DC3B5E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(189002)(164054003)(4396001)(53806001)(46102001)(54356001)(76482001)(54316002)(56776001)(81342001)(33646001)(74876001)(50986001)(49866001)(47976001)(47736001)(93516002)(95416001)(69226001)(74706001)(94316002)(81542001)(94946001)(80976001)(77982001)(59766001)(95666001)(83322001)(79102001)(74366001)(76796001)(86362001)(76786001)(51856001)(63696002)(92566001)(56816005)(87936001)(76576001)(87266001)(65816001)(81816001)(81686001)(31966008)(74502001)(85306002)(74662001)(2656002)(90146001)(85852003)(83072002)(47446002)(66066001)(80022001)(74316001)(93136001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB441;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:7EE3C63E.3C205F29.5CE52DFF.94D2F011.20148;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > +  - big-endian : If this property is absent, the native endian mode will
> > +    be in use as default, or the big endian mode will be in use for all the
> > +    device registers.
> 
> > +
> > +
> 
> Single blank line should be enough here :)
> 

This will be removed.


> > @@ -687,6 +688,10 @@ static int fsl_esai_probe(struct platform_device *pdev)
> >  	esai_priv->pdev = pdev;
> >  	strcpy(esai_priv->name, np->name);
> >
> > +	esai_priv->big_endian = of_property_read_bool(np, "big-endian");
> > +	if (esai_priv->big_endian)
> > +		fsl_esai_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
> > +
> 
> Same comments here. And please wait for Shawn's reply at the other patch
> before you revise this part to V2.
> 

Okey,


Thanks,

--
Best Regards,
Xiubo
