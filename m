Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994AbaFRFGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:06:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58729 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbaFRFGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:06:53 -0400
Message-ID: <53A11E17.3010508@ti.com>
Date: Wed, 18 Jun 2014 10:35:27 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Keerthy <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Subject: Re: [PATCH 5/9] regulator: palmas: Shift the reg_info structure definition
 to the header file
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com> <1401272423-25761-6-git-send-email-j-keerthy@ti.com> <20140617163259.GP29841@lee--X1>
In-Reply-To: <20140617163259.GP29841@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2014 10:02 PM, Lee Jones wrote:
> On Wed, 28 May 2014, Keerthy wrote:
>
>> Shift the reg_info structure definition to the header file.
>>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> ---
>>   drivers/regulator/palmas-regulator.c |    9 ---------
>>   include/linux/mfd/palmas.h           |    9 +++++++++
>>   2 files changed, 9 insertions(+), 9 deletions(-)
> Patch looks fine.  I guess we'll wait and pull the entire set in once
> it's ready.
>
> Acked-by: Lee Jones <lee.jones@linaro.org>

Thanks.

>
>> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
>> index 9602eba..d41f3de 100644
>> --- a/drivers/regulator/palmas-regulator.c
>> +++ b/drivers/regulator/palmas-regulator.c
>> @@ -27,15 +27,6 @@
>>   #include <linux/of_platform.h>
>>   #include <linux/regulator/of_regulator.h>
>>   
>> -struct regs_info {
>> -	char	*name;
>> -	char	*sname;
>> -	u8	vsel_addr;
>> -	u8	ctrl_addr;
>> -	u8	tstep_addr;
>> -	int	sleep_id;
>> -};
>> -
>>   static const struct regulator_linear_range smps_low_ranges[] = {
>>   	REGULATOR_LINEAR_RANGE(500000, 0x1, 0x6, 0),
>>   	REGULATOR_LINEAR_RANGE(510000, 0x7, 0x79, 10000),
>> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
>> index 52a24a9..150a6314 100644
>> --- a/include/linux/mfd/palmas.h
>> +++ b/include/linux/mfd/palmas.h
>> @@ -88,6 +88,15 @@ struct palmas {
>>   	u8 pwm_muxed;
>>   };
>>   
>> +struct regs_info {
>> +	char	*name;
>> +	char	*sname;
>> +	u8	vsel_addr;
>> +	u8	ctrl_addr;
>> +	u8	tstep_addr;
>> +	int	sleep_id;
>> +};
>> +
>>   struct palmas_gpadc_platform_data {
>>   	/* Channel 3 current source is only enabled during conversion */
>>   	int ch3_current;

