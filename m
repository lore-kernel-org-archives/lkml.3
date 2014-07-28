Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaG1HoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:44:14 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.169]:18032 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbaG1HoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:44:09 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-5.tower-38.messagelabs.com!1406533445!16219380!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        RTC-LINUX <rtc-linux@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Support Opensource <Support.Opensource@diasemi.com>
Subject: RE: [RFC V2] mfd: da9063: Add support for AD silicon variant
Thread-Topic: [RFC V2] mfd: da9063: Add support for AD silicon variant
Thread-Index: AQHPpNLIdOWIFLEOJ0KMNFjTqwFoRZu1Bq+AgAAeu8A=
Date: Mon, 28 Jul 2014 07:44:03 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B28DF3@SW-EX-MBX02.diasemi.com>
References: <201407211058.s6LAwtk8003839@swsrvapps-01.diasemi.com>
 <20140728065251.GA5273@lee--X1>
In-Reply-To: <20140728065251.GA5273@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.61]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6S7iI0r014159


On 28 July 2014 07:53 Lee Jones wrote:

>On Mon, 21 Jul 2014, Opensource [Steve Twiss] wrote:
>> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>>
>> Add register definitions for DA9063 AD (0x3) silicon variant ID
>> the ability to choose the silicon variant at run-time using regmap
>> configuration. This patch also adds RTC support for the AD silicon
>> changes.
>>
>> It adds both BB and AD support as regmap ranges and then makes the
>> distinction between the two tables at run-time. This allows both AD
>> and BB silicon variants to be supported at the same time.
>>
>>
>> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> ---
>> Checks performed with linux-next/v3.16-rc5/scripts/checkpatch.pl
>>  rtc-da9063.c              total: 0 errors, 0 warnings, 353 lines checked
>>  da9063-core.c             total: 0 errors, 0 warnings, 188 lines checked
>>  da9063-i2c.c              total: 0 errors, 0 warnings, 266 lines checked
>>  core.h                    total: 0 errors, 0 warnings, 98 lines checked
>>  registers.h               total: 0 errors, 0 warnings, 1073 lines checked
>>
>> Thank you for your quick responses to my RFC-V1.
>>
>> This is in reply to comments made by Lee Jones, Alessandro Zummo and
>> Philipp Zabel. Please see the RFC-V1 thread for further details on
>> these discussions: https://lkml.org/lkml/2014/7/16/478
>>
>> Adding AD support using a compile-time flag under a new menu item in
>> Kconfig proved very unpopular for two main reasons.
>>
>> - Using ifdef else statements throughout the code
>> - Not supporting AD and BB silicon variants at the same time
>>
>> This RFC-V2 patch uses the method proposed by Philipp Zabel in his
>> reply e-mail: https://lkml.org/lkml/2014/7/18/219
>> and makes use of the regmap configuration method in da9063-i2c.c
>>
>> This patch applies against linux-next and v3.16-rc5
>>
>> Regards,
>> Steve Twiss, Dialog Semiconductor Ltd.
>>
>>  drivers/mfd/da9063-core.c            |    6 +-
>>  drivers/mfd/da9063-i2c.c             |  134 +++++++++++++++++++++++++++-------
>>  drivers/rtc/rtc-da9063.c             |   54 +++++++++-----
>>  include/linux/mfd/da9063/core.h      |    3 +-
>>  include/linux/mfd/da9063/registers.h |  129 +++++++++++++++++++++-----------
>>  5 files changed, 236 insertions(+), 90 deletions(-)
>
>Patch looks good to me.  Applied, thanks.
>

Thank you
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
