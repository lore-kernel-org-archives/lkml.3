Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaABC51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:57:27 -0500
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:24420
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaABC50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:57:26 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: add snd_soc_of_parse_master_clkdir() for dt
Thread-Topic: [PATCH] ASoC: add snd_soc_of_parse_master_clkdir() for dt
Thread-Index: AQHPBgd6kgMwPKbTukmZCPAWoW4YuZpuNMqAgAKKssA=
Date: Thu, 2 Jan 2014 02:57:22 +0000
Message-ID: <0e22852f970e476cb02a446094e3f7c4@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388477444-18745-1-git-send-email-Li.Xiubo@freescale.com>
 <20131231120415.GL31886@sirena.org.uk>
In-Reply-To: <20131231120415.GL31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(24454002)(164054003)(51704005)(189002)(199002)(65816001)(80976001)(74366001)(66066001)(83322001)(80022001)(76482001)(54356001)(79102001)(51856001)(59766001)(77982001)(56816005)(54316002)(56776001)(53806001)(63696002)(81686001)(83072002)(69226001)(47736001)(81542001)(49866001)(4396001)(2656002)(46102001)(74876001)(47976001)(33646001)(50986001)(81342001)(76576001)(81816001)(87936001)(76796001)(76786001)(85852003)(74316001)(85306002)(87266001)(74662001)(31966008)(74706001)(90146001)(74502001)(47446002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH] ASoC: add snd_soc_of_parse_master_clkdir() for dt
> 
> On Tue, Dec 31, 2013 at 04:10:44PM +0800, Xiubo Li wrote:
> 
> > I'm not very sure whether this patch is need for dt.
> 
> It's not clear to me - it's not adding much on top of just passing the
> full property string to _read_bool() directly really.
>

This was just inherited from the _daifmt formats. Maybe this is not very
correct here.

> > For the CPU and CODEC devices' sysclk directions maybe different of
> > the same DAI link.
> 
> Yes, this is common if one of them is generating the clock.

I will use one full name for the next verion.

 
Thanks,

--
Best Regards,
Xiubo
