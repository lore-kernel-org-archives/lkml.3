Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaD3Ccg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:32:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33873 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaD3Cce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:32:34 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-6f-536060c005c0
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Mitchel Humpherys'" <mitchelh@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        kgene.kim@samsung.com, steve.capper@linaro.org,
        "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        ilho215.lee@samsung.com,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com
References: <000101cf6367$c4c219f0$4e464dd0$@samsung.com>
 <vnkwsioveuwk.fsf@mitchelh-linux.qualcomm.com>
In-reply-to: <vnkwsioveuwk.fsf@mitchelh-linux.qualcomm.com>
Subject: Re: [PATCH v4 1/7] arm64: Use pr_* instead of printk
Date: Wed, 30 Apr 2014 11:32:32 +0900
Message-id: <007c01cf641c$708af310$51a0d930$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQH53oiK3bvuFiXeAAxzk4NVI+GSxgGy6gNqmsbj9zA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zoe6BhIRgg8tvLC3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLt/G1sFivmLWOz
	+DBjJaMDr8eaeWsYPX7/msTocbmvl8njzrU9bB7nN61h9ti8pN6jb8sqRo/Pm+QCOKK4bFJS
	czLLUov07RK4Mrof/2UqmMxd0Tz7CWMDYw9nFyMnh4SAicTxjx9YIWwxiQv31rN1MXJxCAks
	Y5Q4vXMWI0xR47PlTBCJ6YwSa8+9YYZw/jBKbN13jgmkik1AU+LR3R52EFtEwFBi27vjjCBF
	zAILmSWWHPoBtkNIIEti5vlJYA2cAtYS36efAopzcAgL2Eq8n5kHEmYRUJU4t3Q2G4jNK2Ap
	seXXfUYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMkNcqiCx4+xrRoi4iMS+F+8YIe6xknj+
	fi07yD0SAls4JL42vWaDWCYg8W3yIRaQGyQEZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtn
	IVm3gJFlFaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZIYujbwXjzgPUhxmSg9ROZpUST84GJ
	Ja8k3tDYzMjC1MTU2Mjc0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MM6/
	/fVq5tqlzO2uZs/N+Nkv6R55WCP0d4u7VfXJTUU1+xXrg0w3a3t31ga32Jun6h5wFbOY/dX9
	U+AC3uPFR9yPlh7J+vL5j7B33JqPLKJSzA7fdS3jDeeknEncKHMnccbarx/V2Zes+ezRKXaU
	ddGuX2rlvTodd8sDpB5Mm/jwQ0H9Cf7/RkosxRmJhlrMRcWJAMYL5G0iAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jQd0DCQnBBseemlj8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8Xa+dvYLFbMW8Zm
	8WHGSkYHXo8189Ywevz+NYnR43JfL5PHnWt72DzOb1rD7LF5Sb1H35ZVjB6fN8kFcEQ1MNpk
	pCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2spFCWmFMK
	FApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zofvyXqWAyd0Xz7CeMDYw9nF2MnBwS
	AiYSjc+WM0HYYhIX7q1n62Lk4hASmM4osfbcG2YI5w+jxNZ958Cq2AQ0JR7d7WEHsUUEDCW2
	vTvOCFLELLCQWWLJoR+sIAkhgSyJmecngTVwClhLfJ9+CijOwSEsYCvxfmYeSJhFQFXi3NLZ
	bCA2r4ClxJZf9xkhbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxxqYLEjrOvGSHiIhL7Xrxj
	hLjHSuL5+7XsExiFZiEZNQvJqFlIRs1C0r6AkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnDaeSa1g3Flg8UhRgEORiUeXoGt8cFCrIllxZW5hxglOJiVRHiZAxKChXhTEiurUovy44tK
	c1KLDzEmA306kVlKNDkfmBLzSuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBa
	BLOFiYNTqoFx2epjlaZPX/OsEDZ8J/TWJVBIn2uh+OpHFjE7M7bLlc3Y6XwhnsvRYP8u9+4P
	C/kvnvz3/eLmWz6T+ur25m+/UWuXwzjF9zN3VFmMyw8ltfDfeR7beVgFGH+zi68KPx6wxN9e
	1mTBxevvRXbft4/r+R3FaxZqX2pQHt+0xWPl6uvXFY4yBz1XYinOSDTUYi4qTgQAesq9YH8D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2014 5:35 AM, Mitchel Humpherys wrote:
> On Mon, Apr 28 2014 at 09:59:14 PM, Jungseok Lee <jays.lee@samsung.com> wrote:
> > This patch fixed the following checkpatch complaint as using pr_*
> > instead of printk.
> >
> > WARNING: printk() should include KERN_ facility level
> >
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  arch/arm64/kernel/traps.c |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> > index 7ffaddd..0484e81 100644
> > --- a/arch/arm64/kernel/traps.c
> > +++ b/arch/arm64/kernel/traps.c
> > @@ -65,7 +65,7 @@ static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
> >  	fs = get_fs();
> >  	set_fs(KERNEL_DS);
> >
> > -	printk("%s%s(0x%016lx to 0x%016lx)\n", lvl, str, bottom, top);
> > +	pr_emerg("%s%s(0x%016lx to 0x%016lx)\n", lvl, str, bottom, top);
> 
> Currently this printk is being called with lvl=KERN_EMERG or lvl="". In the case of lvl=KERN_EMERG
> leaving lvl in is redundant. In the case of lvl="" this is a behavioral change (printing to a
> different log level). Was this intended?

No intention. I will drop the change in the next version.
Thanks!!

Best Regards
Jungseok Lee

