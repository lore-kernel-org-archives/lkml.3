Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaCQDuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 23:50:13 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:33559
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932200AbaCQDuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 23:50:12 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@renesas.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 0/4] ASoC: simple-card: multi DAI links extension
Thread-Topic: [PATCH v3 0/4] ASoC: simple-card: multi DAI links extension
Thread-Index: AQHPQEOS/lO3JtGRYkO4Fxx98VFrkJrko1qg
Date: Mon, 17 Mar 2014 03:49:56 +0000
Message-ID: <48a8fabe07e641c5a30640816555b955@BY2PR03MB505.namprd03.prod.outlook.com>
References: <cover.1394883134.git.moinejf@free.fr>
In-Reply-To: <cover.1394883134.git.moinejf@free.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0153A8321A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(164054003)(93136001)(47976001)(87936001)(49866001)(76482001)(74316001)(87266001)(97186001)(56816005)(86362001)(92566001)(74662001)(74366001)(59766001)(54356001)(4396001)(2656002)(47446002)(56776001)(95416001)(54316002)(93516002)(90146001)(94946001)(53806001)(50986001)(81542001)(74706001)(95666003)(46102001)(51856001)(76796001)(65816001)(76576001)(63696002)(47736001)(85306002)(77982001)(66066001)(83072002)(74876001)(85852003)(33646001)(81686001)(76786001)(19580405001)(80976001)(81342001)(19580395003)(83322001)(31966008)(80022001)(79102001)(94316002)(81816001)(97336001)(74502001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:FCDD4721.A2120C11.49D35B8B.50E41A31.201D6;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH v3 0/4] ASoC: simple-card: multi DAI links extension
> 
> This patch series extends the simple card driver to handle
> many DAI links as this exists in the Cubox audio subsystem.
> 
> -v3
> 	- remove 'Fix the reference count of device nodes'
> 		which is applied (Mark Brown)
> 	- new patch 'Simplify code'
> 	- dynamically allocate and use properties for all DAI links
> 		(Jyri Sarha and Li Xiubo)


This patch series looks good to me.

For this patch series:
Reviewed-by: Xiubo Li <Li.Xiubo@freescale.com>


Thanks,

--
Best Regards,
Xiubo


> - v2
> 	- change subject/comment about device node reference count
> 		(Mark Brown)
> 	- use a null size array instead of an implicit area for the DAI links
> 		(Li Xiubo)
> 	- update the reference count of the device node at end of probe
> 
> Jean-Francois Moine (4):
>   ASoC: simple-card: Simplify code
>   ASoC: simple-card: dynamically allocate the DAI link and properties
>   ASoC: simple-card: Handle many DAI links
>   ASoC: simple-card: Add DT documentation for multi-DAI links
> 
>  .../devicetree/bindings/sound/simple-card.txt      |  34 +++-
>  sound/soc/generic/simple-card.c                    | 181 +++++++++++++-------
> -
>  2 files changed, 145 insertions(+), 70 deletions(-)
> 
> --
> 1.9.0
> 
> 

