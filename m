Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaCRJwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:52:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14913 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaCRJwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:52:39 -0400
X-AuditID: cbfee68e-b7f566d000002344-8e-53281765be66
Message-id: <53281765.3080602@samsung.com>
Date: Tue, 18 Mar 2014 18:52:37 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v3 2/4] mfd: max8997: handle IRQs using regmap
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-3-git-send-email-r.baldyga@samsung.com>
 <53218C30.9000707@samsung.com> <5322BEDF.4080408@samsung.com>
In-reply-to: <5322BEDF.4080408@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsWyRsSkSDdVXCPY4PgcS4slF6+yW0x9+ITN
	4ujOiUwWk568Z7Y4vOgFo8XElZOZLV6/MLS4//Uoo8W3Kx1MFjc/fWO1uLxrDpvF1jfrGC3W
	HrnLbnG7cQWbxbW9x5ktHhzeyW6xe9dTVov9nR2MFqe7WR2EPXbOusvusWfiSTaPzSu0PDat
	6mTzuHNtD5vHvJOBHnvm/2D16NuyitFj+ryfTB6fN8l5rN+ylSmAO4rLJiU1J7MstUjfLoEr
	o2VRbsF7noqZC8wbGPdwdTFyckgImEgc2TmDHcIWk7hwbz0biC0ksJRR4vI5f5iatZ2tzF2M
	XEDx6YwS8xa9ZoNwXjFKLGn9C9bBK6AlcXvtcVYQm0VAVWLV3iVgcTag+P4XN8BsUYEwiZXT
	r7BA1AtK/Jh8D8wWAaq583E+2BXMAkeZJd43yIHYwgJOEg/f9TBBLNvLKLH9QyNYEaeAtsSF
	udOhGnQk9rdOY4Ow5SU2r3kLdqqEwAkOiYmn3rBDXCQg8W3yIaBtHEAJWYlNB5ghXpOUOLji
	BssERrFZSG6ahWTsLCRjFzAyr2IUTS1ILihOSi8y0itOzC0uzUvXS87P3cQITBCn/z3r28F4
	84D1IcZkoJUTmaVEk/OBCSavJN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTBmZnS/U3N1cBPz1jmXVDznW/2UrWnr3ysY990UU77Clv0r6ZXn3bsT
	glf9uR3gstb3Zv2DP75mbRaRxxWO3ttz9XEhq7NfvFLBIe7Lr2IKmGyyqjuaM1+rTLJ/n2Hh
	/nr/Jr0fVVPU9BleqLx6mGcoYf+0+cmtKM/qD9Weusd7Pn/r3DlrX4oSS3FGoqEWc1FxIgBu
	CdzeJgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsVy+t9jQd1UcY1gg6sf9C2WXLzKbjH14RM2
	i6M7JzJZTHryntni8KIXjBYTV05mtnj9wtDi/tejjBbfrnQwWdz89I3V4vKuOWwWW9+sY7RY
	e+Quu8XtxhVsFtf2Hme2eHB4J7vF7l1PWS32d3YwWpzuZnUQ9tg56y67x56JJ9k8Nq/Q8ti0
	qpPN4861PWwe804GeuyZ/4PVo2/LKkaP6fN+Mnl83iTnsX7LVqYA7qgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoO+UFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBkti3IL3vNUzFxg3sC4h6uLkZNDQsBEYm1nKzOELSZx
	4d56ti5GLg4hgemMEvMWvYZyXjFKLGn9ywZSxSugJXF77XFWEJtFQFVi1d4lYHE2oPj+FzfA
	bFGBMImV06+wQNQLSvyYfA/MFgGqufNxPjuIzSxwlFnifYMciC0s4CTx8F0PE8SyvYwS2z80
	ghVxCmhLXJg7HapBR2J/6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEJ6Bn0jsYVzVYHGIU4GBU4uF9waYeLMSaWFZcmXuIUYKDWUmE94SI
	RrAQb0piZVVqUX58UWlOavEhxmRgEExklhJNzgcmx7ySeENjEzMjSyNzQwsjY3PShJXEeQ+2
	WgcKCaQnlqRmp6YWpBbBbGHi4JRqYFyVqmQm5KH3bLV/199lX3bfvM7/5sHXywv/nb96x/fV
	hb97jEssOY5NVr+ctTOocJ/qBefQf8/neVrHilpw97zv/+zG0/npf8ll1ujGcwtuxF06uWlm
	7lH3pcUPF77XuvInRKq949djP63ipnrB14lT47fHNv27o3jpMbP93a1d99Kkj266eldeiaU4
	I9FQi7moOBEA3136zYQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 05:33 PM, Robert Baldyga wrote:
> On 03/13/2014 11:45 AM, Chanwoo Choi wrote:
>> Hi Robert,
>>
>> On 03/13/2014 06:38 PM, Robert Baldyga wrote:
>>> This patch modifies mfd driver to use regmap for handling interrupts.
>>> It allows to simplify irq handling process. This modifications needed
>>> to make small changes in function drivers, which use interrupts.
>>>
>>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> 
> (...)
> 
>>> @@ -468,8 +560,11 @@ static int max8997_suspend(struct device *dev)
>>>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
>>>  	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
>>>  
>>> -	if (device_may_wakeup(dev))
>>> -		irq_set_irq_wake(max8997->irq, 1);
>>> +	if (device_may_wakeup(dev)) {
>>> +		enable_irq_wake(max8997->irq);
>>> +		disable_irq(max8997->irq);
>>
>> irq_set_irq_wake() is same as enable_irq_wake().
> 
> It's more intuitive name and makes code reading easier.
> 
>> Why is it necessary for disable_irq(max8997->irq)?
> 
> It's because we don't want to get interrupts before i2c controller will
> be ready. So we disable irq in drivers suspend, and enable in resume.
> 
> If some iqr will come before enable_irq() call, it will be noticed, and
> IRQ_PENDING flag will be set. In this case irq will be handled
> immediately after enable_irq() call.
> 
> In previous version there was call of max8997_irq_resume() in resume
> function, which caused forced interrupt handling, which has similar effect.
> 

OK,

For extcon part,
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

