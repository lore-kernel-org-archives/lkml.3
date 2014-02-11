Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaBKBfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:35:19 -0500
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:54293
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752133AbaBKBfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:35:16 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>
Subject: RE: [PATCH v2] ASoC: fsl-sai: convert to use regmap API for
 Freeacale SAI
Thread-Topic: [PATCH v2] ASoC: fsl-sai: convert to use regmap API for
 Freeacale SAI
Thread-Index: AQHPJKEhZlIN1QfzEk2n7gs7XZaenZqufoIAgADKv8A=
Date: Tue, 11 Feb 2014 01:34:55 +0000
Message-ID: <9a21e8cc57f54793a05d33f2ca6d7ec0@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1391841508-14025-1-git-send-email-Li.Xiubo@freescale.com>
 <20140210132746.GD1757@sirena.org.uk>
In-Reply-To: <20140210132746.GD1757@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0119DC3B5E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(164054003)(51704005)(189002)(199002)(81686001)(65816001)(81816001)(31966008)(76576001)(63696002)(2656002)(87266001)(56816005)(92566001)(87936001)(85852003)(83072002)(74316001)(47446002)(66066001)(80022001)(93136001)(74662001)(85306002)(74502001)(90146001)(51856001)(95416001)(93516002)(94316002)(94946001)(81542001)(74706001)(69226001)(46102001)(53806001)(54316002)(56776001)(54356001)(76482001)(4396001)(50986001)(47976001)(49866001)(74876001)(47736001)(81342001)(33646001)(76796001)(74366001)(86362001)(76786001)(80976001)(79102001)(95666001)(77982001)(59766001)(83322001)(19580395003)(19580405001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB441;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:7EDDF181.16106C89.BDE1878C.F4D160BB.20119;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Subject: Re: [PATCH v2] ASoC: fsl-sai: convert to use regmap API for Freeacale
> SAI
> 
> On Sat, Feb 08, 2014 at 02:38:28PM +0800, Xiubo Li wrote:
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> 
> Applied, thanks but I think this needs a select of REGMAP_MMIO in the
> Kconfig to ensure that regmap-mmio is actually there (it might well be
> OK due to implicit dependencies at the minute but should be fixed
> properly).

Yes, I will send another patch to fix it.

Thanks,

--
Best Regards,
Xiubo

