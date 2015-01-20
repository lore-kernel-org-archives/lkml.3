Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbbATHZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:25:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52233 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbATHZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:25:42 -0500
X-AuditID: cbfee691-f79b86d000004a5a-67-54be02f43a13
Message-id: <54BE02F3.4060808@samsung.com>
Date: Tue, 20 Jan 2015 16:25:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
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
Subject: Re: [PATCHv8 1/9] devfreq: event: Add new devfreq_event class to
 provide basic data for devfreq governor
References: <213049974.1319841421737167629.JavaMail.weblogic@epmlwas04a>
In-reply-to: <213049974.1319841421737167629.JavaMail.weblogic@epmlwas04a>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkWPcL074Qgym9HBaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJusWrXH0YHfo8189YweuycdZfdY/Gel0wem1Z1snlsXlLv0bdlFaPH501yAexR
	XDYpqTmZZalF+nYJXBn/OpcyF6zSqph67Dl7A+MsxS5GTg4JAROJh0cmskDYYhIX7q1nA7GF
	BJYySnyZ7w9T03TlOXMXIxdQfDqjRNPd3VDOa0aJ3pObGUGqeAW0JLYvf8sOYrMIqEq87X7M
	BGKzAcX3v7gBNlVUIExi5fQrLBD1ghI/Jt8Ds0UEZCSubtzOAjKUWaCXTeLd+kXMIAlhgWKJ
	ExubGSFO8pBYPbUVLM4p4CnReuAGWDOzgLrEpHkQ9cwC8hKb17wFu05CYCqHxMLfLawQFwlI
	fJt8CKiBAyghK7HpADPEa5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UWmesWJ
	ucWleel6yfm5mxiBkX3637OJOxjvH7A+xCjAwajEw/ti1d4QIdbEsuLK3EOMpkBXTGSWEk3O
	B6aPvJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGJlM
	/njeuvSh3PvEFh/RhEie9fa1BraLDQIvR+x7JTensVjh8hu7qIzqZYKHz/TX6ag/820UZH5p
	9/L8nf5NIr9O6xZVPHn7bvmlojkb1e5amseZe2a4rTB+9kuBbxHbLZ0lZ09cS6tdslNn7r+I
	cg8NL/vVi3epvLvmevGR4MPXJ6r/Hjh2bIISS3FGoqEWc1FxIgAcgENr5wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd3PTPtCDFov2lg8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bFrVyeaxeUm9R9+WVYwenzfJBbBH
	NTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDdraRQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+Ne5lLlglVbF1GPP2RsYZyl2
	MXJySAiYSDRdec4MYYtJXLi3nq2LkYtDSGA6o0TT3d3MEM5rRonek5sZQap4BbQkti9/yw5i
	swioSrztfswEYrMBxfe/uMEGYosKhEmsnH6FBaJeUOLH5HtgtoiAjMTVjdtZQIYyC/SySbxb
	vwhstbBAscSJjc1gC4QEPCRWT20Fi3MKeEq0HrgB1swsoC4xaR5EPbOAvMTmNW+ZJzAKzEKy
	YxaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4cz6R2MK5ssDjEKMDBqMTD
	67B2b4gQa2JZcWXuIUYJDmYlEd4JT4FCvCmJlVWpRfnxRaU5qcWHGE2BQTCRWUo0OR+Y1PJK
	4g2NTcyMLI3MDS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODilGhhLXqmneAfMi7++aes/
	nSrm4L/FQS83Bd45cKlW7pTdi2BzBrZTVSxqXwPm3zOz4d3+UGmelv0Fjei5r8KFTlhXNPz8
	VF2j1XFrUmX3viVCc16W7jpjqrRU7teFFx+1YtbLK1aFVW7X8SmofXTzy7YfjCm8Ow4Kffn6
	Pk1eu9p3fvbi5edmnGBRYinOSDTUYi4qTgQA2WgEZzIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

On 01/20/2015 03:59 PM, MyungJoo Ham wrote:
>>  
>> Dear Myungjoo,
>>
>> On 01/20/2015 01:34 PM, MyungJoo Ham wrote:
>>>>   
> []
>>>> +
>>>> +	mutex_lock(&edev->lock);
>>>> +	if (edev->desc->ops && edev->desc->ops->enable) {
>>>> +		ret = edev->desc->ops->enable(edev);
>>>> +		if (ret < 0)
>>>> +			goto err;
>>>> +	}
>>>
>>> Is there any reason to call enable(edev) even when enable_count is already > 0 
>>> while you do not call disable(edev) while enable_count > 0?
>>>
>>> I think this may incur errors in the related device drivers.
>>> (e.g., incorrect pairing of clk/runtime-pm/regulator enable/disable
>>> at the device driver side)
>>
>> You're right. This part has potential errors. I'll fix it as following:
>> If edev is already enabled, devfreq_event_enable_edev() will just return
>> without any operation because devfreq-event(edev) can handle only one event
>> at the same time.
>>
>> 	mutex_lock(&edev->lock);
>> 	if (edev->enable_count)
>> 		dev_warn(&edev->dev, "%s is already enabled\n", edev->desc->name);
>> 		ret = -EINVAL;
>> 		goto err;
>> 	}
>>
>> 	if (edev->desc->ops && edev->desc->ops->enable) {		
>> 		ret = edev->desc->ops->enable(edev);
>> 		if (ret < 0)
>> 			goto err;
>> 	}
>> 	edev->enable_count++;
> 
> No, your suggested modification creates another bug.
> 
> It should not emit "warn" when enable_count > 0 at enable().
> It is a natural behavior from drivers.
> - You may have multiple drivers using edev.
> - You may have multiple threads using edev.

The devfreq-event cannot be used in multiple drivers in current version
If multiple driver set the event to devfreq-event device by using
devfreq_event_set_event() at the same time, previous event will be ignored.

If multiple drivers want to use devfreq-event device at the same time,
I have to implement additional feature.

> 
> Thus, the above 12 lines should be replaced with:
> 
> 	if (edev->desc->ops && edev->desc->ops->enable &&
> 	    edev->enable_count == 0) {
> 		ret = edev->desc->ops->enable(edev);
> 		if (ret < 0)
> 			goto err;
> 	}
> 	edev->enable_count++;
> 
>> 	
>>
>>>
>>>> +	edev->enable_count++;
>>>> +err:
>>>> +	mutex_unlock(&edev->lock);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(devfreq_event_enable_edev);
>>>> +
>>>> +/**
>>>> + * devfreq_event_disable_edev() - Disable the devfreq-event dev and decrease
>>>> + *				  the enable_count of the devfreq-event dev.
>>>> + * @edev	: the devfreq-event device
>>>> + *
>>>> + * Note that this function decrease the enable_count and disable the
>>>> + * devfreq-event device. After the devfreq-event device is disabled,
>>>> + * devfreq device can't use the devfreq-event device for get/set/reset
>>>> + * operations.
>>>> + */
>>>> +int devfreq_event_disable_edev(struct devfreq_event_dev *edev)
>>>> +{
>>>> +	int ret = 0;
>>>> +
>>>> +	if (!edev || !edev->desc)
>>>> +		return -EINVAL;
>>>> +
>>>> +	mutex_lock(&edev->lock);
>>>> +	if (edev->enable_count > 0) {
>>>> +		edev->enable_count--;
>>>> +	} else {
>>>> +		dev_warn(&edev->dev, "unbalanced enable_count\n");
>>>> +		ret = -EINVAL;
>>>> +		goto err;
>>>> +	}
>>>> +
>>>> +	if (edev->desc->ops && edev->desc->ops->disable) {
>>>> +		ret = edev->desc->ops->disable(edev);
>>>> +		if (ret < 0) {
>>>> +			edev->enable_count++;
>>>> +			goto err;
>>>> +		}
> 
> Anyway, have you seen other subsystems doing fall-back operations as you've
> done by "edev->enable_count++" here? Or is this your own idea on falling back
> from errors with a disable callback?

I removed "edev->enable_count++" when fail to diable devfreq-event
and modify it as following:

	+int devfreq_event_disable_edev(struct devfreq_event_dev *edev)
	+{
	+	int ret = 0;
	+
	+	if (!edev || !edev->desc)
	+		return -EINVAL;
	+
	+	mutex_lock(&edev->lock);
	+	if (!edev->enable_count) {
	+		dev_warn(&edev->dev,
	+			"%s is already disabled\n", edev->desc->name);
	+		goto err;
	+	}
	+	
	+	if (edev->desc->ops && edev->desc->ops->disable) {
	+		ret = edev->desc->ops->disable(edev);
	+		if (ret < 0)
	+			goto err;
	+	}
	+	edev->enable_count--;
	+err:
	+	mutex_unlock(&edev->lock);
	+
	+	return ret;
	+}
	+EXPORT_SYMBOL_GPL(devfreq_event_disable_edev);

> 
>>>> +	}
>>>
>>> You did it correctly with disable here;
>>> not calling it when it is not required.
> 
> Uh..yeah.. the original patch was incorrect..
> 
>>
>> As I explained, I'll fix it as following:
>>
>> 	mutex_lock(&edev->lock);
>> 	if (!edev->enable_count) {
>> 		dev_warn(&edev->dev, "%s is already disabled\n", edev->desc->name);
>> 		ret = -EINVAL;
>> 		goto err;
>> 	}
>>
>> 	if (edev->desc->ops && edev->desc->ops->disable) {
>> 		ret = edev->desc->ops->disable(edev);
>> 		if (ret < 0)
>> 			goto err;		
>> 	}
>> 	edev->enable_count--;
> 
> Uh.... I'd say it is still incorrect.

I explained it about this problem on the upper.

> 
> 	mutex_lock(&edev->lock);
> 	if (!edev->enable_count) {
> 		dev_warn(&edev->dev, "%s is already disabled\n", edev->desc->name);
> 		ret = -EINVAL;
> 		goto err;
> 	}
> 
> 	edev->enable_count--;
> 	if (edev->desc->ops && edev->desc->ops->disable &&
> 	    !edev->enable_count) {
> 		ret = edev->desc->ops->disable(edev);
> 		if (ret < 0)
> 			goto err;		
> 	}

[snip]

Best Regards,
Chanwoo Choi

