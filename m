Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaBGRll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:41:41 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42154 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaBGRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:41:38 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-28-52f51ad0d003
Message-id: <52F51ACE.9060003@samsung.com>
Date: Fri, 07 Feb 2014 21:41:34 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com>
 <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de>
 <52F1DDA8.90605@samsung.com>
 <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
 <52F2B504.5010403@linaro.org>
 <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de>
 <52F3C8A5.708@samsung.com>
 <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de>
In-reply-to: <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xa7oXpL4GGUxdLmgxZ/0aNouDWzUt
	rn95zmpx5reuxdmmN+wWl3fNYbPYvGkqswO7x4T+T4wed67tYfN4d+4cu8eJGb9ZPPq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugSvj0pmN7AWnWSt+brrB0sC4lqWLkYNDQsBE4sh2nS5GTiBT
	TOLCvfVsXYxcHEICSxklbm9YwwqSEBL4zCix4lggiM0roCXRuvE8G4jNIqAqcXT5W1aQOWwC
	BhL77tmCmKICEUBhTYhqQYkfk++xgNgiAhoSGy/dYgYZzyywklFi7rc/7CAJYQFXiRPb17NC
	7H3ELHGofz3YfE4BL4mOQ+uYQWxmAWuJlZO2MULY8hKb17xlnsAoMAvJkllIymYhKVvAyLyK
	UTS1NLmgOCk910ivODG3uDQvXS85P3cTIyTQv+5gXHrM6hCjAAejEg+v4orPQUKsiWXFlbmH
	GCU4mJVEeFsEvgYJ8aYkVlalFuXHF5XmpBYfYmTi4JRqYGTsWrlr7X+7Q09m1tS82Vek2X5+
	98fZ71cIVS6/nfbha77NqvceCWYRh7zEylc/DN+/VMH/6508xbBNE34YP5jKPqGHU5Ld/MYF
	2csC4SZ/LX00uS4wWTIdNn2r/ULK+kDCGltr5mf2i1RfNn9rZtVl/yRh8HjHzQKJZ3Yb3ljO
	dYoJ3H9W454SS3FGoqEWc1FxIgC/kBE6UgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 12:50 AM, Thomas Gleixner wrote:
> On Thu, 6 Feb 2014, Alexey Perevalov wrote:
>> On 02/06/2014 02:16 AM, Thomas Gleixner wrote:
>> As I truly understand, you decided - flags is better than new clockids, and
>> internals of timerfd could be a mix of timer_list and hrtimer.
> NO, NO, NO, NO. There is no mix of timer_list and hrtimer. Either we
> add proper deferrable support to hrtimers or the whole thing is not
> going to happen at all. There is no way that we bring back timer_list
> to user space interfaces. Period.
>
> Thanks,
>
> 	tglx
>
>
>
Ok, thank you, I'll work with you patch for hrtimers, and I'll rework 
current patch set.


-- 
Best regards,
Alexey Perevalov
