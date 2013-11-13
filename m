Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3KMCLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:11:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19607 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab3KMCKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:10:53 -0500
X-AuditID: cbfee68f-b7f836d000001b39-10-5282dfabc1e1
Message-id: <5282DFAC.2000003@samsung.com>
Date: Wed, 13 Nov 2013 11:10:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] extcon: arizona: Eliminate dead error handling code
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1383916783-17921-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <52817321.9040505@samsung.com>
 <20131112143031.GF6549@opensource.wolfsonmicro.com>
In-reply-to: <20131112143031.GF6549@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkQHf1/aYgg/Z9Fhb/ptxgt7j/9Sij
	xeVdc9gsbjeuYLNY/vY/m8XpblYHNo871/awecw7GejxcuJvNo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DK6J/3i7Hgo2DF+Z+b2BoYT/N1MXJySAiYSNw+uIIFwhaTuHBvPVsXIxeHkMBS
	RommnZNYYYo2Nu+HSixilPg6cRIzhPOKUWLlqbtMXYwcHLwCWhL/T2mCNLAIqEp8OTWXDcRm
	Awrvf3EDzBYVCJNYOf0K2DZeAUGJH5PvgdkiAhYSU5bcApvJLNDHKPGoZSbYZmEBH4l9D/6x
	QCz7xijx9vh5sEmcAg4Sj69+YQaxmQV0JPa3TmODsOUlNq95CzZJQuAYu8SKsw9ZIE4SkPg2
	+RALyKUSArISmw4wQ7wmKXFwxQ2WCYxis5AcNQvJ2FlIxi5gZF7FKJpakFxQnJReZKxXnJhb
	XJqXrpecn7uJERhtp/8969/BePeA9SHGZKCVE5mlRJPzgdGaVxJvaGxmZGFqYmpsZG5pRpqw
	kjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYmxz73kX4MJdZa2xaXLZPJVa9YpuK
	d5HHCqVclp/6DGEuN+ZEnvEy/p5YzfhAbTrDC+XFbycaiGiUKqQdeM8cNNdnhcwNK6ugjbtq
	r9csMpr4N3cp279a7eWc81l/2zs8Uzd+v3FzhU06Q92i6CanN5qqjM++8L24znFk7b3ZGtP1
	TKT+qIUosRRnJBpqMRcVJwIAyABQO8wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd3V95uCDGYfMLT4N+UGu8X9r0cZ
	LS7vmsNmcbtxBZvF8rf/2SxOd7M6sHncubaHzWPeyUCPlxN/s3n0bVnF6PF5k1wAa1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoz+eb8YCz4KVpz/uYmtgfE0XxcjJ4eE
	gInExub9bBC2mMSFe+uBbC4OIYFFjBJfJ05ihnBeMUqsPHWXqYuRg4NXQEvi/ylNkAYWAVWJ
	L6fmgjWzAYX3v7gBZosKhEmsnH6FBcTmFRCU+DH5HpgtImAhMWXJLbCZzAJ9jBKPWmaygiSE
	BXwk9j34xwKx7BujxNvj58EmcQo4SDy++oUZxGYW0JHY3zqNDcKWl9i85i3zBEaBWUiWzEJS
	NgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwbH8THoH46oGi0OMAhyMSjy8FjFN
	QUKsiWXFlbmHGCU4mJVEeL2vAYV4UxIrq1KL8uOLSnNSiw8xJgPDYCKzlGhyPjDN5JXEGxqb
	mBlZGpkbWhgZm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo2mj5gHeXta73Ws5Nffp
	f3ln+y0rac6K0B3ZhbIfTk8rZmGYwGzk5c3/pNF++/pCH5Mvk4pfb684uklqwxGBNSKLF5SV
	v6q1UlkalyH8xZldUm41q5TmLyPtiYYvFCbf2rtTc8Z8nqz0uvAnnFw1e6RFcqfXHrpvHMr+
	2CR8Sk/HkkPHguqYlViKMxINtZiLihMB4qvDOykDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 11:30 PM, Charles Keepax wrote:
> On Tue, Nov 12, 2013 at 09:15:29AM +0900, Chanwoo Choi wrote:
>> Hi CHarles,
>>
>> On 11/08/2013 10:19 PM, Charles Keepax wrote:
>>> As a small disclaimer I would personally prefer to not merge this patch.
>>> I have added it based on previous code review of the other patches in
>>> this chain.
>>>
>>> arizona_hpdet_do_id currently can only return 0 or -EAGAIN making the
>>> else if clause handling error codes redundant, this patch removes this
>>> clause.
>>>
>>> Whilst this clause is not currently hit removing it makes the code
>>> fragile. It will not be obvious whilst editing arizona_hpdet_do_id that
>>> you shouldn't add a return value other than 0 or -EAGAIN.
>>>
>>> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
>>> ---
>>>  drivers/extcon/extcon-arizona.c |    5 +++--
>>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
>>> index 0d70bf6..2313b1e 100644
>>> --- a/drivers/extcon/extcon-arizona.c
>>> +++ b/drivers/extcon/extcon-arizona.c
>>> @@ -476,6 +476,9 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
>>>  	return val;
>>>  }
>>>  
>>> +/* This function should only return 0 or -EAGAIN, if other return values are
>>> + * added additional handling should be added in arizona_hpdet_irq.
>>> + */
>>
>> As Lee Jones commented, you should modify this comment of arizona_hpdet_do_id() and add
>> the description of return value. Because arizoa_hpdet_do_id() has different meaning
>> between -EAGAIN and other minus value.
> 
> I take it you are still very keen on applying a patch for this
> dead code elimination? I really do feel it would be better to
> leave this part of the code as it currently is, the extra safety
> clearly outweights the cost of a redundant else if.

In that case, I think that you could modify arizona_hpdet_read() to add exception handling
for minus return value instead of elimination.

I knew about your opinion. But I think it isn't proper method remaining dead code on mainline tree.
People who don't know the history about this dead code would think that "Is this code necessary?".

Thanks,
Chanwoo Choi


