Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaAPISu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:18:50 -0500
Received: from [207.46.163.189] ([207.46.163.189]:56456 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750836AbaAPISs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:18:48 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: David Rientjes <rientjes@google.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: simple-card: Add snd_card's name parsing from DT
 node support
Thread-Topic: [PATCH] ASoC: simple-card: Add snd_card's name parsing from DT
 node support
Thread-Index: AQHPEneV3eXWkcd1sUuNGlCPhxSZTpqGy4UAgAA1p24=
Date: Thu, 16 Jan 2014 08:16:54 +0000
Message-ID: <78cfe3325da44b3ba5f444bb4c2d16fe@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389844801-29309-1-git-send-email-Li.Xiubo@freescale.com>,<alpine.DEB.2.02.1401152102330.20635@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401152102330.20635@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(779001)(679001)(689001)(51704005)(199002)(189002)(56816005)(85852003)(83072002)(76482001)(47446002)(51856001)(2656002)(74366001)(33646001)(63696002)(74502001)(80022001)(65816001)(93516002)(74662001)(66066001)(90146001)(46102001)(74706001)(74316001)(54356001)(54316002)(31966008)(74876001)(77982001)(47736001)(83322001)(53806001)(4396001)(81816001)(85306002)(49866001)(80976001)(59766001)(56776001)(69226001)(92566001)(87266001)(76796001)(93136001)(87936001)(76786001)(76576001)(81542001)(81342001)(81686001)(47976001)(79102001)(50986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,


> >  sound/soc/generic/simple-card   | 0
> >  sound/soc/generic/simple-card.  | 0
> >  sound/soc/generic/simple-card.c | 7 ++++++-
> >  3 files changed, 6 insertions(+), 1 deletion(-)
> >  create mode 100644 sound/soc/generic/simple-card
> >  create mode 100644 sound/soc/generic/simple-card.
>
> Probably not the intention to create these empty files.

Yes,  I have resent this patch.

Thanks very much,

Best Regards,