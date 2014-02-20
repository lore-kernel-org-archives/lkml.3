Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaBTIo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:44:59 -0500
Received: from mail-bn1lp0153.outbound.protection.outlook.com ([207.46.163.153]:2903
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbaBTIo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:44:57 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be
 visible in Kconfig
Thread-Topic: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be
 visible in Kconfig
Thread-Index: AQHPJtx7vjnlwG7hYkWLGSOUXx6EvJq9cbFAgAAL8wCAAGPWUA==
Date: Thu, 20 Feb 2014 08:44:52 +0000
Message-ID: <5ca19952e55e4a719ecd7034ca595aba@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392086825-15737-1-git-send-email-Li.Xiubo@freescale.com>
 <1392086825-15737-2-git-send-email-Li.Xiubo@freescale.com>
 <36d9c0a870604fbe87b129e95fea9da1@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140220024432.GU2669@sirena.org.uk>
In-Reply-To: <20140220024432.GU2669@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.215]
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(199002)(189002)(51704005)(24454002)(95416001)(93136001)(94316002)(86362001)(80022001)(66066001)(93516002)(85306002)(80976001)(65816001)(54316002)(53806001)(19580395003)(19580405001)(83322001)(59766001)(76482001)(56776001)(94946001)(54356001)(50986001)(47976001)(83072002)(51856001)(79102001)(46102001)(92566001)(33646001)(74366001)(47446002)(74502001)(31966008)(74662001)(87266001)(47736001)(49866001)(63696002)(74316001)(95666001)(2656002)(77982001)(4396001)(87936001)(76796001)(76786001)(56816005)(74876001)(81342001)(81542001)(85852003)(69226001)(90146001)(76576001)(74706001)(81686001)(81816001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB444;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.215;FPR:7CE9F4D4.CF00741.BAE5A9BC.4E5ABF0.201D8;MLV:nov;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Subject: Re: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be
> visible in Kconfig
> 
> On Thu, Feb 20, 2014 at 02:06:20AM +0000, Li.Xiubo@freescale.com wrote:
> 
> > I'm not very sure of this patch, maybe should we add one menu
> > in Kconfig for all visible CPU DAIs firstly like for code drivers?
> 
> Allowing them to be individually selected is definitely useful if people
> are trying to minimise their kernel size and/or build time.  However
> none of the other Freescale people have commented on this patch (which
> I'd have expected) so I was giving them time and IIRC it needs a rebase
> against current code.

Yes, Surely.

As we can see that there will be many CPU DAI drivers to be visible in the
future, and they will get a bit noisy too. IMHO, put the CPU DAI drivers in
a menu is a good choice for other separate patches.

Thanks very much,

--
Best Regards,
Xiubo
