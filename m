Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaAMCCX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 21:02:23 -0500
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:49644
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110AbaAMCCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 21:02:20 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>
CC: "broonie@linaro.org" <broonie@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>
Subject: RE: [alsa-devel] [PATCH] ASoC: simple-card: fix one bug to writing
 to the platform data
Thread-Topic: [alsa-devel] [PATCH] ASoC: simple-card: fix one bug to writing
 to the platform data
Thread-Index: AQHPDdQrauQsfk2sU0qCxbYVSBSSFZqB6M7A
Date: Mon, 13 Jan 2014 02:02:16 +0000
Message-ID: <56f71334ad4f41ceaa6237d387e2b478@BY2PR03MB505.namprd03.prod.outlook.com>
References: <20140110081729.035ce46f@armhf>
In-Reply-To: <20140110081729.035ce46f@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51704005)(199002)(189002)(164054003)(54356001)(79102001)(53806001)(54316002)(49866001)(46102001)(50986001)(47976001)(65816001)(66066001)(63696002)(51856001)(47736001)(80976001)(83322001)(92566001)(33646001)(81816001)(93136001)(76796001)(76786001)(56776001)(76482001)(59766001)(77982001)(76576001)(74876001)(87936001)(31966008)(4396001)(81342001)(81686001)(80022001)(87266001)(85306002)(69226001)(74662001)(56816005)(2656002)(83072002)(47446002)(74316001)(90146001)(74706001)(81542001)(74366001)(74502001)(85852003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0D22Rl9018512

Hi Jean-Francois,

> 
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

I have sent one patch to fix some of these and mainly fixed the bug from
Mark's comments in another early email.

Thanks,

--
Best Regards,
Xiubo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
