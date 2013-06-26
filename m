Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab3FZCCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:02:34 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:21570 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3FZCCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:02:33 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>,
        "Shen, Voice" <Voice.Shen@atmel.com>, "Wu, Josh" <Josh.wu@atmel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Subject: RE: [PATCH 0/3] ARM: at91/DT: enable SPI for more SoCs
Thread-Topic: [PATCH 0/3] ARM: at91/DT: enable SPI for more SoCs
Thread-Index: AQHOcMaKAGpmq7nWiEK9hDRgNwiqQJlHP43g
Date: Wed, 26 Jun 2013 01:59:22 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641687DF77C@penmbx01>
References: <cover.1372069834.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1372069834.git.nicolas.ferre@atmel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5Q22cwY002549



> -----Original Message-----
> From: Nicolas Ferre [mailto:nicolas.ferre@atmel.com]
> Sent: 2013Äê6ÔÂ24ÈÕ 18:35
> To: Jean-Christophe PLAGNIOL-VILLARD; Desroches, Ludovic; Yang, Wenyou;
> Shen, Voice; Wu, Josh
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ferre,
> Nicolas
> Subject: [PATCH 0/3] ARM: at91/DT: enable SPI for more SoCs
> 
> This little series is for enabling the support of SPI on at91sam9n12 and
> sama5d3 families.
> 
> Nicolas Ferre (3):
>   ARM: at91/DT: fix SPI compatibility string
>   ARM: at91/DT: sama5d3: add SPI DMA client infos
>   ARM: at91/DT: at91sam9n12: add SPI DMA client infos
> 
>  arch/arm/boot/dts/at91sam9n12.dtsi |  6 ++++++
>  arch/arm/boot/dts/sama5d3.dtsi     | 10 ++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> --
> 1.8.2.2

Tested on sama5d34ek, Linux-next: next-20130624

Tested by Wenyou Yang <wenyou.yang@atmel.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
