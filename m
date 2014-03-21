Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbaCUGqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 02:46:24 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:18880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759815AbaCUGqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 02:46:20 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be
 visible in Kconfig
Thread-Topic: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be
 visible in Kconfig
Thread-Index: AQHPJtx7vjnlwG7hYkWLGSOUXx6EvJq9cbFAgAAL8wCAAAZ4gIAtzMbQ
Date: Fri, 21 Mar 2014 06:46:11 +0000
Message-ID: <0bc01e5036fa4a11beaea10c56c283fe@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392086825-15737-1-git-send-email-Li.Xiubo@freescale.com>
 <1392086825-15737-2-git-send-email-Li.Xiubo@freescale.com>
 <36d9c0a870604fbe87b129e95fea9da1@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140220024432.GU2669@sirena.org.uk> <20140220030739.GA26721@MrMyself>
In-Reply-To: <20140220030739.GA26721@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(377454003)(13464003)(199002)(189002)(51704005)(46102001)(81816001)(93516002)(86362001)(81686001)(95416001)(94946001)(51856001)(63696002)(79102001)(74706001)(77982001)(59766001)(20776003)(80022001)(80976001)(65816001)(54316002)(19580395003)(19580405001)(47446002)(74502001)(74662001)(31966008)(83322001)(69226001)(74876001)(76482001)(66066001)(97186001)(81542001)(54356001)(94316002)(53806001)(97336001)(83072002)(56776001)(81342001)(56816005)(49866001)(93136001)(85852003)(47976001)(47736001)(95666003)(2656002)(87266001)(76796001)(76576001)(85306002)(74316001)(74366001)(33646001)(50986001)(4396001)(92566001)(90146001)(87936001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB441;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:BEFDF7E6.2CD2E786.B8D095B4.AE68AF0.202E5;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Has this patch been missing? I couldn't found it anywhere in the next branch.
:)

Thanks very much,

--
Best Regards,
Xiubo



> -----Original Message-----
> From: Nicolin Chen [mailto:Guangyu.Chen@freescale.com]
> Sent: Thursday, February 20, 2014 11:08 AM
> To: Mark Brown
> Cc: Xiubo Li-B47053; lgirdwood@gmail.com; shawn.guo@linaro.org; perex@perex.cz;
> tiwai@suse.de; Estevam Fabio-R49496; alsa-devel@alsa-project.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be
> visible in Kconfig
> 
> On Thu, Feb 20, 2014 at 11:44:32AM +0900, Mark Brown wrote:
> > On Thu, Feb 20, 2014 at 02:06:20AM +0000, Li.Xiubo@freescale.com wrote:
> >
> > > I'm not very sure of this patch, maybe should we add one menu
> > > in Kconfig for all visible CPU DAIs firstly like for code drivers?
> >
> > Allowing them to be individually selected is definitely useful if people
> > are trying to minimise their kernel size and/or build time.  However
> > none of the other Freescale people have commented on this patch (which
> > I'd have expected) so I was giving them time and IIRC it needs a rebase
> > against current code.
> 
> Last month I was revising a new CODEC driver for ESAI and meanwhile abort
> to plan to try simple card for this combination but being suspended due to
> some tough internal issues. So I think it should be a good idea for us to
> move towards simple card starting from this patch.
> 
> Surely, Acked.
> Nicolin Chen
> 

