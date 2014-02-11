Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbaBKHZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:25:30 -0500
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:15236
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750758AbaBKHZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:25:29 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] ASoC: fsl-spdif: big-endian support
Thread-Topic: [PATCH 1/2] ASoC: fsl-spdif: big-endian support
Thread-Index: AQHPJvTIhHGuF/I49EuZaw8bNa7Cepqvos2AgAACwaA=
Date: Tue, 11 Feb 2014 07:25:25 +0000
Message-ID: <3a4d25c844a94dd4a7483fc426d28ec4@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392097276-14705-1-git-send-email-Li.Xiubo@freescale.com>
 <20140211071034.GA18803@MrMyself>
In-Reply-To: <20140211071034.GA18803@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0119DC3B5E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(189002)(4396001)(51856001)(54356001)(76482001)(53806001)(56776001)(54316002)(81342001)(33646001)(74876001)(49866001)(47976001)(50986001)(47736001)(95416001)(94946001)(76796001)(74706001)(81542001)(93516002)(90146001)(94316002)(80976001)(59766001)(77982001)(95666001)(83322001)(79102001)(76786001)(74366001)(46102001)(63696002)(2656002)(56816005)(92566001)(74502001)(87936001)(86362001)(76576001)(65816001)(81816001)(81686001)(74662001)(85306002)(31966008)(69226001)(87266001)(93136001)(85852003)(83072002)(74316001)(47446002)(66066001)(80022001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB443;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:DFEBFCAE.FC10D462.8BC03FDF.84E1E92B.200C7;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	spdif_priv->big_endian = of_property_read_bool(np, "big-endian");
> > +	if (spdif_priv->big_endian)
> > +		fsl_spdif_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
> 
> Why not just:
> 	if (of_property_read_bool(np, "big-endian"))
> 		fsl_spdif_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
>

I just think maybe other places of the driver maybe use this.
Yes, it could be removed just for now.

See the next version please.

Thanks very much,

--
Best Regards,
Xiubo

