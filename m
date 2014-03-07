Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaCGJo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:44:57 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.164]:17053 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbaCGJox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:44:53 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-2.tower-39.messagelabs.com!1394185489!15677475!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Mark Brown <broonie@linaro.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V1 1/2] mfd: da9063: Upgrade of register definitions to
 support production silicon
Thread-Topic: [PATCH V1 1/2] mfd: da9063: Upgrade of register definitions to
 support production silicon
Thread-Index: AQHPObXTS8T+1TVdkkSfzHirxa5XqJrVXzmQ
Date: Fri, 7 Mar 2014 09:44:46 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A0C6C34C@SW-EX-MBX02.diasemi.com>
References: <cover.1394124002.git.stwiss.opensource@diasemi.com>
 <1e3f5e127c375a45b9a8e929fa99fa5c917b1dea.1394124002.git.stwiss.opensource@diasemi.com>
 <20140307033201.GA17063@lee--X1>
In-Reply-To: <20140307033201.GA17063@lee--X1>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s279j8Ob032491



>From: Lee Jones [mailto:lee.jones@linaro.org]
>Sent: 07 March 2014 03:32
>
>> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>>
>> This patch updates the register definitions for DA9063 to support the
>> production silicon variant code ID (0x5). These changes are not backwards
>> compatible with the previous register definitions and can only be used
>> with the production variant of DA9063.
>>
>> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>> ---
>> Checks performed with next-20140306/scripts/checkpatch.pl
>>  registers.h               total: 0 errors, 0 warnings, 1032 lines checked
>>
>> A brief summary of the changes include:
>>
>> - Introduction of a new DA9063_REG_ALARM_S register (now appearing at
>>   addr=0x46) allowing alarm second resolutions and which causes a shift
>>   in the register map for the RTC registers;
>> - Two new configuration registers DA9063_REG_CONFIG_M/N at 0x112 & 0x113;
>> - Modified register ranges for MON_REG_[1-6] which now appears at the
>>   addr=0x114 onwards;
>> - New register addresses for the general purpose registers GP_ID_[0-19]
>>   (now appearing at 0x121 onwards);
>> - Renaming of some definitions to match our hardware design conventions;
>> - There are also some bit-pattern additions that define some functionality
>>   alterations of the registers. One notable addition is:
>>   DA9063_BUCK_SLOWSTART can also be found in the CONTROL_B register and
>>   enables a BUCK slow start (reduced inrush current; increased startup
>>   time);
>>
>> This patch applies against kernel version linux-next next-20140306
>>
>>  include/linux/mfd/da9063/registers.h |  120 ++++++++++++++++++----------------
>>  1 file changed, 62 insertions(+), 58 deletions(-)
>
>What's the difference between this patch and the one you sent 2 days
>ago?
>

Hi Lee,

There's no difference in the patch for the registers.h.

I resent the whole patch set and renamed it from RFC to PATCH after
making the changes requested by Alessandro in the RTC driver.

Regards,
Steve
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
