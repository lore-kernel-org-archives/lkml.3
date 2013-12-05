Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3LFAIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:08:30 -0500
Received: from smtp.nokia.com ([147.243.128.25]:40971 "EHLO mgw-da03.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3LFAI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:08:28 -0500
X-Greylist: delayed 2230 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 19:08:27 EST
From: <ext-eero.1.nurkkala@here.com>
To: <nils.faerber@kernelconcepts.de>, <pali.rohar@gmail.com>,
        <hverkuil@xs4all.nl>, <m.chehab@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <joni.lapilainen@gmail.com>, <freemangordon@abv.bg>, <pavel@ucw.cz>,
        <aaro.koskinen@iki.fi>
Subject: RE: [PATCH] media: Add BCM2048 radio driver
Thread-Topic: [PATCH] media: Add BCM2048 radio driver
Thread-Index: AQHOybLAlgczbo/VpkC5+XphOdneGpn13XWAgANt+wCADi5XgIAABOuAgAAGZACADYyhAIAsm1WAgAPdcwCAAFvEAIAAChsAgAABp4CAAGH6LQ==
Date: Thu, 5 Dec 2013 20:03:52 +0000
Message-ID: <FD9B7CFF0C2EA64D911C748F7B8329910B4191D8@008-AM1MPN1-024.mgdnok.nokia.com>
References: <1381847218-8408-1-git-send-email-pali.rohar@gmail.com>
 <201312022151.07599@pali> <52A030BE.7040709@xs4all.nl>
 <201312051420.56852@pali>
 <20131205135705.GA3969@earth.universe>,<52A08795.3010809@kernelconcepts.de>
In-Reply-To: <52A08795.3010809@kernelconcepts.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [188.67.212.226]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB608a1E013196


> From: ext Nils Faerber [nils.faerber@kernelconcepts.de]
> Sent: Thursday, December 05, 2013 4:03 PM
> To: Pali Roh¨¢r; Hans Verkuil; Mauro Carvalho Chehab; linux-kernel@vger.kernel.org; linux-media@vger.kernel.org; Nurkkala Eero.1 (EXT-Haltian/Oulu); Joni Lapilainen; §ª§Ó§Ñ§Û§İ§à §¥§Ú§Ş§Ú§ä§â§à§Ó; Pavel Machek; aaro.koskinen@iki.fi
> Subject: Re: [PATCH] media: Add BCM2048 radio driver
>
> Am 05.12.2013 14:57, schrieb Sebastian Reichel:
>> On Thu, Dec 05, 2013 at 02:20:56PM +0100, Pali Roh¨¢r wrote:
>>>> Anyway, I've posted the pull request. Please note, if you want
>>>> to avoid having this driver be removed again in the future,
>>>> then you (or someone else) should work on addressing the
>>>> issues in the TODO file I added.
>>>
>>> Ok. CCing other people who works with n900 kernel.
>>
>> Does the bcm2048's radio part work without the bluetooth driver?
>

Hello all,
I recall that is doesn't work separately, but instead, it had to be powered
on via a separate hci command. I don't remember what it was though.
But again it maybe had to do with the configuration of the BT. Anyway,
by having no BT driver at all would make it impossible to use the radio alone.

- Eero

> At least I do not know.
> I just added the RDS data interface, I have no idea of about the
> hardware and the other parts of it, sorry.
>
>> -- Sebastian
> Cheers
>  nils
>
> --
> kernel concepts GmbH       Tel: +49-271-771091-12
> Sieghuetter Hauptweg 48
> D-57072 Siegen             Mob: +49-176-21024535
> http://www.kernelconcepts.de

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
