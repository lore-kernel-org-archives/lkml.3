Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3LaD3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 22:29:08 -0500
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:6187
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751361Ab3LaD3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 22:29:07 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "timur@tabi.org" <timur@tabi.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Fix one bug for hardware limitation.
Thread-Topic: [PATCH] ASoC: fsl_sai: Fix one bug for hardware limitation.
Thread-Index: AQHPAe2peeK/p0NkRUqA7v+Z1uebHJpsrcIAgADzyoA=
Date: Tue, 31 Dec 2013 03:29:04 +0000
Message-ID: <d2c60ec3b8a14500afef632e6163d57e@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388026642-1464-1-git-send-email-Li.Xiubo@freescale.com>
 <20131230121520.GR31886@sirena.org.uk>
In-Reply-To: <20131230121520.GR31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(24454002)(164054003)(199002)(189002)(51704005)(33646001)(74876001)(80976001)(76576001)(65816001)(74706001)(74316001)(79102001)(74366001)(76796001)(76786001)(47446002)(81686001)(31966008)(66066001)(80022001)(77982001)(63696002)(74662001)(81816001)(56776001)(54316002)(87266001)(85306002)(83072002)(85852003)(2656002)(56816005)(90146001)(87936001)(49866001)(47736001)(50986001)(47976001)(59766001)(83322001)(51856001)(4396001)(74502001)(81342001)(46102001)(76482001)(81542001)(54356001)(53806001)(69226001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> Subject: Re: [PATCH] ASoC: fsl_sai: Fix one bug for hardware limitation.
> 
> On Thu, Dec 26, 2013 at 10:57:22AM +0800, Xiubo Li wrote:
> > This is maybe one bug or a limitation of the hardware that the {T,R}CR2's
> > Synchronous Mode bits must be set as late as possible, or the SAI device
> > maybe hanged up, and there has not any explaination about this limitation
> > in the SAI Data Sheet.
> 
> If they really should be set as late as possible then I'd expect them to
> be being set in the trigger function, that's what gets called as the
> audio actually starts streaming.  This is moving it to the startup
> function which is one of the first things that happens during audio
> stream setup so presumably makes things worse.
> 

Yes, it is.

If everything is OK, I will send another new patch later.

Thanks,

---
Best Regards,
Xiubo
