Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaABD7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 22:59:43 -0500
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:46395
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750739AbaABD7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 22:59:41 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "rob@landley.net" <rob@landley.net>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: simple-card: Add DAPM routes parse from device
 tree
Thread-Topic: [PATCH] ASoC: simple-card: Add DAPM routes parse from device
 tree
Thread-Index: AQHPBiWWuTIMPp81c0S+kmyiU4vo4ppwzkfQ
Date: Thu, 2 Jan 2014 03:59:35 +0000
Message-ID: <a899f6babcfe4d6eaf559ba9b4ba8a81@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1387774621-23968-1-git-send-email-Li.Xiubo@freescale.com>
 <20131231123857.GS31886@sirena.org.uk>
In-Reply-To: <20131231123857.GS31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(189002)(199002)(51704005)(24454002)(77982001)(54316002)(50986001)(74876001)(47736001)(47976001)(33646001)(87266001)(81816001)(87936001)(2656002)(81686001)(76786001)(76796001)(66066001)(79102001)(80022001)(63696002)(31966008)(47446002)(74662001)(56776001)(4396001)(74502001)(65816001)(85306002)(49866001)(74706001)(76482001)(76576001)(56816005)(59766001)(83322001)(69226001)(83072002)(85852003)(51856001)(90146001)(74366001)(53806001)(46102001)(54356001)(80976001)(81342001)(74316001)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB256;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH] ASoC: simple-card: Add DAPM routes parse from device tree
> 
> On Mon, Dec 23, 2013 at 12:57:01PM +0800, Xiubo Li wrote:
> > Parses a simple DAPM route table from device tree.
> 
> I've applied this on the basis that it's using a generic feature and
> won't do any harm but given that no off-CODEC widgets are defined I do
> have to wonder when it'll actually be useful.

Yes, it will be useful for the Vybird and LS-1 boards and also many others.

And for the simple-card there still needs the off-CODEC widgets registering,
I'll send the followed patches later.


Thanks,

--
Best Regards,
Xiubo
