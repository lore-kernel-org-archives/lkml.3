Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaBKHjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:39:51 -0500
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:34741
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750825AbaBKHjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:39:48 -0500
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
Thread-Index: AQHPJvTIhHGuF/I49EuZaw8bNa7Cepqvos2AgAAGauA=
Date: Tue, 11 Feb 2014 07:39:44 +0000
Message-ID: <1a10273e564a4bb7a5aafe3f01ccffa2@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392097276-14705-1-git-send-email-Li.Xiubo@freescale.com>
 <20140211071034.GA18803@MrMyself>
In-Reply-To: <20140211071034.GA18803@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0119DC3B5E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(164054003)(199002)(189002)(74502001)(74662001)(47446002)(49866001)(74316001)(54316002)(51856001)(4396001)(47736001)(50986001)(47976001)(81686001)(33646001)(87266001)(74366001)(46102001)(76482001)(74706001)(53806001)(56776001)(54356001)(69226001)(31966008)(79102001)(59766001)(77982001)(63696002)(65816001)(87936001)(74876001)(2656002)(95416001)(66066001)(80022001)(81816001)(92566001)(83072002)(56816005)(81542001)(85852003)(90146001)(93516002)(76796001)(76786001)(76576001)(85306002)(81342001)(93136001)(80976001)(83322001)(86362001)(94946001)(94316002)(95666001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB444;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:7AE9C9EE.9210C423.71E187B2.86E62131.20142;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > +   - big-endian : If this property is absent, the native endian mode will
> > +   be in use as default, or the big endian mode will be in use for all the
> > +   device registers.
> > +
> 
> @Shawn
> Does DT have an existing approach to determine if the current SoC this IP
> uses is BE or LE? I am thinking the scenario that if all drivers support
> BE/LE while the SoC is big-endian, all the nodes in the DT would have to
> include a duplicated property (big-endian).
> 

@Nicolin, @Shawn
One special scenario likes the LS1 platform, the CPU and a few devices are in
LE mode and other devices will be in BE mode.

Thanks,

--
Best Regards,
Xiubo
