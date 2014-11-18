Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaKRBOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:14:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaKRBOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:14:40 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-a4-546a9d7e5535
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <546A9D7D.7040207@samsung.com>
Date: Tue, 18 Nov 2014 10:14:37 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
Cc: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it, lgirdwood@gmail.com, sbkim73@samsung.com,
        sameo@linux.intel.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 4/5] rtc: s5m: Add the support for S2MPS13 RTC
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
 <5469CBB0.5070704@samsung.com>
In-reply-to: <5469CBB0.5070704@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsWyRsSkRLdublaIwYODKhZLLl5lt5j68Amb
	xfwj51gt/kxoZbOYdH8Ci8XrF4YWZ5vesFvc/3qU0eLblQ4mi8u75rBZPJ1wkc3idDerxcUV
	X5gceD12zrrL7rFpVSebx51re9g85p0M9OjbsorRY/q8n0wenzfJBbBHcdmkpOZklqUW6dsl
	cGUs+/OIveCxWsX5w54NjI3yXYycHBICJhLzp59lhbDFJC7cW8/WxcjFISSwlFHixP4nTDBF
	SyYfYAexhQSmM0ps3cgJYvMKCEr8mHyPBcRmFlCXmDRvETOELSIxqfsAI4StLbFs4WtmiKGv
	GSVWXdrICtGsJXFt1jywIhYBVYm7z9aAxdmA4vtf3GADsUUFwiRWTr8CtkBEwE3i9MXVTCCD
	mAWWMUkcOfsKLCEs4CQxaf4nqLPnMUpcvnQJqIqDgxNo9ZnNZRAfdHJIHHqqC7FMQOLb5EMs
	ICUSArISmw4wQ5RIShxccYNlAqP4LCS/zULy2ywkv81C8tsCRpZVjKKpBckFxUnpRSZ6xYm5
	xaV56XrJ+bmbGIHxfvrfswk7GO8dsD7EKMDBqMTDmzg1K0SINbGsuDL3EKMp0EUTmaVEk/OB
	SSWvJN7Q2MzIwtTE1NjI3NJMSZz3tdTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MeheF
	9+UF2sjHVmsHmDxrNjAxKfTuLWf5vCJ8Ktc0mZ7EQ+HrHDm0ym8sdFiXxcg050tw52LzpPDc
	Qt5lBmbOl1oK5sbESrzXTmBxzjifN99LyFhgolsum/9mZ8V33pfm7BHW8XZs/7/p+j/TBjeu
	bfebeGvFfr1R13L8UWCzZ3up2oR1q5RYijMSDbWYi4oTASXxHgryAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd26uVkhBi/sLZZcvMpuMfXhEzaL
	+UfOsVr8mdDKZjHp/gQWi9cvDC3ONr1ht7j/9SijxbcrHUwWl3fNYbN4OuEim8XpblaLiyu+
	MDnweuycdZfdY9OqTjaPO9f2sHnMOxno0bdlFaPH9Hk/mTw+b5ILYI9qYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpVSaEsMacUKBSQWFyspG+H
	aUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx78YXpoLNahVTZuxhbGC8KNfFyMkhIWAisWTyAXYI
	W0ziwr31bCC2kMB0RomtGzlBbF4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RcxcjF1D5
	a0aJVZc2skLUa0lcmzWPEcRmEVCVuPtsDVicDSi+/8UNsPmiAmESK6dfYQGxRQTcJE5fXM0E
	MohZYBmTxJGzr8ASwgJOEpPmf2KD2DCPUeLypUtMIFdwCmhLnNlcNoFRYBaS+2Yh3DcLyX0L
	GJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSnhmfSOxhXNVgcYhTgYFTi4U2cmhUixJpY
	VlyZe4hRgoNZSYT3XDdQiDclsbIqtSg/vqg0J7X4EKMp0HcTmaVEk/OBaSuvJN7Q2MTMyNLI
	3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVANjkzVD/5wfsl4bVqRGmDmlPisKdxdN
	rvF8NfOGcIfL3ofRXA5hT7Kag5Sly7jPxXRtzfjburvrUP/MFTeiPF4/OBs/Oe6U0o2TO3pu
	GGhNj/qVuPuv/sJuBeuLqSs0p+9y4j78m23jNKvY8Db9hoNmvVenbRXjsNZ8vo9RPfuA9ueL
	13R+KP5QYinOSDTUYi4qTgQA6SFv+CMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 11/17/2014 07:19 PM, Krzysztof Kozłowski wrote:
> On 17.11.2014 01:42, Chanwoo Choi wrote:
>> This patch adds only the compatible string for S2MPS13 clock which is identical
>> with S2MPS14 clock driver.
>>
>> Cc: Alessandro Zummo <a.zummo@towertech.it>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/rtc/rtc-s5m.c | 15 ++++++++++++++-
>>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> The RTC block looks exactly the same as S2MPS14. I wonder can S2MPS13 be
> supported without adding all "+ case S2MPS13X:" here? Maybe pass the
> same ID in s5m_rtc_id? This would reduce number of changes to only one line.

I tried to use S2MPS14x type without adding S2MPS13X.
But, there are two method to probe RTC driver probe.
First, as you comment, use s5m_rtc_id (in drivers/rtc/rtc-s5m.c) to probe S2MPS13 RTC.
Second, register mfd devcies for s2mps13 RTC(in drivers/mfd/sec-core.c) to probe S2MPS13 RTC.

We could support S2MPS13 RTC to modify s5m_rtc_id table in first case as you comment,
But, We could not support S2MPS13 RTC in second case because S2MPS13 is different from S2MPS14
and S2MPS13 must have other type form existing S2MPS14x type.

Best Regards,
Chanwoo Choi

> 
> Best regards,
> Krzysztof
> 
> 
>>
>> diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
>> index 8754c33..e5fdfd3 100644
>> --- a/drivers/rtc/rtc-s5m.c
>> +++ b/drivers/rtc/rtc-s5m.c
>> @@ -191,6 +191,7 @@ static inline int s5m_check_peding_alarm_interrupt(struct s5m_rtc_info *info,
>>  		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
>>  		val &= S5M_ALARM0_STATUS;
>>  		break;
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		ret = regmap_read(info->s5m87xx->regmap_pmic, S2MPS14_REG_ST2,
>>  				&val);
>> @@ -254,6 +255,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
>>  	case S5M8767X:
>>  		data &= ~S5M_RTC_TIME_EN_MASK;
>>  		break;
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		data |= S2MPS_RTC_RUDR_MASK;
>>  		break;
>> @@ -311,7 +313,9 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
>>  	u8 data[info->regs->regs_count];
>>  	int ret;
>>  
>> -	if (info->device_type == S2MPS14X) {
>> +	switch (info->device_type) {
>> +	case S2MPS13X:
>> +	case S2MPS14X:
>>  		ret = regmap_update_bits(info->regmap,
>>  				info->regs->rtc_udr_update,
>>  				S2MPS_RTC_RUDR_MASK, S2MPS_RTC_RUDR_MASK);
>> @@ -333,6 +337,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
>>  		break;
>>  
>>  	case S5M8767X:
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		s5m8767_data_to_tm(data, tm, info->rtc_24hr_mode);
>>  		break;
>> @@ -359,6 +364,7 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
>>  		s5m8763_tm_to_data(tm, data);
>>  		break;
>>  	case S5M8767X:
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		ret = s5m8767_tm_to_data(tm, data);
>>  		break;
>> @@ -406,6 +412,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>>  		break;
>>  
>>  	case S5M8767X:
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		s5m8767_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
>>  		alrm->enabled = 0;
>> @@ -454,6 +461,7 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
>>  		break;
>>  
>>  	case S5M8767X:
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		for (i = 0; i < info->regs->regs_count; i++)
>>  			data[i] &= ~ALARM_ENABLE_MASK;
>> @@ -498,6 +506,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
>>  		break;
>>  
>>  	case S5M8767X:
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		data[RTC_SEC] |= ALARM_ENABLE_MASK;
>>  		data[RTC_MIN] |= ALARM_ENABLE_MASK;
>> @@ -537,6 +546,7 @@ static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>>  		break;
>>  
>>  	case S5M8767X:
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		s5m8767_tm_to_data(&alrm->time, data);
>>  		break;
>> @@ -641,6 +651,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
>>  		ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
>>  		break;
>>  
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		data[0] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
>>  		ret = regmap_write(info->regmap, info->regs->ctrl, data[0]);
>> @@ -678,6 +689,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
>>  		return -ENOMEM;
>>  
>>  	switch (pdata->device_type) {
>> +	case S2MPS13X:
>>  	case S2MPS14X:
>>  		regmap_cfg = &s2mps14_rtc_regmap_config;
>>  		info->regs = &s2mps_rtc_regs;
>> @@ -831,6 +843,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
>>  
>>  static const struct platform_device_id s5m_rtc_id[] = {
>>  	{ "s5m-rtc",		S5M8767X },
>> +	{ "s2mps13-rtc",	S2MPS13X },
>>  	{ "s2mps14-rtc",	S2MPS14X },
>>  };
>>  
>>
> 
> 

