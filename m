Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaANH4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:56:37 -0500
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:13452
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750999AbaANH4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:56:35 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [RFC][PATCH] ASoC: simple-card: Add
	asoc_simple_card_data for the simple card driver data
Thread-Topic: [alsa-devel] [RFC][PATCH] ASoC: simple-card: Add
	asoc_simple_card_data for the simple card driver data
Thread-Index: AQHPEPZQHcGE1bEqj0q1mNvuGMgzF5qD2O6A
Date: Tue, 14 Jan 2014 07:56:32 +0000
Message-ID: <96cb876ff05c4062ab5a2c92fb7b3c41@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389678282-1097-1-git-send-email-Li.Xiubo@freescale.com>
 <871u0bgiai.wl%kuninori.morimoto.gx@gmail.com>
In-Reply-To: <871u0bgiai.wl%kuninori.morimoto.gx@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0091C8F1EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(679001)(689001)(51704005)(199002)(189002)(164054003)(79102001)(54356001)(53806001)(54316002)(50986001)(49866001)(46102001)(65816001)(47976001)(66066001)(63696002)(80976001)(19580405001)(19580395003)(47736001)(83322001)(51856001)(33646001)(92566001)(93136001)(81816001)(76796001)(76786001)(56776001)(76482001)(59766001)(77982001)(81686001)(76576001)(74876001)(87936001)(31966008)(4396001)(80022001)(81342001)(87266001)(56816005)(85306002)(224313003)(74662001)(69226001)(2656002)(83072002)(47446002)(224303002)(74316001)(90146001)(81542001)(85852003)(74706001)(74502001)(74366001)(15866825004)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Whether the dt is used or not, almost all the simple card information
> > for the DAI link and sound card are initialized in the simple card driver.
> >
> > And for the platform caller, the snd_link and snd_card are of no use, so
> > move them from struct asoc_simple_card_info to struct asoc_simple_card_data.
> >
> > And now only one DAI link is supported for simple card.
> >
> > Suggested-by: Jean-Francois Moine <moinejf@free.fr>
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> 
> This patch seems have many this kind of lines
>   -	info->xxx
>   +	sdata->info->xxx
> 
> But, how about add this line to each function ?
> 
>      struct asoc_simple_card_info *info = &sdata->info;
> 
> Patch will be more readable
>

Yes, that's looks perfect.

See the next version please.

Thanks,

--
Best Regards,
Xiubo


