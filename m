Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3KYJKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:10:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30650 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3KYJKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:10:42 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-1a-529314106448
Date: Mon, 25 Nov 2013 09:10:40 +0000 (GMT)
From: Anurag Aggarwal <a.anurag@samsung.com>
Subject: Re: Re: [PATCH] ARM: unwinder: Handle Stackoverflow in unwind_exec_insn
To: Dave Martin <Dave.Martin@arm.com>,
        Anurag Aggarwal <anurag19aggarwal@gmail.com>
Cc: Naveen Kumar <naveen.sel@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Narendra Meher <narendra.m1@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Anurag Aggarwal <a.anurag@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpgs ." <cpgs@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        Rajat Suri <rajat.suri@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mohammad Irfan Ansari <mohammad.a2@samsung.com>
Reply-to: a.anurag@samsung.com
MIME-version: 1.0
X-MTR: 20131125090851983@a.anurag
Msgkey: 20131125090851983@a.anurag
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131125090851983@a.anurag
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: Y
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <31564068.33481385370637554.JavaMail.weblogic@epv6ml06>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSqCsgMjnIYNIrU4vLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXxZN0JloIW2YonL5QbGBfIdDFycggJKEv07l3PBmJLCJhInG29
	zARhi0lcuAcS5wKqWcoo8eHWBriihtMnWCAS8xklnp6/D9bBIqAqsfHfYnYQm01AV2LijSvM
	ILawQIDE31ntYLaIQKTEv8Z2RpBmZoFuVoktk1awQ5whJ3F33XawIl4BQYmTM5+wQGxTlLgy
	+xcrRFxJ4uD2f6wQcTmJJVNhTuWVmNH+lAUmPu3rGmYIW1ri/KwNjDDvLP7+GCrOL3Hs9g6g
	Xg6w3if3g2HG7N78BepJAYmpZw5CtapJ7P34Fcrmk1iz8C0LzJhdp5Yzw/Q2bPwN9goz0MlT
	uh9C2QYSRxbNYUX3Fq+As8TUCd3MExiVZyFJzULSPgtJO7KaBYwsqxhFUwuSC4qT0ouM9IoT
	c4tL89L1kvNzNzECE8Ppf8/6djDePGB9iDEZGCcTmaVEk/OBiSWvJN7Q2MzIwtTE1NjI3NKM
	NGElcd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAKfpmlu1GN2VB/Wye3nNl3qza/
	RyqL735uWxRc1fjk2pq9avzLkv8oB70OSH9UyX91Mj+7Q4p8ETvDzvveM6erzOVq3uOz55Dm
	07tG66Zc/VR+Vuu5E/Pt4tfWpcdt3OeckCmOqNmec6rH9kRttoj7GuEVMUJvU93rreb+fvta
	vuBelM33CyVKLMUZiYZazEXFiQC0bBohIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2dF0BkclBBmvf6Fpc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIwn
	606wFLTIVjx5odzAuECmi5GTQ0hAWaJ373o2EFtCwESi4fQJFghbTOLCPZA4F1DNfEaJp+fv
	M4EkWARUJTb+W8wOYrMJ6EpMvHGFGcQWFgiQ+DurHcwWEYiU+NfYzgjSzCzQzSqxZdIKdoht
	chJ3120HK+IVEJQ4OfMJ1DZFiSuzf7FCxJUkDm7/xwoRl5NYMvUyE4TNKzGj/SkLTHza1zXM
	ELa0xPlZGxhhrl78/TFUnF/i2O0dQL0cYL1P7gfDjNm9+QvUwwISU88chGpVk9j78SuUzSex
	ZuFbFpgxu04tZ4bpbdj4G+wVZqCTp3Q/hLINJI4smsOK7i1eAWeJqRO6mScwys1CkpqFpH0W
	knZkNQsYWVYxiqYWJBcUJ6VXGOsVJ+YWl+al6yXn525iBKenZ4t3MP4/b32IUYCDUYmH16Jy
	UpAQa2JZcWXuIUYJDmYlEd49dUAh3pTEyqrUovz4otKc1OJDjMnAGJzILCWanA9MnXkl8YbG
	xiZmJqaWJhYGpuakCSuJ88bfSgoSEkhPLEnNTk0tSC2C2cLEwSnVwGjDVa7sOf1HhGT2pM/R
	qmK164pu/hLj3tq+8G/qE6mt9xS+aAq0/OVzXF0b9eHO2acTP5mG+zoVz4pYs2Tf4R+FvGtD
	NO/dvX10jsH5Seed/R5++7mQEyi53usL/0trP1G9BdfPP//KYPiy57uIjdCrh1wvU8UTHmdr
	uoT0BCX/t1PnK3gYrsRSnJFoqMVcVJwIACHAgKyTAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAP9AuGA001240

Hi Dave,

I think that we don't need to avoid stack overflow completely but we need to avoid data being derefrenced that is not part of stack.

I agree with you that there is no rule in ABI to guarantee that stack overflow will only occur when backtracking last set of register.

>From my understanding of code the only chances of getting a data abort is while executing these four instructions:
1) 1000iiii iiiiiiii : Pop up to 12 integer registers under masks {r15-r12}, {r11-r4}
2) 10100nnn : Pop r4-r[4+nnn]
3) 10101nnn : Pop r4-r[4+nnn], r14
4) 10110001 0000iiii : Pop integer registers under mask {r3, r2, r1, r0}

I think it would be better to execute these instruction in their own seperate functions, which would be called from unwind_exec_insn, and in those function depending on the depth of stack remaining we can decide whether it is possible to execute the instruction or not.

The above method will add some extra code but will avoid additional checks that are not required every where.

and solve our purpose also as we need to avoid data abort due to stack overflow not stack overflow completely.

Regards
Anurag Aggarwal

------- Original Message -------
Sender : Dave Martin<Dave.Martin@arm.com>
Date : Nov 23, 2013 01:07 (GMT+05:30)
Title : Re: [PATCH] ARM: unwinder: Handle Stackoverflow in unwind_exec_insn

On Sat, Nov 09, 2013 at 12:28:57PM +0530, Anurag Aggarwal wrote:
> Thanks for your input Dave,
> 
> I think there is another way to avoid the stack overflow and reduce
> the number of checks also,
> 
> Stack overflow will cause a problem only when we are backtracking the
> last set of registers.
> i.e when the difference between current SP and top of stack is less
> than or equal to number of registers

Apologies, it looks like I failed to respond to this earlier...


Although that will usually be correct, there is no rule in the ABI to
guarantee it.

> we can create two unwind_exec_insn, one without checks and one with checks.
> 
> then we call the correct function from unwind_frame depending on the
> difference of SP and top of stack.
> 
> This will reduce the amount of checks every time we read a set of
> registers from stack

That sounds like it might duplicate a lot of code, to optimise based on
assumptions that may not always be true, for what really should not be a
hot path in the kernel.

If you can find a tidy way of doing it, it would be certainly worth
reviewing, but I still think it would be simpler just to do a simple
bounds check for every word read from the stack -- it should be
impossible for that to go wrong, even if some of the bounds checks
are not stictly required.

Cheers
---DaveˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
