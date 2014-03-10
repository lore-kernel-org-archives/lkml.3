Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaCJRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:16:56 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:24520 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbaCJRQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:16:54 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-3.tower-180.messagelabs.com!1394471811!28695963!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML-INPUT <linux-input@vger.kernel.org>,
        LKML-KERNEL <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@linaro.org>,
        "Philipp Zabel" <p.zabel@pengutronix.de>
Subject: RE: [PATCH V1 1/2] mfd: da9063: Linkages for ONKEY support in core
 files
Thread-Topic: [PATCH V1 1/2] mfd: da9063: Linkages for ONKEY support in core
 files
Thread-Index: AQHPPH91hS6LDNApCUKtebgPSHhKuZraj4Bg
Date: Mon, 10 Mar 2014 17:16:50 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A0C79090@SW-EX-MBX01.diasemi.com>
References: <cover.1394468644.git.stwiss.opensource@diasemi.com>
 <f5a169e00565134fa856a3daa615b17253ce844e.1394468644.git.stwiss.opensource@diasemi.com>
 <20140310164026.GB16697@lee--X1>
In-Reply-To: <20140310164026.GB16697@lee--X1>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2AHGxbr018456

On 10 March 2014 16:40, Lee Jones wrote:

>> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>>
>> This change adds the name field "ONKEY" to the properties of the
>> the OnKey IORESOURCE_IRQ resource structure (part of the mfd_cell
>> Onkey resource).
>>
>> The addition of bool key_power which will be passed to the onkey
>> driver and allow KEY_POWER support to be turned on/off as a
>> driver configuration option.
>>
>>
>> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>> ---
>> Checks performed with linux-next/next-20140307/scripts/checkpatch.pl
>>  da9063-core.c             total: 0 errors, 0 warnings, 189 lines checked
>>  pdata.h                   total: 0 errors, 0 warnings, 112 lines checked
>>
>> This change is a dependency for the new DA9063 OnKey driver which
>> forms the remainder of this patch set.
>> This patch applies against kernel linux-next next-20140307
>>
>> Regards,
>> Steve Twiss, Dialog Semiconductor Ltd.
>>
>>
>>
>>  drivers/mfd/da9063-core.c        | 1 +
>>  include/linux/mfd/da9063/pdata.h | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
>> index e70ae31..b410a14 100644
>> --- a/drivers/mfd/da9063-core.c
>> +++ b/drivers/mfd/da9063-core.c
>> @@ -60,6 +60,7 @@ static struct resource da9063_rtc_resources[] = {
>>
>>  static struct resource da9063_onkey_resources[] = {
>>  	{
>> +		.name	= "ONKEY",
>>  		.start	= DA9063_IRQ_ONKEY,
>>  		.end	= DA9063_IRQ_ONKEY,
>>  		.flags	= IORESOURCE_IRQ,
>> diff --git a/include/linux/mfd/da9063/pdata.h
>b/include/linux/mfd/da9063/pdata.h
>> index 95c8742..612383b 100644
>> --- a/include/linux/mfd/da9063/pdata.h
>> +++ b/include/linux/mfd/da9063/pdata.h
>> @@ -103,6 +103,7 @@ struct da9063;
>>  struct da9063_pdata {
>>  	int				(*init)(struct da9063 *da9063);
>>  	int				irq_base;
>> +	bool				key_power;
>>  	unsigned			flags;
>>  	struct da9063_regulators_pdata	*regulators_pdata;
>>  	struct led_platform_data	*leds_pdata;
>
>I'd like this change to be added by the first patch which makes use of
>it.
>

No problem,
I'll resent it as PATCH V2...

Regards,
Steve
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
