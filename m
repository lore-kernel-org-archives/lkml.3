Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaCYGTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 02:19:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59112 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaCYGS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 02:18:59 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
CC: "angus.clark@st.com" <angus.clark@st.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>
Subject: RE: New NAND driver
Thread-Topic: New NAND driver
Thread-Index: AQHPR2SOLGeGKBsUDE6pWz+wSbenrJrxU1jw
Date: Tue, 25 Mar 2014 06:18:16 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAB561C@DBDE04.ent.ti.com>
References: <20140324132446.GA21665@lee--X1>
In-Reply-To: <20140324132446.GA21665@lee--X1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2P6JGNA019413

Hi,

>From: Lee Jones
>
>Hi Brian,
>
>Firstly I'd like to thank you for supporting the inclusion of ST's SPI
>NOR (FSM) driver. As promised I will convert it over to the new
>framework once it has been applied by your good self.
>
>In the meantime however, I have a NAND driver which I need to
>submit. I wanted to give you a heads-up prior to sending it in case
>you had any special requests. FYI: Shoving it where the sun don't
>shine, is not a valid request by the way :). It's 2700 lines and I've
>split it over 47 patches for reviewing purposes.
>
Will it be possible for you to send the patches split in one patch per file ?
As switching back and forth, between 47 patches may be bit troublesome.
Later you may split it as you or others like..

>Sorry to do this to you Brian, I am sensitive to how over-burdened you
>are with the subsystem already. Perhaps it might make sense to put out
>a plea for volunteers to help with maintain MTD subsystem on LKML?
>
I can help reviewing those patches, if you can please share your
controller specs, and also share if there are any already know
hardware limitations.

>Anyway, what's the best thing to do in this instance? Should I just
>send it to the list as an RFC and be done with it?
>

with regards, pekon
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
