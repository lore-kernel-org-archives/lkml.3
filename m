Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaBUHE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:04:56 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39563 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaBUHEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:04:55 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-f1-5306fa94f1f9
Message-id: <5306FA92.2030103@samsung.com>
Date: Fri, 21 Feb 2014 11:04:50 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, anton@nomsg.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, akpm@linux-foundation.org
Subject: Re: [PATCH v3 4/6] timerfd: Factor out timer-type unspecific
 timerfd_expire()
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
 <1392885633-7787-5-git-send-email-a.perevalov@samsung.com>
 <alpine.DEB.2.02.1402201136500.4468@ionos.tec.linutronix.de>
 <20140221041325.GA19817@teo>
In-reply-to: <20140221041325.GA19817@teo>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xq7pTfrEFG9xoN7aYs34Nm8XBrZoW
	/b86WS2uf3nOanHmt67F2aY37BaXd81hs9i8aSqzA4fHhP5PjB53ru1h83h37hy7x4kZv1k8
	vuzZy+zRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGS/W/WYsOMhbsX7eNbYGxm9cXYycHBIC
	JhIzt/SzQthiEhfurWfrYuTiEBJYyijx71QDK4TzmVFi4udr7CBVvAJaEldmrwOzWQRUJa69
	2cHYxcjBwSZgILHvni2IKSoQIXF0uSZEtaDEj8n3WEBsEQE1idOXX4KNZBY4wCgxZ+c+RpCE
	MFD9s63fmSF2PWSUuLr2MFiCU0BT4sj3bWwgNrOAmcSjlnXMELa8xOY1b5knMArMQrJkFpKy
	WUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIiYAvOxgXH7M6xCjAwajEw1sgwRYs
	xJpYVlyZe4hRgoNZSYQ38iFQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2NIv4idkC/T/smFwV8u
	rUm0PD978UzeefJbJy0rNJ+993zA7YNHljjPta/QCLHMabu7QVmgRXFTj1gnk2Yn7z+JfD29
	bkd185Bz73os3x5UL9sosnl9+nrLx3WrTB39p8lN3iASq824YKKu6+bSG2/k7h2ofjsjvahG
	5e+Nv51Ho3menljYkajEUpyRaKjFXFScCACnlDdWXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 08:13 AM, Anton Vorontsov wrote:
> On Thu, Feb 20, 2014 at 11:52:03AM +0100, Thomas Gleixner wrote:
>>> From: Anton Vorontsov <anton@enomsg.org>
>>>
>>> There is nothing hrtimer-specific inside the timerfd_tmrproc(), except
>>> the function prototype. We're about to add other timer types, so factor
>>> out generic timerfd_expire() helper from timerfd_tmrproc().
>> This changelog is completely useless. How is timerfd_tmrproc, which is
>> not a function but a function pointer, related to the patch?
>>
>> Moving duplicated code to a common function is nice, but ....
>>> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
>>> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ...
>> Warnings are there to be ignored and testing of user space
>> interfaces after a change is overrated, right?
>>
>> Aside of that you just blindly copied the original code w/o fixing up
>> the now unnecessary line breaks.
> Alexey,
>
> While I appreciate the desire to be careful with authorship and stuff,
> please remove my name as an author of this patch -- the current code has
> nothing to do with my original work, and I surely don't want to take any
> responsibility for it. This is a common practice if you modify someone's
> patch to a great extend.
>
> Thomas is bashing the thing, which has my name on it; although _my_ patch
> did not produce any warnings, came with a completely different changelog,
> and served completely different purposes.
Sorry, it was introduced by me, while rebasing.

>
> Instead of rushing with resending yet another series, please actually read
> Thomas' review.
>
> Thanks,
>
> Anton
>



-- 
Best regards,
Alexey Perevalov
