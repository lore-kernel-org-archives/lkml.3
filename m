Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab3EUBcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 21:32:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29937 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3EUBb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 21:31:58 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7f096d0000043fc-26-519ace8d9ea5
Content-transfer-encoding: 8BIT
Message-id: <519ACE88.3090503@samsung.com>
Date: Tue, 21 May 2013 10:31:52 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/3] Thermal: core: Modify temp_crit_show() to use proper
 callback function.
References: <1368870656-1183-1-git-send-email-jonghwa3.lee@samsung.com>
 <744357E9AAD1214791ACBA4B0B9092630110240D@SHSMSX101.ccr.corp.intel.com>
In-reply-to: <744357E9AAD1214791ACBA4B0B9092630110240D@SHSMSX101.ccr.corp.intel.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkRLf33KxAg/+72CyWPJjCaLFm/08m
	i8u75rBZfO49wmhxu3EFm8WTh31sDmwei/e8ZPK4c20Pm0ffllWMHsdvbGfy+LxJLoA1issm
	JTUnsyy1SN8ugSujeeM8toJZAhX/559ha2CcydvFyMkhIWAi0fd6KxuELSZx4d56IJuLQ0hg
	KaPEujPL2GCKdu7ZzA6RWMQo8brvEjNIgldAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvE
	DFH/klHixo4nUPVaEp/bZzOC2CwCqhJ3T/8Gi7MJyEm8bfoGFhcVCJO4OuE4C4gtIqAmce7f
	DyaQQcwCzUwSU7ZvBSsSFkiSWHxrM1izkMBEoIs2BoPYnEDNLee6wS6VEDjFLrGl6TobxDYB
	iW+TD4FdKiEgK7HpADPEZ5ISB1fcYJnAKDYLyT+zEP6ZheSfBYzMqxhFUwuSC4qT0osM9YoT
	c4tL89L1kvNzNzECo+30v2e9OxhvH7A+xJgMtHEis5Rocj4wWvNK4g2NzYwsTE1MjY3MLc1I
	E1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwHhuuZfb9V+Sqj3hads1ZorJc55U
	XLC+KPCXUcMMe8enWbUef3l2lj2s9FBewXxMtditfubnRsOukgZTzWyulyaLuT8W/T224Mzn
	e65dp6qnZHjtmTztv2OhoKjK9k03WUq3b5XZ7BfFy/vpjfasDfcMfql83H/y+jnWq/2lrzJZ
	XY+KGs5KslFiKc5INNRiLipOBAA4WJ1bzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd2ec7MCDU5OsLFY8mAKo8Wa/T+Z
	LC7vmsNm8bn3CKPF7cYVbBZPHvaxObB5LN7zksnjzrU9bB59W1Yxehy/sZ3J4/MmuQDWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGc0b57EVzBKo+D//DFsD40zeLkZO
	DgkBE4mdezazQ9hiEhfurWfrYuTiEBJYxCjxuu8SM0iCV0BQ4sfkeyxdjBwczALyEkcuZYOE
	mQXUJSbNW8QMUf+SUeLGjidQ9VoSn9tnM4LYLAKqEndP/waLswnISbxt+gYWFxUIk7g64TgL
	iC0ioCZx7t8PJpBBzALNTBJTtm8FKxIWSJJYfGszWLOQwESgizYGg9icQM0t57rZJzAKzEJy
	3yyE+2YhuW8BI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBYfia1g3Flg8UhRgEORiUe
	XgHDWYFCrIllxZW5hxglOJiVRHi/NwOFeFMSK6tSi/Lji0pzUosPMSYDfTeRWUo0OR+YZvJK
	4g2NTcyMLI3MDS2MjM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgXG22tobkRfO7i+/
	u1s5OvlqdkrTq9CLzkIdWwtFgnz27DWX1F9teFK/iPuaavqK8Ll+T97deNTqLlF796p/NW9L
	f0jt3cIiA0nT9BUlZ7+d9LgYPUd314MeuTm7H/ZnurwWS32923B9WsBfPgt7Lqe4Fqe+myv7
	TM7djz3opztFsuhZ7TXPXUosxRmJhlrMRcWJAHbDd0ApAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 05월 21일 00:57, Zhang, Rui wrote:

> 
> 
>> -----Original Message-----
>> From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
>> Sent: Saturday, May 18, 2013 5:51 PM
>> To: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org; Zhang, Rui; Eduardo Valentin; Amit
>> Dinel Kachhap; Jonghwa Lee; MyungJoo Ham
>> Subject: [PATCH 2/3] Thermal: core: Modify temp_crit_show() to use
>> proper callback function.
>> Importance: High
>>
>> This patch modifies temp_crit_show() which is used to create hwmon's
>> sysfs node to use .get_crit_temp callback function of thermal zone
>> device rather than .get_trip_temp.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> The problem is that .get_crit_temp is optional for thermal drivers
> that has a critical trip point.


Actually, this is a interface for hwmon not generic thermal framework. And when
we create this node through the thermal_add_hwmon_sysfs(), we've already checked
whether call back function is available. So the problem won't happen.

Thanks
Jonghwa

> At least we do not have such kind of check in thermal core.
> Take rcar_thermal driver for example,
> It supports critical trip point but it does not have .get_crit_type.
> 
> So I'd like to see a fix in rcar thermal driver and thermal core
> for this issue, together with this patch.
> 
> Thanks,
> rui
>> ---
>>  drivers/thermal/thermal_core.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/thermal/thermal_core.c
>> b/drivers/thermal/thermal_core.c index f753f48..ce4384a 100644
>> --- a/drivers/thermal/thermal_core.c
>> +++ b/drivers/thermal/thermal_core.c
>> @@ -924,7 +924,7 @@ temp_crit_show(struct device *dev, struct
>> device_attribute *attr,
>>  	long temperature;
>>  	int ret;
>>
>> -	ret = tz->ops->get_trip_temp(tz, 0, &temperature);
>> +	ret = tz->ops->get_crit_temp(tz, &temperature);
>>  	if (ret)
>>  		return ret;
>>
>> --
>> 1.7.9.5
> 
> 


