Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaABCnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:43:37 -0500
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:34201
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750812AbaABCng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:43:36 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>
Subject: RE: [alsa-devel] [PATCH] ASoC: simple-card: Add device's module
 clock selection.
Thread-Topic: [alsa-devel] [PATCH] ASoC: simple-card: Add device's module
 clock selection.
Thread-Index: AQHO/7eRht/joVhyQkmusSJ033yrN5pv1ayAgAAEHwCAAO5iYA==
Date: Thu, 2 Jan 2014 02:43:31 +0000
Message-ID: <402820fba5e0467dbfad02024ad8de81@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1387783538-5318-1-git-send-email-Li.Xiubo@freescale.com>
 <52C405DD.1080006@metafoo.de> <20140101122554.GN31886@sirena.org.uk>
In-Reply-To: <20140101122554.GN31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51704005)(24454002)(199002)(479174003)(189002)(377454003)(164054003)(51856001)(74706001)(66066001)(76482001)(80022001)(54316002)(46102001)(47736001)(50986001)(2656002)(76576001)(53806001)(56776001)(47446002)(69226001)(74876001)(54356001)(4396001)(81342001)(65816001)(47976001)(49866001)(83322001)(74366001)(87266001)(74662001)(81542001)(76786001)(33646001)(81816001)(56816005)(74316001)(85306002)(87936001)(80976001)(59766001)(81686001)(90146001)(76796001)(79102001)(85852003)(83072002)(63696002)(31966008)(77982001)(74502001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB254;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Lars


> Subject: Re: [alsa-devel] [PATCH] ASoC: simple-card: Add device's module clock
> selection.
> 
> On Wed, Jan 01, 2014 at 01:11:09PM +0100, Lars-Peter Clausen wrote:
> > On 12/23/2013 08:25 AM, Xiubo Li wrote:
> > > diff --git a/a.out b/a.out
> > > new file mode 100644
> > > index 0000000..e69de29
> 
> > This patch did add a empty a.out file in the toplevel folder.
> 
> Removed now.  This is one of several patches from Xiubo that have done
> this - Xiubo, please check this.
>

Yes, this had been removed by Mark already.

Thanks,

--
Best Regards,
Xiubo
