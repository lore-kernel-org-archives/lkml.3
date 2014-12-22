Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaLVB5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:57:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:37587 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaLVB5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:57:19 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-f79296d000004278-45-54977a7d312d
Content-transfer-encoding: 8BIT
Message-id: <54977A7D.2060301@samsung.com>
Date: Mon, 22 Dec 2014 10:57:17 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH V3 11/11] power: charger-manager: Support to change polling
 rate in runtime.
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
 <1418979323-7188-12-git-send-email-jonghwa3.lee@samsung.com>
 <20141220002908.GD1694@amd>
In-reply-to: <20141220002908.GD1694@amd>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkULe2anqIwdvZihYHt2paXP/ynNVi
	0pP3zBYTV05mtri8aw6bxefeI4wWtxtXsFncPXWUzeL07hIHTo8J/Z8YPXbOusvusXmFlsem
	VZ1sHn1bVjF6rFj9nd3j8ya5APYoLpuU1JzMstQifbsEroxJG2oKXvNUXLjVydrA+Iqzi5GT
	Q0LARGLtkcvMELaYxIV769lAbCGBpYwSp65Ew9Qs71gKFOcCik9nlPj2tR2siFdAUOLH5Hss
	XYwcHMwC8hJHLmWDhJkF1CUmzVvEDFH/mlFi+b73TBD1WhJHFp0A62URUJVoPvOfBcRmE5CT
	eNv0jRHEFhUIk7g64ThYXARo5ta+FWCDmAX2MEpM2NLCDpIQFkiSmHXvDCPEhiWMElum/QDr
	4BTQkJi66RcLSEJC4CW7RO/ys4wQ6wQkvk0+BHaqhICsxKYDUC9LShxccYNlAqPYLCQPzUJ4
	aBaShxYwMq9iFE0tSC4oTkovMtQrTswtLs1L10vOz93ECIzL0/+e9e5gvH3A+hCjAAejEg8v
	R9r0ECHWxLLiytxDjKZAR0xklhJNzgdGf15JvKGxmZGFqYmpsZG5pZmSOK+i1M9gIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYz95QkCyVferdYv+XzowhaplZJcbmEVqnKGf9VXuzs89lSz
	f5Gec/Ulm9vn6Ke/OZfMiVyya/nmiqANSw6+jPfRtY9uWf547sp5Tok9kdcDUq3mKZ67cq/k
	2lGTZVY+e9nqGApsXsmJfHncyaJ+qErm9LkZTSyFN1dWCZTqrr0/6VuhzaIf37uUWIozEg21
	mIuKEwE3KAJKxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t9jQd3aqukhBjN7JC0ObtW0uP7lOavF
	pCfvmS0mrpzMbHF51xw2i8+9RxgtbjeuYLO4e+oom8Xp3SUOnB4T+j8xeuycdZfdY/MKLY9N
	qzrZPPq2rGL0WLH6O7vH501yAexRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzJm2oKXjNU3HhVidrA+Mrzi5GTg4JAROJ5R1L2SBsMYkL99YD2VwcQgLTGSW+fW0HS/AK
	CEr8mHyPpYuRg4NZQF7iyKVskDCzgLrEpHmLmCHqXzNKLN/3ngmiXkviyKITYL0sAqoSzWf+
	s4DYbAJyEm+bvjGC2KICYRJXJxwHi4sAzdzatwJsELPAHkaJCVta2EESwgJJErPunWGE2LCE
	UWLLtB9gHZwCGhJTN/1imcAoMAvJgbMQDpyF5MAFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS
	83M3MYLj/pn0DsZVDRaHGAU4GJV4eDnTpocIsSaWFVfmHmKU4GBWEuG95w8U4k1JrKxKLcqP
	LyrNSS0+xGgK9N5EZinR5HxgSsoriTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJzU5NLUgt
	gulj4uCUamCc1fX7n+aW1x805XfMVLvqbPlE1uBeZO+erMO7vv3Yc60/7s/pvD9ZF/MkMwvz
	nVprf9YLtZzfv55bNuWYof2DaX4qCd4vTTuLhb/NOfqIpUW8KOnAjcJT2/fvNY8z2msZ3JFf
	uUquU7tDqjUw8KvLi00P1AUYbrF4aF3hNjEJnrshyWmr2nclluKMREMt5qLiRADAdwIFEQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 12월 20일 09:29, Pavel Machek wrote:

> 
>> Add 'polling_ms' sysfs node to change charger-manager's monitoring rate
>> in runtime. It can set only bigger than 2 jiffies (for 200 HZ system it
>> is 10 msecs.) as it's allowed for minimum poling rate in previous.
> 
> New sysfs filesneed documentation.
> 
>> It resets poller and re-configure polling rate based on new input if next
> 
> re-configures...", if"
> 
>> polling time is far enough. Otherwise, it just waits expiration of timer
> 
> "waits for"
> 
>> and new polling rate will affects the next scheduling.
> 
> "affect"?
> 


Sorry for so many typos.. including above typos I'll revise all of them.

> 
>> +static ssize_t show_polling_ms(struct device *dev,
>> +				struct device_attribute *attr, char *buf)
>> +{
>> +	struct charger_manager *cm;
>> +	ssize_t len;
>> +
>> +	list_for_each_entry(cm, &cm_list, entry)
>> +		if (cm->charger_psy.dev == dev)
>> +			break;
>> +
>> +	if (cm->charger_psy.dev != dev)
>> +		return -EINVAL;
> 
> Any chance to reorganize data structures so that this kind of list
> walking is not neccessary?
> 


No need to reorganize, I'll fix it to get target data without unnecessary
iteration.

>> +static ssize_t store_polling_ms(struct device *dev,
>> +				struct device_attribute *attr, const char *buf,
>> +				size_t count)
>> +{
>> +	struct charger_manager *cm;
>> +	int polling_ms;
>> +	int ret;
>> +
>> +	ret = sscanf(buf, "%d", &polling_ms);
> 
> "kstrtoul"?
> 


Yes, it would be better. I'll modify it either.

Thanks for reviewing.
Jonghwa

> 									Pavel


