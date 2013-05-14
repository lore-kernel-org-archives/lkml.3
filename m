Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3ENFjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:39:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55336 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3ENFjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:39:32 -0400
X-AuditID: cbfee68f-b7f436d000000f81-b0-5191ce1285c3
Message-id: <5191CE12.9060006@samsung.com>
Date: Tue, 14 May 2013 14:39:30 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] sched: Add nr_running_cpu() to get current of running
 threads of each core
References: <1368433992-19162-1-git-send-email-cw00.choi@samsung.com>
 <20130513085935.GA3708@dyad.programming.kicks-ass.net>
In-reply-to: <20130513085935.GA3708@dyad.programming.kicks-ass.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkQFfo3MRAg++tChZnm96wW1zeNYfN
	4tKBBUwWtxtXsFkc7z3A5MDqsXmFlsf7fVfZPPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj
	xbat7AVz2CpOnjnD2sDYzNrFyMkhIWAi8WPVR2YIW0ziwr31bF2MXBxCAksZJeae/cTUxcgB
	VnR4GTdEfBGjxPEtp1kgnBeMEq+6GxhBunkFtCQe7m8Fm8oioCrxc/NOMJsNKL7/xQ02EFtU
	IExi5fQrLBD1ghI/Jt8Ds0UENCVWtt0Hq2EWyJS4v/wpWK+wQKLEzon/wWqEBOokLq39yg5i
	cwo4Sxw8voAVol5HYn/rNKheeYnNa94ygxwnIbCLXWLqh0mMEAcJSHybfIgF4htZiU0HoD6W
	lDi44gbLBEaxWUhOmoVk7CwkYxcwMq9iFE0tSC4oTkovMtYrTswtLs1L10vOz93ECIyr0/+e
	9e9gvHvA+hBjMtDKicxSosn5wLjMK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVANjcuqFvR9dNJyunS9f6ztFZ24vq0l0+w6Vg563V3rk+4XnX8lc
	UH9Rq/S0XlmPhY9A+519/q/zy/Y9VQ6XuvVW//7nTZvjzGOPzNrP53ubt8Cl471XzsOg9wsv
	Jv7l+fhFOcb8ZN9mr/9XxKb673172PbUmVLRrdcPtSf/0SxfYzvl8OEjzOe9lFiKMxINtZiL
	ihMB31PjXcECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgK7QuYmBBsfPSVicbXrDbnF51xw2
	i0sHFjBZ3G5cwWZxvPcAkwOrx+YVWh7v911l8+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwhrGjBfbtrIXzGGrOHnmDGsDYzNrFyMHh4SAicThZdxdjJxA
	ppjEhXvr2boYuTiEBBYxShzfcpoFwnnBKPGqu4ERpIpXQEvi4f5WVhCbRUBV4ufmnWA2G1B8
	/4sbbCC2qECYxMrpV1gg6gUlfky+B2aLCGhKrGy7D1bDLJApcX/5U7BeYYFEiZ0T/4PVCAnU
	SVxa+5UdxOYUcJY4eHwBK0S9jsT+1mlQvfISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyM4ap9J72Bc1WBxiFGAg1GJh/fFjwmBQqyJZcWVuYcYJTiY
	lUR418ycGCjEm5JYWZValB9fVJqTWnyIMRkYAhOZpUST84EJJa8k3tDYxMzI0sjc0MLI2Jw0
	YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGNvYHBIPp29/rbful1ilT2jO+fCipzzhE2+8
	ilS/dGPiqqryOZNuzLMt5zFJOra3m8P1otH79fcOC286wG1ptELhSnzk05LEL8cmnxc+nZG3
	fmNXnP7jrBPyi7/auvWuCmQVc7/3Y/lUBVWJJ99kEvK/nTqWGhoQ1avxmEnXyCee88Ozy58f
	L1FiKc5INNRiLipOBAC/Z3lcHgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 05:59 PM, Peter Zijlstra wrote:
> On Mon, May 13, 2013 at 05:33:12PM +0900, Chanwoo Choi wrote:
>> This patch add nr_running_cpu() function to get current
>> number of running threads of each core.
>>
> Uhm, not without a very good reason. 
>
I am implementing the cpu hotplug policy for reducing
power-consumption in user-space. The cpu hotplug policy
need specific information of each core to know correct
state of each core through specific kernel node like as /proc/sched_stats.
So, I sent only this patch but I didn't send other patchset
because other patch aren't designed according to the kernel
mainline style.

When I develop patchset, I will resend patchset which get
the information of each core for cpu hotplug in user-space.

Thanks,
Chanwoo Choi

