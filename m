Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3HPRNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:13:49 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:28557
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab3HPRNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:13:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371Ic89bh936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h839h8e2h8e3h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Li Yang-R58472 <r58472@freescale.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: System suspend states and device driver suspend() callback
Thread-Topic: System suspend states and device driver suspend() callback
Thread-Index: AQHOmlevaKyDtL1EQU+OBxMir9SK85mXs+gAgABfUm0=
Date: Fri, 16 Aug 2013 17:13:42 +0000
Message-ID: <02318724-F4F7-4D53-9926-872E9417F672@freescale.com>
References: <CADRPPNSD+uj_t5+qbNW29y7SuJkB_vMck-DGFJFV4A0AmPC6pQ@mail.gmail.com>,<17024788.0xFN8jEV59@vostro.rjw.lan>
In-Reply-To: <17024788.0xFN8jEV59@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7GHDqdu024228



ÔÚ 2013-8-16£¬ÏÂÎç7:22£¬"Rafael J. Wysocki" <rjw@sisk.pl> Ğ´µÀ£º

> On Friday, August 16, 2013 04:06:26 PM Li Yang wrote:
>> Hi Guys,
>> 
>> Is there a standard way for the device drivers to know if the system
>> is going to ¡°standby¡± mode or ¡°mem¡± mode when the suspend() callbacks
>> are called?
> 
> No, there's none.
> 
> What do you need that for?

Some chips like ours are putting the on-chip devices into different low power states when entering different system low power states.  When we enter system standby, on-chip devices are clock gated.  While entering suspend to ram, on-chip devices are power gated.  We want to driver to act differently too when entering different suspend states.

- Leo

> 
> Rafael
> 
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
