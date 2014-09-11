Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaIKArb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 20:47:31 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:52804 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbaIKAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 20:47:29 -0400
From: "Patel, Gaurav" <gspatel@hp.com>
To: Ming Lei <ming.lei@canonical.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata
 controller
Thread-Topic: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata
 controller
Thread-Index: AQHPxb3TXu8CM/mi30KTwmTJFT1LRpv5xfoAgAAxCwCAAJ/iAIAAc7kAgAAc0yA=
Date: Thu, 11 Sep 2014 00:45:22 +0000
Message-ID: <4693A34300ED74418DB0F7454C3D19DA16A99994@G5W2736.americas.hpqcorp.net>
References: <CACVXFVN6f3Og+D_70M+4j_qhGNsryJWzTJK8G+rY0sxXweMqQg@mail.gmail.com>
	<540FC7C8.1070904@gmail.com>
	<CACVXFVOFci3572cJ=G8vAQ0-R_0A9rcDUcwa-8t0rjuGduJdwg@mail.gmail.com>
	<4693A34300ED74418DB0F7454C3D19DA16A9969B@G5W2736.americas.hpqcorp.net>
 <CACVXFVPen-__38-XGHAe2Yxb0CGVLr3sGxQXvvk=Zkwzn-A_gA@mail.gmail.com>
In-Reply-To: <CACVXFVPen-__38-XGHAe2Yxb0CGVLr3sGxQXvvk=Zkwzn-A_gA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.49.17]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8B0lZgW020069

I will try to update kernel on Ubuntu to 2.6.32 and run the test.

I was not able to install 3.16 ubuntu kernel on RrdHat.

Thanks,
Gaurav Patel
Email: Gspatel@hp.com
Cell # 832-382-5550

-----Original Message-----
From: Ming Lei [mailto:ming.lei@canonical.com] 
Sent: Wednesday, September 10, 2014 6:01 PM
To: Patel, Gaurav
Cc: Robert Hancock; linux-ide@vger.kernel.org; Tejun Heo; Linux Kernel Mailing List
Subject: Re: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata controller

On Thu, Sep 11, 2014 at 12:11 AM, Patel, Gaurav <gspatel@hp.com> wrote:
>
> ">> When we use hdparm to download firmware on system with Marvell
>>> 88SE9125 SATA controller, it returns failure always and it has been 
>>> observed in several systems:"
>
>  [Gaurav]:  So I have another moonshot cartridge with same SATA controller and I was able to update FW with hdparm with RedHat65 without any issues. So this looks to me issue with Ubuntu kernel dos not have correct driver (or something is missing to support hdparm or sata controller).

But RedHat65 ships a 2.6.32 kernel as you said, and you can test the stable
2.6.32 kernel on one ubuntu release too.

As far as I can tell, the problem is very probably related with kernel, that is why I suggest you to test upstream kernel and run 'git bisect' later to find the commit which caused the regression.

But looks you have simply install problem.

Thanks,


>
> Thanks,
> Gaurav Patel
> Email: Gspatel@hp.com
> Cell # 832-382-5550
>
>
> -----Original Message-----
> From: Ming Lei [mailto:ming.lei@canonical.com]
> Sent: Wednesday, September 10, 2014 1:34 AM
> To: Robert Hancock
> Cc: linux-ide@vger.kernel.org; Tejun Heo; Linux Kernel Mailing List; 
> Patel, Gaurav
> Subject: Re: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata 
> controller
>
> On Wed, Sep 10, 2014 at 11:38 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> On 01/09/14 02:22 AM, Ming Lei wrote:
>>>
>>> Hi Guys,
>>>
>>> When we use hdparm to download firmware on system with Marvell
>>> 88SE9125 SATA controller, it returns failure always and it has been 
>>> observed in several systems:
>>>
>>> #hdparm --fwdownload-mode7 fw.bin
>>> --yes-i-kno-what-i-am-doing --please-destroy-my-drive /dev/sda
>>>
>>> /dev/sda:
>>> fwdownload: xfer_mode=7 min=1 max=65535 size=699392
>>> FAILED: Input/output error
>>
>>
>> Any errors in dmesg after doing this?
>
> No any failure log from kernel.
>
> Thanks,
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
