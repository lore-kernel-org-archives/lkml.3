Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3FXIcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:32:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34673 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3FXIcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:32:11 -0400
X-AuditID: cbfee68e-b7f276d000002279-f2-51c8040918c3
Message-id: <51C80409.1040806@samsung.com>
Date: Mon, 24 Jun 2013 17:32:09 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com>
 <CAKohpo=0m8+WegUmMR2BOKeY2mJZw=X5-nEAp26M5L3PH9Bz2A@mail.gmail.com>
 <51C3D01F.7040907@samsung.com> <5527616.jZ71Fx7IV6@vostro.rjw.lan>
In-reply-to: <5527616.jZ71Fx7IV6@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWyRsSkUJeT5USgwb9LVhZnm96wW1zeNYfN
	4nbjCjaL/oW9TBYbv3o4sHrcubaHzaNvyypGj0eLWxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mq4
	+OISa8Eu/opfq6exNTBe5+li5OSQEDCRePLnBhuELSZx4d56IJuLQ0hgKaNE87cZTDBFT69d
	ZYVITGeUOHj4GQuE84JRYsWl58wgVbwCWhIX3zWCjWIRUJVYtLgJLM4GFN//AmKFqECYxMrp
	V1gg6gUlfky+B2aLANVvefKfHWQos8ACRom5l1cDNXNwCAtkSEx4WwWx7CKjxPVTj1hBGjgF
	DCS+XVvKCGIzC6hLTJq3iBnClpfYvOYtM0iDhMAudolDW7cyQlwkIPFt8iEWkKESArISmw4w
	Q7wmKXFwxQ2WCYxis5DcNAvJ2FlIxi5gZF7FKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERhb
	p/8969vBePOA9SHGZKCVE5mlRJPzgbGZVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQbGFSYndpnaXlO1O+21bvorW7fo1omG4fr7ZjnWfH5fnGPs
	HzTzq1b2DwUvzWPO2g0VPr7Jbo1JfipS4isCo8MNa5OEq9V75hmvk/+UsHK3WIhCeoCFHyfD
	36a/9Y0mm587Sl76VXvt+65pc2OWJvyzKikTS35g0SonoMiwZaJqWdxGf/7GCUosxRmJhlrM
	RcWJAN6+QnvDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoC4ny4lAg/sbjCzONr1ht7i8aw6b
	xe3GFWwW/Qt7mSw2fvVwYPW4c20Pm0ffllWMHo8WtzB6fN4kF8AS1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0V0mhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOYcfHFJdaCXfwVv1ZPY2tgvM7TxcjJISFgIvH02lVWCFtM
	4sK99WxdjFwcQgLTGSUOHn7GAuG8YJRYcek5M0gVr4CWxMV3jWwgNouAqsSixU1gcTag+P4X
	N8DiogJhEiunX2GBqBeU+DH5HpgtAlS/5cl/dpChzAILGCXmXl4N1MzBISyQITHhbRXEsouM
	EtdPPQI7iVPAQOLbtaWMIDazgLrEpHmLmCFseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpa
	kFxQnJSea6RXnJhbXJqXrpecn7uJERy5z6R3MK5qsDjEKMDBqMTDu8D8eKAQa2JZcWXuIUYJ
	DmYlEd5DV4BCvCmJlVWpRfnxRaU5qcWHGJOBQTCRWUo0OR+YVPJK4g2NTcyMLI3MDS2MjM1J
	E1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgbFdYOGMvT6X3iUW6LL3ufP5fZq26qbQnhyJ
	jXYn/FxSPT1nN3bIuDnMjd20ePeB5teuwvNFPMvTH6t2sU03CIx45//w2rppHwKd0y/vbU30
	f/Tv0P8avefJm+9Y5l7Yyr0+1sBoWzn3qZqHmROYrWzOaSz0Pl6z5FWpVpTpp/s8sU7z7x+f
	0aXEUpyRaKjFXFScCADnKiKVIAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 10:13 PM, Rafael J. Wysocki wrote:
> On Friday, June 21, 2013 01:01:35 PM Chanwoo Choi wrote:
>> On 06/21/2013 12:42 AM, Viresh Kumar wrote:
>>> On 20 June 2013 16:48, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>> But,
>>>> To show old frequency/new frequency on load_table debugfs file,
>>>> governor function(dbs_check_cpu()) pass calculated CPUs load to specific governor(e.g., ondemand)
>>>> as below function flow.
>>>>
>>>> dbs_check_cpu() (in cpufreq.c)
>>>> -> od_check_cpu() (in cpufreq_ondemand.c)
>>>> -> __cpufreq_driver_target() (in cpufreq.c)
>>>> -> cpufreq_driver->target(policy)
>>>>
>>>> Also, The __cpufreq_driver_target() is external function which can be called on other file
>>>> so I must consider exception case.
>>>>
>>>> If send CPUFREQ_LOADCHECK noti after changed cpu frequency,
>>>> I think it is complicated and has quite a little difficulty.
>>>>
>>>> What is your opinion?
>>>
>>> What you can do is:
>>> - create another routine: cpufreq_governor_driver_target()
>>> - replace all __cpufreq_driver_target() from ondemand/conservative governors
>>> with this one
>>> - In cpufreq_governor_driver_target() call __cpufreq_driver_target() and
>>> take a note of new freq.
>>>
>>> Maybe you don't need to check the actual freq that is set (even
>>> that would be simple to implement), but what is requested.
>>>
>>
>> OK, I understand and will try to implement it.
>> Thanks.
>>
>> @Rafael?
>> If possible, I want to know the your opinion about this.
> 
> Well, to be honest, I don't like the whole thing.  The more changes you need
> to make to the common code to support it, the worse.
> 

To minimize the modification of cpufreq core, I implemented load_table debugfs file
by only using CPUFREQ_LOADCHECK and CPUFREQ_POSTCHANGE noti. So, I don't add additional
function for load_table debugfs file. I will send next version patch for load_table soon.

Best Regards,
Chanwoo Choi

