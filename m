Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaB1EAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:00:54 -0500
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:9450
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750818AbaB1EAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:00:53 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: RE: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
Thread-Topic: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
Thread-Index: AQHPM6qACYVR5A4ww0ayWu7DY52qF5rKCb6AgAAA4rA=
Date: Fri, 28 Feb 2014 04:00:38 +0000
Message-ID: <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
 <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com>
 <20140228035244.GJ9383@sirena.org.uk>
In-Reply-To: <20140228035244.GJ9383@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(189002)(199002)(24454002)(51704005)(63696002)(90146001)(69226001)(80022001)(66066001)(76576001)(76796001)(93136001)(81342001)(47976001)(65816001)(95666003)(93516002)(56776001)(4396001)(74876001)(74706001)(46102001)(47736001)(94316002)(50986001)(77982001)(49866001)(53806001)(85306002)(47446002)(86362001)(92566001)(95416001)(76482001)(54356001)(74502001)(31966008)(94946001)(74316001)(74662001)(54316002)(85852003)(83322001)(33646001)(87936001)(79102001)(59766001)(80976001)(81686001)(83072002)(2656002)(87266001)(51856001)(74366001)(81542001)(81816001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB425;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:BCFAF600.9C207C05.33E19F4F.38C1B881.20142;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
> 
> On Thu, Feb 27, 2014 at 05:49:52PM +0800, Xiubo Li wrote:
> > For most CODEC drivers which the REGMAP is used, the soc_probe_codec()
> > will do the stuff work of snd_soc_codec_set_cache_io(), which the CODEC
> > drivers' ASoC probe will do too, and almost at the same time.
> 
> Applied, thanks.  I did a check of the drivers and it looks like they'll
> all be fine with this.

Yes.

I'll send another patches to applied to use this for another CODEC drivers.
And there almost 80 files, Should I send them in one patch or split them into
individual patch for each CODEC driver ?

Thanks,

--
Best Regards,
Xiubo

