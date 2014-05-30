Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaE3Kdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:33:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21463 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaE3Kdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:33:43 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7fef6d000003970-a7-53885e840708
Content-transfer-encoding: 8BIT
Message-id: <53885E84.3020407@samsung.com>
Date: Fri, 30 May 2014 19:33:40 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com
Subject: Re: [PATCHv2 2/3] regulator: s2mps11: Add support S2MPU02 regulator
 device
References: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
 <1401409510-28238-3-git-send-email-cw00.choi@samsung.com>
 <1401438205.9323.4.camel@AMDC1943>
In-reply-to: <1401438205.9323.4.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkSLclriPYYM09c4upD5+wWXSefcJs
	8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBa3G1ewWZzuZrW4uOILkwOXx85Zd9k9Nq3qZPO4
	c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbHuSxtrwVOVipkTWlgbGI/LdjFy
	ckgImEjs2HCHFcIWk7hwbz1bFyMXh5DAUkaJ208a2GCKVn95ygqRmM4o8ffXebAOXgFBiR+T
	77F0MXJwMAvISxy5lA0SZhZQl5g0bxEziC0k8JpR4s9VJ4hyLYkZnw+yg9gsAqoSv5+0gNWw
	AcX3v7gBtktUIExi5fQrLCC2iIChxMHd25lA9jIL3GOUWPl2CliDsECoRPP730wQBy1jlNh6
	9iwTSIJTQF/i7vmzLCAJCYGv7BIX9i5mhlgnIPFt8iGwSyUEZCU2HWCG+ExS4uCKGywTGMVm
	IflnFsI/s5D8s4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYGSe/vesfwfj3QPWhxiT
	gTZOZJYSTc4HRnZeSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQW
	H2Jk4uCUamAsTSyurt7UeuvF1vBrUioqhXYt72qaU5Zpnr4b0neqfAvDjilqN6u+JWntkbhz
	750uXw+3q8MDvbVyAsvWXpzPf/ENK49iZowsg+u/LXdnHO41cyy6+16qaZVOD+O6KO/Z6e8D
	9t9LtHoYcf6jXNRF3o/HxDL1Fq5//conuSV3R8mdiKuc3VeVWIozEg21mIuKEwGKNXbP4gIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd2WuI5ggyVt+hZTHz5hs+g8+4TZ
	4vULQ4uzTW/YLe5/Pcpo8e1KB5PF5V1z2CxuN65gszjdzWpxccUXJgcuj52z7rJ7bFrVyeZx
	59oeNo95JwM9+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLC
	XEkhLzE31VbJxSdA1y0zB+gwJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBh
	DWPGui9trAVPVSpmTmhhbWA8LtvFyMkhIWAisfrLU1YIW0ziwr31bF2MXBxCAtMZJf7+Og+W
	4BUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxg9hCAq8ZJf5cdYIo15KY8fkgO4jNIqAq
	8ftJC1gNG1B8/4sbbCC2qECYxMrpV1hAbBEBQ4mDu7czgexlFrjHKLHy7RSwBmGBUInm97+Z
	IA5axiix9exZJpAEp4C+xN3zZ1kmMArMQnLfLIT7ZiG5bwEj8ypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4Lh/JrWDcWWDxSFGAQ5GJR7exsj2YCHWxLLiytxDjBIczEoivA4xHcFCvCmJ
	lVWpRfnxRaU5qcWHGJOB3pvILCWanA9MSXkl8YbGJmZGlkbmhhZGxuakCSuJ8x5otQ4UEkhP
	LEnNTk0tSC2C2cLEwSnVwGgxj1s3WCzqb+iG9/17Kw9MjJhuvPzyi20VRW8PulzJEErXMqy/
	pXfi3yLFFSInFJT2Pdt/VPSb2pwbRd53ZT+/kzK7WXAqhkPElvnZRSWum/2+C2UdT3ku73jZ
	x6T5OsFaMP6Kae06A4eQzlv7Zrg8Wsn8ku/trbVL5nBITq84U+U69ezBJhUlluKMREMt5qLi
	RACH8tGJPwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 05/30/2014 05:23 PM, Krzysztof Kozlowski wrote:
> On pią, 2014-05-30 at 09:25 +0900, Chanwoo Choi wrote:
>> This patch add S2MPU02 regulator device to existing S2MPS11 device driver
>> because of little difference between S2MPS1x and S2MPU02. The S2MPU02
>> regulator device includes LDO[1-28] and BUCK[1-7].
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> [Add missing linear_min_sel of S2MPU02 LDO regulators by Jonghwa Lee]
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>  drivers/mfd/sec-core.c              |  26 +++
>>  drivers/regulator/s2mps11.c         | 319 +++++++++++++++++++++++++++++++++---
>>  include/linux/mfd/samsung/s2mpu02.h | 200 ++++++++++++++++++++++
>>  3 files changed, 525 insertions(+), 20 deletions(-)
>>  create mode 100644 include/linux/mfd/samsung/s2mpu02.h
>>
> 
> (...)
> 
>> diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
>> index 02e2fb2..f7e5dab3d 100644
>> --- a/drivers/regulator/s2mps11.c
>> +++ b/drivers/regulator/s2mps11.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/mfd/samsung/core.h>
>>  #include <linux/mfd/samsung/s2mps11.h>
>>  #include <linux/mfd/samsung/s2mps14.h>
>> +#include <linux/mfd/samsung/s2mpu02.h>
>>  
>>  struct s2mps11_info {
>>  	unsigned int rdev_num;
>> @@ -40,11 +41,15 @@ struct s2mps11_info {
>>  	int ramp_delay16;
>>  	int ramp_delay7810;
>>  	int ramp_delay9;
>> +
>> +	enum sec_device_type dev_type;
>> +
>>  	/*
>> -	 * One bit for each S2MPS14 regulator whether the suspend mode
>> +	 * One bit for each S2MPS14/S2MPU02 regulator whether the suspend mode
>>  	 * was enabled.
>>  	 */
>> -	unsigned int s2mps14_suspend_state:30;
>> +	unsigned long long s2mps14_suspend_state:35;
>> +
>>  	/* Array of size rdev_num with GPIO-s for external sleep control */
>>  	int *ext_control_gpio;
>>  };
>> @@ -415,12 +420,24 @@ static int s2mps14_regulator_enable(struct regulator_dev *rdev)
>>  	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
>>  	unsigned int val;
>>  
>> -	if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
>> -		val = S2MPS14_ENABLE_SUSPEND;
>> -	else if (gpio_is_valid(s2mps11->ext_control_gpio[rdev_get_id(rdev)]))
>> -		val = S2MPS14_ENABLE_EXT_CONTROL;
>> -	else
>> -		val = rdev->desc->enable_mask;
>> +	switch (s2mps11->dev_type) {
>> +	case S2MPS14X:
>> +		if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
>> +			val = S2MPS14_ENABLE_SUSPEND;
>> +		else if (gpio_is_valid(s2mps11->ext_control_gpio[rdev_get_id(rdev)]))
>> +			val = S2MPS14_ENABLE_EXT_CONTROL;
>> +		else
>> +			val = rdev->desc->enable_mask;
>> +		break;
>> +	case S2MPU02:
>> +		if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
>> +			val = S2MPU02_ENABLE_SUSPEND;
>> +		else
>> +			val = rdev->desc->enable_mask;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	};
>>  
>>  	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
>>  			rdev->desc->enable_mask, val);
>> @@ -431,16 +448,42 @@ static int s2mps14_regulator_set_suspend_disable(struct regulator_dev *rdev)
>>  	int ret;
>>  	unsigned int val;
>>  	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
>> +	int rdev_id = rdev_get_id(rdev);
>>  
>> -	/* LDO3 should be always on and does not support suspend mode */
>> -	if (rdev_get_id(rdev) == S2MPS14_LDO3)
>> -		return 0;
>> +	/* Below LDO should be always on or does not support suspend mode. */
>> +	switch (s2mps11->dev_type) {
>> +	case S2MPS14X:
>> +		switch (rdev_id) {
>> +		case S2MPS14_LDO3:
>> +			return 0;
>> +		};
>> +	case S2MPU02:
>> +		switch (rdev_id) {
>> +		case S2MPU02_LDO13:
>> +		case S2MPU02_LDO14:
>> +		case S2MPU02_LDO15:
>> +		case S2MPU02_LDO16:
>> +		case S2MPU02_LDO17:
>> +		case S2MPU02_BUCK7:
>> +			return 0;
>> +		};
>> +	default:
>> +		return -EINVAL;
>> +	};
>>  
>>  	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &val);
>>  	if (ret < 0)
>>  		return ret;
>>  
>> -	s2mps11->s2mps14_suspend_state |= (1 << rdev_get_id(rdev));
>> +	switch (s2mps11->dev_type) {
>> +	case S2MPS14X:
>> +	case S2MPU02:
>> +		s2mps11->s2mps14_suspend_state |= (1 << rdev_get_id(rdev));
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	};
>> +
> 
> I think this change is not needed. You are actually returning EINVAL on
> wrong devices in switch above so:
> 	s2mps11->s2mps14_suspend_state |= (1 << rdev_get_id(rdev));
> would be safe and sufficient.

OK I'll modify it as your comment.

> 
> Anyway:
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>


Thanks for your review.

Best Regards,
Chanwoo Choi

