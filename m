Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbbALLRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:17:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62252 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbALLRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:17:23 -0500
X-AuditID: cbfee68d-f79296d000004278-2a-54b3ad40a455
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <54B3AD40.3040308@samsung.com>
Date: Mon, 12 Jan 2015 20:17:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: myungjoo.ham@samsung.com
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCHv7 02/10] devfreq: event: Add the list of supported
 devfreq-event type
References: <768125446.886831421046952335.JavaMail.weblogic@epmlwas09a>
In-reply-to: <768125446.886831421046952335.JavaMail.weblogic@epmlwas09a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkQNdh7eYQgxdTrC0er1nMZLFxxnpW
	i0n3J7BYvH5haNH/+DWzxdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyWHr9IpPF7cYVbBaP
	V7xlt2jde4TdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Nq3qZPPYvKTeo2/LKkaPz5vkAtij
	uGxSUnMyy1KL9O0SuDLeLz7HVvBSqeLb3K9MDYzLZbsYOTkkBEwk5p35xAJhi0lcuLeerYuR
	i0NIYCmjRM+ZGywwRZ87ljKD2EIC0xkllty1BrF5BQQlfky+B1bDLKAuMWneImYIW0Ti1Isd
	ULa2xLKFr5khhr5mlDg7aQMzRLOWxJ1J7awgNouAqsSaFVPBBrEBxfe/uMEGYosKhEmsnH4F
	LC4iICNxdeN2FpBBzAK9bBLv1kNsExaIlthys4O9i5EDaIO7xLqZ4SBhTgEPiUs/74LVSwjM
	5JA4ubiTGWKZgMS3yYdYQOolBGQlNh1ghnhSUuLgihssExjFZyH5bRaS32Yh+W0Wkt8WMLKs
	YhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAhMA6f/PevdwXj7gPUhRgEORiUeXgupzSFCrIll
	xZW5hxhNgS6ayCwlmpwPTDZ5JfGGxmZGFqYmpsZG5pZmSuK8ilI/g4UE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwxp4UNH6Vp29jMu2Vnfn2Vyy6M+dl8l9fYfP+Dse6pTf/1vdkqxklz+Vh
	19x5T+j6S1erWP6WW90X9q/+8cCw4dDKuJcnznx58+RnGQdbyYYD37c1zEtP/fHmjOz+m1s8
	JrQ0HoqLe69297xnEeO6vffeNulsDtuzs39jNOfSvTE1z4Sn6N5uFVBiKc5INNRiLipOBACi
	/q2J/gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQV2HtZtDDFauNbR4vGYxk8XGGetZ
	LSbdn8Bi8fqFoUX/49fMFmeb3rBbbHp8jdXi8q45bBafe48wWsw4v4/JYun1i0wWtxtXsFk8
	XvGW3aJ17xF2i1W7/jA68HusmbeG0WPnrLvsHov3vGTy2LSqk81j85J6j74tqxg9Pm+SC2CP
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYMW/RbPaC6fIVPQu+MDYwXpXs
	YuTkkBAwkfjcsZQZwhaTuHBvPRuILSQwnVFiyV1rEJtXQFDix+R7LF2MHBzMAvISRy5lg4SZ
	BdQlJs1bBNTKBVT+mlHi7KQNzBD1WhJ3JrWzgtgsAqoSa1ZMZQGx2YDi+1/cAJsvKhAmsXL6
	FbC4iICMxNWN21lABjEL9LJJvFu/CGyQsEC0xJabHewgi4UE3CXWzQwHCXMKeEhc+nmXZQKj
	wCwk581COG8WkvMWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOGM+kdzCuarA4xCjA
	wajEw2shtTlEiDWxrLgy9xCjBAezkgivaxlQiDclsbIqtSg/vqg0J7X4EKMp0HMTmaVEk/OB
	ySyvJN7Q2MTMyNLI3NDCyNhcSZxXyb4tREggPbEkNTs1tSC1CKaPiYNTqoFxXu/rkJoyy+Lm
	7zJNv7oEisX/x/VzuW8NfL5t56cDXwz9TTTnvLmYFxzMGPdhxQMWPgaBwpUKKrrhpznWiag5
	b9m7+ftGdsVjThunL1+2lZvjq8DODB7/P7UZQnNv73eKtbjDu+iZb88hRVuhaIY1Drn/Spl9
	vJjtTx6ap8DdpR4h+GmdxlMlluKMREMt5qLiRABQ4QwzLgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

On 01/12/2015 04:15 PM, MyungJoo Ham wrote:
>>   
>>  This patch adds the list of supported devfreq-event type as following.
>> Each devfreq-event device driver would support the various devfreq-event type
>> for devfreq governor at the same time.
>> - DEVFREQ_EVENT_TYPE_RAW_DATA
>> - DEVFREQ_EVENT_TYPE_UTILIZATION
>> - DEVFREQ_EVENT_TYPE_BANDWIDTH
>> - DEVFREQ_EVENT_TYPE_LATENCY
> 
> Did you try to say:
> 
> A devfreq-event device may support multiple devfreq-event types
> simultaneously.

I think that one devfreq-event device can support multiple devfreq-event types.
but, devfreq-event device might provide only value at one point.

But,
This patch is ambiguous and includes a bug according to your comment
(below switch statement). I'll drop this patch on next patch-set.

This patch will be posted on further patch-set after resolving some issue.

Best Regards,
Chanwoo Choi

> 
> If so, your switch expressions are going to screw up.
> 
> 
>>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/devfreq/devfreq-event.c | 58 ++++++++++++++++++++++++++++++++++++-----
>>  include/linux/devfreq-event.h   | 25 +++++++++++++++---
>>  2 files changed, 73 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
>> index 81448ba..64c1764 100644
>> --- a/drivers/devfreq/devfreq-event.c
>> +++ b/drivers/devfreq/devfreq-event.c
>>  
> []
>> -	mutex_lock(&edev->lock);
>> -	ret = edev->desc->ops->get_event(edev, edata);
>> -	mutex_unlock(&edev->lock);
>> +	switch (type) {
> 
> Bitwise value with switch? (what if type = RAW_DATA | BANDWIDTH, meaning
> this is raw data of the bandwitdh.)
> 
>> +	case DEVFREQ_EVENT_TYPE_RAW_DATA:
>> +	case DEVFREQ_EVENT_TYPE_BANDWIDTH:
>> +	case DEVFREQ_EVENT_TYPE_LATENCY:
>> +		if ((edata->event > EVENT_TYPE_RAW_DATA_MAX) ||
>> +			(edata->total_event > EVENT_TYPE_RAW_DATA_MAX)) {
> 
> Is it possible for unsigned long edata->event/total_event to be
>   > EVENT_TYPE_RAW_DATA_MAX = ULONG_MAX?
> 
> What was your intention?
> 
> If you were trying to detect overflow, you need to rethink about it.
> If not, (overflow is harmless or not going to happen) you don't need to
> check it.
> 
> 
>> +			edata->event = edata->total_event = 0;
>> +			ret = -EINVAL;
>> +		}
>> +		break;
>> +	case DEVFREQ_EVENT_TYPE_UTILIZATION:
>> +		edata->total_event = EVENT_TYPE_UTILIZATION_MAX;
>>  
>> -	if ((edata->total_event <= 0)
>> -		|| (edata->event > edata->total_event)) {
>> +		if (edata->event > EVENT_TYPE_UTILIZATION_MAX) {
>> +			edata->event = edata->total_event = 0;
>> +			ret = -EINVAL;
>> +		}
>> +		break;
>> +	default:
>>  		edata->event = edata->total_event = 0;
>>  		ret = -EINVAL;
>> +		break;
>>  	}
>>  
>> +	mutex_unlock(&edev->lock);
>> +
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(devfreq_event_get_event);
>> diff --git a/include/linux/devfreq-event.h b/include/linux/devfreq-event.h
>> index b7363f5..13a5703 100644
>> --- a/include/linux/devfreq-event.h
>> +++ b/include/linux/devfreq-event.h
>> @@ -36,6 +36,14 @@ struct devfreq_event_dev {
>>  	const struct devfreq_event_desc *desc;
>>  };
>>  
>> +/* The supported type by devfreq-event device */
>> +enum devfreq_event_type {
>> +	DEVFREQ_EVENT_TYPE_RAW_DATA	= BIT(0),
>> +	DEVFREQ_EVENT_TYPE_UTILIZATION	= BIT(1),
>> +	DEVFREQ_EVENT_TYPE_BANDWIDTH	= BIT(2),
>> +	DEVFREQ_EVENT_TYPE_LATENCY	= BIT(3),
>> +};
>> +
> 
> (Being curious) Is it possible to have multiple types
> simultaneously?
> 
> 
> []
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{�����x,�ȧ���ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢfl===
> 

