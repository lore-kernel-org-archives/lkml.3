Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaAMJKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:10:05 -0500
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:21778
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751310AbaAMJJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:09:59 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>
CC: "broonie@linaro.org" <broonie@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>
Subject: RE: [alsa-devel] [PATCH] ASoC: simple-card: fix one bug to writing
 to the platform data
Thread-Topic: [alsa-devel] [PATCH] ASoC: simple-card: fix one bug to writing
 to the platform data
Thread-Index: AQHPDdQrauQsfk2sU0qCxbYVSBSSFZqCX5gQ
Date: Mon, 13 Jan 2014 09:09:43 +0000
Message-ID: <4ff4c32fbad64d90b0839a7a43642adb@BY2PR03MB505.namprd03.prod.outlook.com>
References: <20140110081729.035ce46f@armhf>
In-Reply-To: <20140110081729.035ce46f@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(51704005)(199002)(189002)(83072002)(85852003)(56816005)(51856001)(87266001)(87936001)(76796001)(93136001)(2656002)(33646001)(74502001)(74366001)(31966008)(80022001)(54316002)(47446002)(65816001)(74662001)(76482001)(63696002)(66066001)(74706001)(90146001)(74316001)(54356001)(46102001)(74876001)(83322001)(53806001)(69226001)(56776001)(4396001)(81816001)(79102001)(59766001)(92566001)(76786001)(76576001)(49866001)(80976001)(81686001)(77982001)(47976001)(47736001)(81342001)(50986001)(85306002)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0D9AOnX019783

Hi Mark, Jean-Francios

> If the original cinfo is not used anymore, the use of its structure to
> handle the card information is not a good idea:
> 
> - almost all cinfo information are in the struct snd_soc_card,
> 
> - this cinfo structure cannot be extended to handle many DAI links,
> 
> - it contains simple-card information which are of no use for the
>   platform caller.
> 
> So, I'd rather have seen:
> 
> - the removal of 'snd_link' and 'snd_card' from the platform interface
>   (struct asoc_simple_card_info),
> 
> - the definition of a local struct simple_card_data containing the
>   struct snd_soc_card and a pointer to an array of fmt/sysclk values
>   (one per DAI link).
>

@Jean-Francios, apart from this separate issue we're discussing, do you have
any comment on this patch itself?

@Mark, Since what Jean-Francios is concerned by is another issue apart from
this patch itself and being discussed, can you apply the patch?

Thanks,

--
Best Regards,
Xiubo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
