Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbbATG75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:59:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:22930 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbATG7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:59:55 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-7f-54bdfce9e1ba
Date: Tue, 20 Jan 2015 06:59:30 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCHv8 1/9] devfreq: event: Add new devfreq_event class to
 provide basic data for devfreq governor
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150120064732896@myungjoo.ham
Msgkey: 20150120064732896@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150120064732896@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <213049974.1319841421737167629.JavaMail.weblogic@epmlwas04a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkUPfln70hBq3vBCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGy4OrbAWTzCpW/jzO3MB4x6SLkZNDSEBdYtGSk2wgtoSAicTu
	1edZIWwxiQv31gPFuYBqljJKLHr/DK5owoWzrBCJOYwS8xs3gyVYBFQlNt8/xtzFyMHBJqAn
	MfNzMkhYWKBUYtfFJrChIgKuEivXLmIB6WUW2MomcegLRK+QgJLEmn2vWEBsXgFBiZMzn7BA
	LFOVWHShhx0iriZx5ectZoi4uMSFuZfYIWxeiRntT6Hq5SSmfV0DVSMtcX7WBkaYbxZ/fwwV
	55c4dnsHE4QtIDH1zEGoGi2J9R9nQX3PJ7Fm4VsWmPpdp5Yzw+y6v2UuVK+ExNaWJ2D1zAKK
	ElO6H7KD/M4soCmxfpc+qlc4gGwPiWWHfUFelxCYyiFx/+IclgmMSrOQlM1CMmkWwiRkJQsY
	WVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBKaF0/+eTdjBeO+A9SFGAQ5GJR7eF6v2hgix
	JpYVV+YeYjQFRtJEZinR5Hxg8skriTc0NjOyMDUxNTYytzRTEud9LfUzWEggPbEkNTs1tSC1
	KL6oNCe1+BAjEwenVAPjxIf/7+XemdhZLqTTkuAhE75OiLd21c3TCy3uXK0q16ypusN5+Enj
	6VcWnnufeL1r79+1o16IL+WdsxabxqYDx7vOv+O7FWZw5Z7R7OOWIt9lmmacvGA+82ywSMe+
	20duf3ojMonxFpvE/geSZ1mja75mp6SF5jAHtTK/f3OgUe+NfqpTU1qdEktxRqKhFnNRcSIA
	b9382QYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tPt1Lf/aGGMz9amBxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jJa
	HlxlK5hkVrHy53HmBsY7Jl2MnBxCAuoSi5acZAOxJQRMJCZcOMsKYYtJXLi3HijOBVQzh1Fi
	fuNmsCIWAVWJzfePMXcxcnCwCehJzPycDBIWFiiV2HWxCaxXRMBVYuXaRSwgvcwCW9kkDn2B
	6BUSUJJYs+8VC4jNKyAocXLmExaIZaoSiy70sEPE1SSu/LzFDBEXl7gw9xI7hM0rMaP9KVS9
	nMS0r2ugaqQlzs/awAhz9OLvj6Hi/BLHbu9ggrAFJKaeOQhVoyWx/uMsqCf5JNYsfMsCU7/r
	1HJmmF33t8yF6pWQ2NryBKyeWUBRYkr3Q3aQ35kFNCXW79JH9QoHkO0hseyw7wRG2VlIMrOQ
	NM9CaEZWsoCRZRWjaGpBckFxUnqFoV5xYm5xaV66XnJ+7iZGcAp6tnAH45fz1ocYBTgYlXh4
	X6zaGyLEmlhWXJl7iFGCg1lJhHfCU6AQb0piZVVqUX58UWlOavEhRlNglE1klhJNzgemx7yS
	eENjYxMzE1NLEwsDU3Mlcd7/53JDhATSE0tSs1NTC1KLYPqYODilGhjTFzjc3v/Uh6c39cv7
	TXf2qVT0Pv/De63/ysE/KeyG9n3xP+omBs6J2ydXYTPPmZnRrVZ/3eZFR3ZL392b8sVht4S0
	U8+ikCSucv0innnGdQGXK09sucIctDfcv+Dk84K4xcIzPDbEM/qoHlu21Zv7uug6j+A/UdnK
	3yRXTd6cLMCavrKk+JoSS3FGoqEWc1FxIgAYBhPEVwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0K7024l008941

>  
> Dear Myungjoo,
>
>On 01/20/2015 01:34 PM, MyungJoo Ham wrote:
>>>   
[]
>>> +
>>> +	mutex_lock(&edev->lock);
>>> +	if (edev->desc->ops && edev->desc->ops->enable) {
>>> +		ret = edev->desc->ops->enable(edev);
>>> +		if (ret < 0)
>>> +			goto err;
>>> +	}
>> 
>> Is there any reason to call enable(edev) even when enable_count is already > 0 
>> while you do not call disable(edev) while enable_count > 0?
>> 
>> I think this may incur errors in the related device drivers.
>> (e.g., incorrect pairing of clk/runtime-pm/regulator enable/disable
>> at the device driver side)
>
>You're right. This part has potential errors. I'll fix it as following:
>If edev is already enabled, devfreq_event_enable_edev() will just return
>without any operation because devfreq-event(edev) can handle only one event
>at the same time.
> 
>	mutex_lock(&edev->lock);
>	if (edev->enable_count)
>		dev_warn(&edev->dev, "%s is already enabled\n", edev->desc->name);
>		ret = -EINVAL;
>		goto err;
>	}
>
>	if (edev->desc->ops && edev->desc->ops->enable) {		
>		ret = edev->desc->ops->enable(edev);
>		if (ret < 0)
>			goto err;
>	}
>	edev->enable_count++;

No, your suggested modification creates another bug.

It should not emit "warn" when enable_count > 0 at enable().
It is a natural behavior from drivers.
- You may have multiple drivers using edev.
- You may have multiple threads using edev.

Thus, the above 12 lines should be replaced with:

	if (edev->desc->ops && edev->desc->ops->enable &&
	    edev->enable_count == 0) {
		ret = edev->desc->ops->enable(edev);
		if (ret < 0)
			goto err;
	}
	edev->enable_count++;

>	
>
>> 
>>> +	edev->enable_count++;
>>> +err:
>>> +	mutex_unlock(&edev->lock);
>>> +
>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(devfreq_event_enable_edev);
>>> +
>>> +/**
>>> + * devfreq_event_disable_edev() - Disable the devfreq-event dev and decrease
>>> + *				  the enable_count of the devfreq-event dev.
>>> + * @edev	: the devfreq-event device
>>> + *
>>> + * Note that this function decrease the enable_count and disable the
>>> + * devfreq-event device. After the devfreq-event device is disabled,
>>> + * devfreq device can't use the devfreq-event device for get/set/reset
>>> + * operations.
>>> + */
>>> +int devfreq_event_disable_edev(struct devfreq_event_dev *edev)
>>> +{
>>> +	int ret = 0;
>>> +
>>> +	if (!edev || !edev->desc)
>>> +		return -EINVAL;
>>> +
>>> +	mutex_lock(&edev->lock);
>>> +	if (edev->enable_count > 0) {
>>> +		edev->enable_count--;
>>> +	} else {
>>> +		dev_warn(&edev->dev, "unbalanced enable_count\n");
>>> +		ret = -EINVAL;
>>> +		goto err;
>>> +	}
>>> +
>>> +	if (edev->desc->ops && edev->desc->ops->disable) {
>>> +		ret = edev->desc->ops->disable(edev);
>>> +		if (ret < 0) {
>>> +			edev->enable_count++;
>>> +			goto err;
>>> +		}

Anyway, have you seen other subsystems doing fall-back operations as you've
done by "edev->enable_count++" here? Or is this your own idea on falling back
from errors with a disable callback?

>>> +	}
>> 
>> You did it correctly with disable here;
>> not calling it when it is not required.

Uh..yeah.. the original patch was incorrect..

>
>As I explained, I'll fix it as following:
>
>	mutex_lock(&edev->lock);
>	if (!edev->enable_count) {
>		dev_warn(&edev->dev, "%s is already disabled\n", edev->desc->name);
>		ret = -EINVAL;
>		goto err;
>	}
>
>	if (edev->desc->ops && edev->desc->ops->disable) {
>		ret = edev->desc->ops->disable(edev);
>		if (ret < 0)
>			goto err;		
>	}
>	edev->enable_count--;

Uh.... I'd say it is still incorrect.

	mutex_lock(&edev->lock);
	if (!edev->enable_count) {
		dev_warn(&edev->dev, "%s is already disabled\n", edev->desc->name);
		ret = -EINVAL;
		goto err;
	}

	edev->enable_count--;
	if (edev->desc->ops && edev->desc->ops->disable &&
	    !edev->enable_count) {
		ret = edev->desc->ops->disable(edev);
		if (ret < 0)
			goto err;		
	}


>
>> 
>>> +err:
>>> +	mutex_unlock(&edev->lock);
>>> +
>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(devfreq_event_disable_edev);
>>> +
>> 
>> []
>>> +EXPORT_SYMBOL_GPL(devfreq_event_is_enabled);
>> []
>> 
>>> +EXPORT_SYMBOL_GPL(devfreq_event_set_event);
>> []
>> 
[]
>>> +int devfreq_event_reset_event(struct devfreq_event_dev *edev)
>>> +{
>>> +	int ret = 0;
>>> +
>>> +	if (!edev || !edev->desc)
>>> +		return -EINVAL;
>>> +
>>> +	if (!devfreq_event_is_enabled(edev))
>>> +		return -EPERM;
>>> +
>>> +	mutex_lock(&edev->lock);
>>> +	if (edev->desc->ops && edev->desc->ops->reset)
>>> +		ret = edev->desc->ops->reset(edev);
>>> +	mutex_unlock(&edev->lock);
>> 
>> In the context of the get_event() handling "load",
>> aren't you supposed to set total_event = event = 0; here?
>
>But, devfreq_event_reset_event() function cannot handle edata instance
>because edata is not included in edev. The edata instance is only used in devfreq_event_get_event().

Ah.. ok then.

>
[]

Cheers,
MyungJoo
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
