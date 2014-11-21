Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbaKUMEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:04:25 -0500
Received: from s250.sam-solutions.net ([217.21.49.219]:58483 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbaKUMEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:04:24 -0500
From: Dmitry Lavnikevich <D.Lavnikevich@sam-solutions.com>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
CC: Support Opensource <Support.Opensource@diasemi.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Topic: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Index: AQHQBKf+aAnFetIHV0qwuDSOzEEmNpxpLRYAgAAdrYCAABozgIABZe2A
Date: Fri, 21 Nov 2014 12:04:06 +0000
Message-ID: <EFFD3D9B-9FA8-4DC6-9664-F62050232523@sam-solutions.com>
References: <1416477273-975-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <6ED8E3B22081A4459DAC7699F3695FB7D0B4836D@SW-EX-MBX02.diasemi.com>
 <8A823154-DC33-4A5A-9B4B-8B0E3BCFE83C@sam-solutions.com>
 <6ED8E3B22081A4459DAC7699F3695FB7D0B483EE@SW-EX-MBX02.diasemi.com>
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB7D0B483EE@SW-EX-MBX02.diasemi.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.111.33]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3D2F3001B00364DA20BDE325C82EF97@sam-solutions.net>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sALC4Wr0017169


> On 20Nov, 2014, at 15:43, Opensource [Steve Twiss] <stwiss.opensource@diasemi.com> wrote:
> 
> On 20 November 2014 13:09 Dmitry Lavnikevich wrote:
> [...]
>>> 
>>> da9063-rtc da9063-rtc: Failed to request ALARM IRQ -22: -22
>>> da9063-rtc: probe of da9063-rtc failed with error -22
>> 
>> I have tested this patch on pfla02 board and it was ok. On which
>> board this fail occurred?
> 
> I am using a MCIMX6DL-SDP board -- although I the differences are in
> my code base and not the platform in this case.
> My apologies 
> 
> Regards,
> Steve
> 
> patch follows:
[â€¦]

I see that your code also fixes the issue. And it is more consistent with da9055 implementation.
So there is no need for my fix if yours is already there. Is it already accepted on some mainline branch?
If not then are you going to submit it soon?ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
