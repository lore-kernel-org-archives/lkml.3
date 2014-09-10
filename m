Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaIJQNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:13:15 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:47060 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaIJQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:13:14 -0400
From: "Patel, Gaurav" <gspatel@hp.com>
To: Ming Lei <ming.lei@canonical.com>, Robert Hancock <hancockrwd@gmail.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata
 controller
Thread-Topic: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata
 controller
Thread-Index: AQHPxb3TXu8CM/mi30KTwmTJFT1LRpv5xfoAgAAxCwCAAJ/iAA==
Date: Wed, 10 Sep 2014 16:11:59 +0000
Message-ID: <4693A34300ED74418DB0F7454C3D19DA16A9969B@G5W2736.americas.hpqcorp.net>
References: <CACVXFVN6f3Og+D_70M+4j_qhGNsryJWzTJK8G+rY0sxXweMqQg@mail.gmail.com>
	<540FC7C8.1070904@gmail.com>
 <CACVXFVOFci3572cJ=G8vAQ0-R_0A9rcDUcwa-8t0rjuGduJdwg@mail.gmail.com>
In-Reply-To: <CACVXFVOFci3572cJ=G8vAQ0-R_0A9rcDUcwa-8t0rjuGduJdwg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.201.12.26]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8AGDKN7017097


">> When we use hdparm to download firmware on system with Marvell 
>> 88SE9125 SATA controller, it returns failure always and it has been 
>> observed in several systems:"

 [Gaurav]:  So I have another moonshot cartridge with same SATA controller and I was able to update FW with hdparm with RedHat65 without any issues. So this looks to me issue with Ubuntu kernel dos not have correct driver (or something is missing to support hdparm or sata controller).  


Thanks,
Gaurav Patel
Email: Gspatel@hp.com
Cell # 832-382-5550


-----Original Message-----
From: Ming Lei [mailto:ming.lei@canonical.com] 
Sent: Wednesday, September 10, 2014 1:34 AM
To: Robert Hancock
Cc: linux-ide@vger.kernel.org; Tejun Heo; Linux Kernel Mailing List; Patel, Gaurav
Subject: Re: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata controller

On Wed, Sep 10, 2014 at 11:38 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 01/09/14 02:22 AM, Ming Lei wrote:
>>
>> Hi Guys,
>>
>> When we use hdparm to download firmware on system with Marvell 
>> 88SE9125 SATA controller, it returns failure always and it has been 
>> observed in several systems:
>>
>> #hdparm --fwdownload-mode7 fw.bin
>> --yes-i-kno-what-i-am-doing --please-destroy-my-drive /dev/sda
>>
>> /dev/sda:
>> fwdownload: xfer_mode=7 min=1 max=65535 size=699392
>> FAILED: Input/output error
>
>
> Any errors in dmesg after doing this?

No any failure log from kernel.

Thanks,
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
