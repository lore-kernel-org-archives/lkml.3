Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbaAFX4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:56:37 -0500
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:31374
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932350AbaAFX4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:56:34 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>
Subject: RE: [PATCH] ASoC: simple-card: fix the DAPM routes map parsing
Thread-Topic: [PATCH] ASoC: simple-card: fix the DAPM routes map parsing
Thread-Index: AQHPCqnhkhktsB+otUONkNvyeu4gq5p31QWAgACK8T0=
Date: Mon, 6 Jan 2014 23:56:31 +0000
Message-ID: <e12f227126e64f98bec92d0884cb3d56@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388986906-32139-1-git-send-email-Li.Xiubo@freescale.com>,<20140106153715.GZ31886@sirena.org.uk>
In-Reply-To: <20140106153715.GZ31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [211.155.113.253]
x-forefront-prvs: 0083A7F08A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(51704005)(189002)(199002)(85852003)(83072002)(56816005)(81542001)(90146001)(74662001)(31966008)(76786001)(76796001)(76576001)(81342001)(69226001)(47446002)(74502001)(54316002)(63696002)(65816001)(66066001)(80022001)(53806001)(54356001)(46102001)(51856001)(76482001)(59766001)(77982001)(79102001)(47976001)(50986001)(56776001)(47736001)(4396001)(49866001)(74706001)(83322001)(558084003)(33646001)(74876001)(85306002)(74366001)(74316001)(81686001)(2656002)(81816001)(80976001)(87936001)(87266001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:211.155.113.253;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > The simple-card's DAPM route maping is optional. For example, the spdif has
> > no need of this.
> 
> This doesn't seem to apply against current code, can you please check
> and resend?
>
Yes, I will.

Thanks,

--
Best Regards,
Xiubo