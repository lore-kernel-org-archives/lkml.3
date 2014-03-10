Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaCJDvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 23:51:44 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:13189
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752771AbaCJDvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 23:51:43 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
Thread-Topic: [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
Thread-Index: AQHPNpOHBWw5RTyHRUi7LlXismLKZJrOzasAgAAnM/CAAWR6gIAJX3lQ
Date: Mon, 10 Mar 2014 03:51:40 +0000
Message-ID: <0dbba1debfd149a6a5e3985349a95793@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
 <1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com>
 <20140303045952.GO2411@sirena.org.uk>
 <5bc570ec866541a68df5813ffbe3168e@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140304043603.GI2411@sirena.org.uk>
In-Reply-To: <20140304043603.GI2411@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 014617085B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(24454002)(189002)(95666003)(51856001)(47736001)(50986001)(4396001)(49866001)(47976001)(74662001)(65816001)(47446002)(31966008)(74502001)(46102001)(74366001)(19580395003)(19580405001)(83322001)(93516002)(80022001)(90146001)(63696002)(33646001)(66066001)(56816005)(74706001)(79102001)(93136001)(86362001)(92566001)(94946001)(97186001)(97336001)(95416001)(94316002)(87936001)(83072002)(80976001)(85852003)(87266001)(2656002)(85306002)(74316001)(81816001)(74876001)(81686001)(69226001)(81542001)(81342001)(54356001)(77982001)(59766001)(53806001)(56776001)(76786001)(76796001)(76482001)(54316002)(76576001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB427;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:F4FEFD0E.C0E25F29.B9E0B182.EADED0.20195;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
> 
> On Mon, Mar 03, 2014 at 07:24:36AM +0000, Li.Xiubo@freescale.com wrote:
> 
> > > >  	/* Default to using ALC auto offset calibration mode. */
> > > >  	snd_soc_update_bits(codec, DA7213_ALC_CTRL1,
> > > >  			    DA7213_ALC_CALIB_MODE_MAN, 0);
> 
> > > This one will fail.
> 
> > Sorry, I'm not very understand why will this fail ? Before the ASoC probe,
> > the ASoC core will set the I/O.
> > :)
> 
> OK, that's now been refactored.

@Mark, @Lars,

Has there any other problems about this patch series? And this I had tested on
our Vybrid-Twr board based on SGTL5000 codec and SAI drivers. If not, I can
continue with my second patches series about " Remove set_cache_io entirely from
ASoC probe".

Thanks very much.

--
Best Regards,
Xiubo
