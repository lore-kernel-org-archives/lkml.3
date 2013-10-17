Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab3JQOCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:02:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23302 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3JQOCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:02:20 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-62-525fede94d8e
Message-id: <525FEDDD.8000301@samsung.com>
Date: Thu, 17 Oct 2013 18:02:05 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Aliaksei Katovich <aliaksei.katovich@gmail.com>,
        Kevin Hilman <khilman@linaro.org>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 0/4] Exynos 5410 Dual cluster support
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
 <87k3hc3lso.fsf@linaro.org> <20131017130435.GG3061@cat.local>
In-reply-to: <20131017130435.GG3061@cat.local>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t/xy7ov38YHGdzYqGvxunkWq8WkdQeY
	LOZ9lrWYf+Qcq8X/R69ZLc69Wslo0bvgKpvF18MrGC02Pb7GarGwbQmLxeVdc9gsZpzfx2Rx
	+zKvxdLrF5ksnk64yGYxYfpaFovDK4AGrXs5ncViy88ORotXB9tYLDZvmspsMXXGD3YHMY81
	89YwerQ097B5LPh8hd3j76oXzB47Z91l91i5/Aubx6vVM1k97lzbw+bx7tw5do/NS+o9Xl1j
	8ejbsorRY/u1ecwenzfJeWycGxrAH8Vlk5Kak1mWWqRvl8CVcWfRZbaCZcoVR3d2MTUwHpft
	YuTkkBAwkbg3bTIThC0mceHeerYuRi4OIYGljBIrVmxjhXA+ADnvu9lBqngFtCRO9LwFs1kE
	VCXe7T7G3MXIwcEmoC2xZYcXSFhUIEziaNNPVohyQYkfk++xgNgiAhESL++vYweZySzwkVWi
	u2k5G0hCWMBG4s7ZJqhlzYwSp/6/BFvAKaAnceTwKrBJzAJmEo9a1jFD2PISm9e8ZZ7AKDAL
	yZJZSMpmISlbwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMksr/uYFx6zOoQowAHoxIP
	74zlcUFCrIllxZW5hxglOJiVRHhd7scHCfGmJFZWpRblxxeV5qQWH2Jk4uCUamAs9yvuPfm4
	feaXk4x7co5t0l/C9r2Z/RDftMaXKjtMs1ZxeRlIf31elBUqzrFp80QfA9nXdXm1CvFd60VZ
	ik48qt/Gn2jyjWnNWX0Xx876Q1Xf+A8zRHov2LWvLILlx6S/H+Yuc49SZyua5qZ86MHJdXYz
	7dxmHkv+/6euqlI3ds2u47w/zucqsRRnJBpqMRcVJwIAFyPJEcoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.10.2013 17:04, Aliaksei Katovich wrote:
> hi Kevin;
>
>> Vyacheslav Tyrtov <v.tyrtov@samsung.com> writes:
>>
>>> The series of patches represent support of Exynos 5410 SoC
>>>      
>>> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture.
>>> Patches allow all 8 CPU cores (4 x A7 and 4 x A15) to run at the same time
>>>      
>>> Patches add new platform description, support of clock controller,
>>> dual cluster support and device tree for Exynos 5410
>>>     
>>> Has been build on v3.12-rc5.
>>> Has been tested on Exynos 5410 reference board (exynos_defconfig).
>> Has anyone tried this on the exynos5410 based odroid-xu yet?
>>
>> I tried booting this on my recently arrived odroid-xu, but am not
>> getting it to boot.
> 	I am able to boot my odroid-xu+e to busybox with these patches applied
> 	against 3.12-rc5: exynos_defconfig and exynos5410-smdk5410.dtb were
> 	used.
>
> 	However there seem to be some issues with virq allocations, like this:
>
> <snippet>
> Starting kernel ...
>                     
> [    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
> [    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
> [    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
> [    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
> [    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
> [    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
> )
> [    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
> [    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
> [    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
> [    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
> [    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
> [    0.000000] ---[ end trace 1b75b31a2719edcd ]---
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
> [    0.000000] error: virq337 is not allocated
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
> [    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
> [    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
> [    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
> [    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
> [    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
> [    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
> )
> [    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
> [    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
> [    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
> [    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
> [    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
> [    0.000000] ---[ end trace 1b75b31a2719edce ]---
> [    0.000000] ------------[ cut here ]------------
> </snippet>
>
> 	You can check full boot log here http://sprunge.us/NKcU
>
> --
> Aliaksei
>
>> I'm not yet terribly familiar with this SoC, what are the settings
>> needed for DEBUG_LL on this board?
>>
>> Thanks,
>>
>> Kevin
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
Also change NR_CPUS to 8 in kernel config, so you will get 8 cores 
booted instead of 2.

Best regards,
     Tarek Dakhran
