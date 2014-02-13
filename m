Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaBMKDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:03:22 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:18566
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbaBMKDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:03:19 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(z3197rz98dI9371I936eI148cI542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275dh1de097h186068hz2dh109h2a8h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Paul Bolle <pebolle@tiscali.nl>, Steven Miao <realmz6@gmail.com>
CC: Richard Weinberger <richard@nod.at>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open 
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Subject: RE: blackfin: Kconfig symbol VIDEO_MT9M114?
Thread-Topic: blackfin: Kconfig symbol VIDEO_MT9M114?
Thread-Index: AQHPJ9v3+hYtWqHlukeho8e+vnryFZqzOBYAgAAIaoD//7TkkA==
Date: Thu, 13 Feb 2014 10:01:50 +0000
Message-ID: <B168F8A49F4BCF4C84FD23DA5F6363EE61150705@NWD2MBX7.ad.analog.com>
References: <1392200311.23759.27.camel@x220>
	 <CAMk6uBk+jPpDOwN6C+xkuhWB1b3EGxb205-JhnK2JZhZMvVn2w@mail.gmail.com>
 <1392283815.30853.11.camel@x220>
In-Reply-To: <1392283815.30853.11.camel@x220>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.24.87]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1DA3TSE026291

Hi Paul,

I will send out a patch to remove it.

Regards,

Sonic

>-----Original Message-----
>From: Paul Bolle [mailto:pebolle@tiscali.nl]
>Sent: Thursday, February 13, 2014 5:30 PM
>To: Steven Miao
>Cc: Zhang, Sonic; Richard Weinberger; adi-buildroot-devel@lists.sourceforge.net;
>open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
>list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list
>Subject: Re: blackfin: Kconfig symbol VIDEO_MT9M114?
>
>Hi Steven,
>
>On Thu, 2014-02-13 at 17:00 +0800, Steven Miao wrote:
>> VIDEO_MT9M114 is from patch "Aptina mt9m114 HD digital image sensor
>> driver", but unfortunately this patch hasn't been accepted yet.
>> https://patchwork.linuxtv.org/patch/16308/
>> This Kconfig symbol should be removed until the mt9m114 driver is
>> accepted by mainline.
>
>Thanks for looking into this.
>
>It's easy for me to submit a trivial patch to remove the one line depending on these
>Kconfig macros. But it seems that line should be added to the queue for that driver at
>the same time, otherwise we risk losing it. So it's safer if you or the people working on
>that driver coordinate that, isn't it?
>
>
>Paul Bolle
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
