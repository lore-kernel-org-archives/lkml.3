Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaJOFcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:32:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50425 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaJOFcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:32:41 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-f791c6d000004834-68-543e06f6ec55
Content-transfer-encoding: 8BIT
Message-id: <543E06F6.7020606@samsung.com>
Date: Wed, 15 Oct 2014 14:32:38 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/exynos: fix vblank handling during dpms off
References: <542B9A0E.7020206@samsung.com>
 <1412151287-12845-1-git-send-email-a.hajda@samsung.com>
 <542D13CC.5000304@samsung.com> <542D2E7C.1020904@samsung.com>
 <5437D39A.60603@samsung.com>
In-reply-to: <5437D39A.60603@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkRPc7m12IweWDrBa31p1jteg9d5LJ
	4srX92wWL+5dZLHoXXCVzeJs0xt2i8u75rBZzDi/j8lixuSXbA6cHtu/PWD1uN99nMmjb8sq
	Ro/Pm+QCWKK4bFJSczLLUov07RK4Mp6+3MRecF2gYt/h90wNjLt4uxg5OCQETCQmHXTuYuQE
	MsUkLtxbz9bFyMUhJLCUUeLry3tsEAkTiYbVrxghEtMZJVYcvskKkuAVEJT4MfkeC8ggZgF5
	iSOXskHCzALqEpPmLWKGqH/FKNHR95AFol5L4mfrWbBeFgFVic6GNiYQmw3InrjiPtgyUYEw
	iRevdjGD2CJAg2afvMMMMXQdk8Sl38IgtrCAi8TVCZ+ZIBYcZpRovLoTrJlTQFNi3so97BBX
	X2OXWPVZBmKZgMS3yYdYID6Wldh0gBmiRFLi4IobLBMYxWYheWcWwjuzkLyzgJF5FaNoakFy
	QXFSepGxXnFibnFpXrpecn7uJkZg9J3+96x/B+PdA9aHGAU4GJV4eDkO2IYIsSaWFVfmHmI0
	BTpiIrOUaHI+MMbzSuINjc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1ILYovKs1JLT7E
	yMTBKdXA6LgtJf5G6E3jFeomJ3bkSOimm0qsyax/9W2eJgdz3SHuR5aB60s2BqzWeOi4OWhJ
	0ul5N38nxxtvPzTDabXdLVv7qSWX18XfOrvZ9kTV6v+77d+XWvy1qDA18VRP2HP2v96hKaxd
	whMfhZntK+X5cvivScmP2FyOtwwcjDxqJumvnhzU28/ipcRSnJFoqMVcVJwIAA7SCSa5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jQd1vbHYhBi+WW1ncWneO1aL33Ekm
	iytf37NZvLh3kcWid8FVNouzTW/YLS7vmsNmMeP8PiaLGZNfsjlwemz/9oDV4373cSaPvi2r
	GD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx9OUm9oLrAhX7
	Dr9namDcxdvFyMkhIWAi0bD6FSOELSZx4d56ti5GLg4hgemMEisO32QFSfAKCEr8mHyPpYuR
	g4NZQF7iyKVskDCzgLrEpHmLmCHqXzFKdPQ9ZIGo15L42XoWrJdFQFWis6GNCcRmA7InrrjP
	BmKLCoRJvHi1ixnEFgEaNPvkHWaIoeuYJC79FgaxhQVcJK5O+MwEseAwo0Tj1Z1gzZwCmhLz
	Vu5hn8AoMAvJfbMQ7puF5L4FjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj+5n0DsZV
	DRaHGAU4GJV4eDkO2IYIsSaWFVfmHmKU4GBWEuFNOwoU4k1JrKxKLcqPLyrNSS0+xGgK9N1E
	ZinR5Hxg6skriTc0NjEzsjQyN7QwMjZXEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cAomBHS
	98P8h8C1L2KKvxn/F6XO1wxZ1euoL2viKm/G+8lh9yvrc0Wy7yKXfgs5lckZHvRYaZ7Ml3uf
	1Hc/WuA69xn3q+cH9Lo3nvjvv3CX28UQlcIUxZAalcWCirVh5iov9cX2/oycvOTcgs6kCWJ3
	OUu5zIsb67Uri/irPZf/uPGdO1dW1kSJpTgj0VCLuag4EQDgRPwCBQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 10월 10일 21:39, Andrzej Hajda wrote:
> On 10/02/2014 12:52 PM, Inki Dae wrote:
>> On 2014년 10월 02일 17:58, Joonyoung Shim wrote:
>>> Hi Andrzej,
>>>
>>> On 10/01/2014 05:14 PM, Andrzej Hajda wrote:
>>>> The patch disables vblanks during dpms off only if pagefilp has
>>>> not been finished. It also replaces drm_vblank_off with drm_crtc_vblank_put.
>>>> It fixes issue with page_flip ioctl not being able to acquire vblank counter.
>>> This problem isn't related with pageflip, it just causes from
>>> 7ffd7a68511c710b84db3548a1997fd2625f580a commit (drm: Always reject
>>> drm_vblank_get() after drm_vblank_off()).
>>>
>>> We need to use drm_vblank_on() as a counterpart to drm_vblank_off()
>>> after the commit .
>>>
>>> How about below patch?
>> Thanks you Joonyoung and Andrzej,
>>
>> drm_vblank_on/off() are legacy api so it would be better to use
>> drm_vblank_crtc_on/off functions instead.
>>
>> And drm_vblank_crtc_off() makes sure that the latest vblank frame count
>> is stored and restored by drm_vblank_crtc_on() again. So my opinion is,
>>
>> static void exynos_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
>> {
>> 	[snip]
>>
>> 	if (mode > DRM_MODE_DPMS_ON) {
>> 		/* wait for the completion of page flip. */
>> 		if (!wait_event_timeout(exynos_crtc->pending_flip_queue,
>> 				!atomic_read(&exynos_crtc->pending_flip),
>> 				HZ/20))
>> 			atomic_set(&exynos_crtc->pending_flip, 0);
>> 		drm_crtc_vblank_off(crtc);		//<- store the latest vblank frame count.
>> 	} else {
>> 		drm_crtc_vblank_on(crtc);		//<- restore the vblank frame count.
>> 	}
>>
>> 	[snip]
>> }
>>
>>
>> Tested and worked well with above patch. How about it?
>>
>>
> 
> drm_crtc_vblank_on should be called after dpms on, otherwise it can fail enabling vblank. I have provided
> full explanation in my other email [1].
> You can modify your patch or just use the one provided in [1].

I will just merge your patch set after review and test. :)

Thanks,
Inki Dae

> 
> [1]: http://permalink.gmane.org/gmane.comp.video.dri.devel/116152
> 
> Regards
> Andrzej
> 
> 

