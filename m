Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaB1HTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:19:00 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:37970
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750719AbaB1HS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:18:59 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH 2/3] ASoC: core: Set the default I/O up try
 regmap.
Thread-Topic: [alsa-devel] [PATCH 2/3] ASoC: core: Set the default I/O up
 try regmap.
Thread-Index: AQHPM6qACYVR5A4ww0ayWu7DY52qF5rKCb6AgAAA4rCAABoHAIAAB6RAgAALwACAAAAvYIAAAhGAgAAEQ0CAAAPJgIAAAKpg
Date: Fri, 28 Feb 2014 07:18:54 +0000
Message-ID: <497c5d0ca8914036a8adfc23a73b1979@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
 <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com>
 <20140228035244.GJ9383@sirena.org.uk>
 <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140228052904.GP9383@sirena.org.uk>
 <1b89016263c84e0297655034a648032f@BY2PR03MB505.namprd03.prod.outlook.com>
 <53102EE4.80702@metafoo.de>
 <d872d0fd60eb4c01b38af98014c802aa@BY2PR03MB505.namprd03.prod.outlook.com>
 <531030C7.2060703@metafoo.de>
 <5d534c2ac77040d9bc373db9e43dde7c@BY2PR03MB505.namprd03.prod.outlook.com>
 <53103787.2020702@metafoo.de>
In-Reply-To: <53103787.2020702@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(86362001)(81342001)(83322001)(54316002)(56776001)(47736001)(81542001)(47446002)(47976001)(69226001)(87266001)(2656002)(76482001)(4396001)(46102001)(74502001)(87936001)(93136001)(49866001)(93516002)(50986001)(92566001)(80976001)(33646001)(74662001)(51856001)(53806001)(85306002)(74366001)(59766001)(81816001)(63696002)(74316001)(81686001)(76576001)(76786001)(76796001)(66066001)(74876001)(74706001)(83072002)(85852003)(54356001)(95666003)(94946001)(31966008)(94316002)(95416001)(79102001)(77982001)(65816001)(80022001)(90146001)(56816005)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB427;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:E5F2CF0F.29E08445.B8D232EB.52E0DFD4.200AB;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> A quick grep reveals:
> mc13783.c:	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
> si476x.c:	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
> wm5102.c:	codec->control_data = priv->core.arizona->regmap;
> wm5110.c:	codec->control_data = priv->core.arizona->regmap;
> wm8997.c:	codec->control_data = priv->core.arizona->regmap;
> 
> But there might be more.
>

Yes, I'll check it more carefully...

Thanks very much.


Best Regards,
Xiubo
 

