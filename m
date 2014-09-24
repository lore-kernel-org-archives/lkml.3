Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbaIXDEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 23:04:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30561 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaIXDEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 23:04:44 -0400
X-AuditID: cbfee691-f79b86d000004a5a-4d-542234c4bcd2
From: Kukjin Kim <kgene@kernel.org>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Mike Turquette'" <mturquette@linaro.org>
References: <20140924110836.209bc8e2@canb.auug.org.au>
In-reply-to: <20140924110836.209bc8e2@canb.auug.org.au>
Subject: RE: linux-next: build failure after merge of the samsung tree
Date: Wed, 24 Sep 2014 12:04:36 +0900
Message-id: <00fb01cfd7a4$45eb4a50$d1c1def0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHv9Y7pls0ew4DeOAaPdZa0uXmLbJvPXEaQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI90jJkohBhMua1lsnLGe1eLo7wKL
	y7vmsFkcXNjGaPF0wkU2i617r7I7sHk03rjB5vH3+XUWjzvX9rB59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8b3Bx1sBee4Kt7OfsbWwLico4uRk0NCwETi9OpJjBC2mMSFe+vZuhi5OIQE
	ljFKbHjxnQmm6PPR58wQiUWMEp+mTQPrEBL4yyjxtK+0i5GDg01AWaKxSR8kLCygJbFwSxML
	iC0ioCvR928+E0gvs8AjRol9a5pZQeqFBMwkuldWg9RwCphL7JxyiAWi103i8f91LCAlLAKq
	EhPWSoKEeQUsJDYuesMCYQtK/Jh8D8xmBlq1eVsTK4QtL7F5zVtmiJMVJHacfc0IcYKRxM7X
	D6BqRCT2vXjHCHKOhMBbdonrq3rAilgEBCS+TT4EtldCQFZi0wGoOZISB1fcYJnAKDkLyepZ
	SFbPQrJ6FpIVCxhZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKExPHEHYz3D1gfYhTgYFTi
	4Z0grhQixJpYVlyZe4jRFOiiicxSosn5wGSRVxJvaGxmZGFqYmpsZG5ppiTOqyP9M1hIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY+DXPVe+1BjNCgxeIu7DF2IVw3Qx46S/3ZaspTqXPq36
	yVr/nePJaX/bDbP21yzg+y2SHDAlw7xzSvYv29Dg9fJNm1ieZibInz3WajsvOYqhOe+0Educ
	Dbe1uMp6IhPZnu+8k6ylV9783/fM75AGrqf6VSYndY/tOPDwc0ZK2EGt2W/lslMfKrEUZyQa
	ajEXFScCADnV0/neAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd0jJkohBj/vqVlsnLGe1eLo7wKL
	y7vmsFkcXNjGaPF0wkU2i617r7I7sHk03rjB5vH3+XUWjzvX9rB59G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM7w862ArOcVW8nf2MrYFxOUcXIyeH
	hICJxOejz5khbDGJC/fWs3UxcnEICSxilPg0bRojSEJI4C+jxNO+0i5GDg42AWWJxiZ9kLCw
	gJbEwi1NLCC2iICuRN+/+UwgvcwCjxgl9q1pZgWpFxIwk+heWQ1SwylgLrFzyiEWiF43icf/
	17GAlLAIqEpMWCsJEuYVsJDYuOgNC4QtKPFj8j0wmxlo1eZtTawQtrzE5jVvoU5WkNhx9jUj
	xAlGEjtfP4CqEZHY9+Id4wRG4VlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iRGcJJ5J72Bc1WBxiFGAg1GJh3eCuFKIEGtiWXFl7iFGCQ5mJRHefapAId6UxMqq
	1KL8+KLSnNTiQ4ymQI9OZJYSTc4HJrC8knhDYxMzI0sjMwsjE3NzJXHeg63WgUIC6Yklqdmp
	qQWpRTB9TBycUg2M2pvM+LoFbsvVhaxa8P8iA0PZ8geS3Svfxvw7weAX9HXu3Oq7u2XN8y7+
	jWkuuPNA9qD/dYWdb6wXXFhRLiLPVKzto5JWtvAWX7f/VO0a4QINR8464cg31UypH491/PBZ
	crC1L/ZpNfvr05PSOIM2NG+bcEDo8tfWB2I9h3j1dkbdF/YP8a5XYinOSDTUYi4qTgQA0hZE
	jSgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kukjin,
> 
Hi Stephen,

> After merging the samsung tree, today's linux-next build (arm multi_v7_defconfig)
> failed like this:
> 
> arch/arm/boot/dts/exynos5250-snow.dts:13:46: fatal error: dt-bindings/clock/maxim,max77686.h: No such
> file or directory
>  #include <dt-bindings/clock/maxim,max77686.h>
>                                               ^
> 
+ Mike

Hmm... I think, inclusion of the header file should be included in Mike's clk
tree...What's wrong?

> Caused by commit c04c92ed5614 ("ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow").
> 
> In file included from arch/arm/mach-tegra/cpuidle-tegra114.c:17:0:
> arch/arm/mach-tegra/cpuidle-tegra114.c: In function 'tegra114_idle_power_down':
> arch/arm/include/asm/firmware.h:64:24: error: too few arguments to function 'firmware_ops->do_idle'
>   ((firmware_ops->op) ? firmware_ops->op(__VA_ARGS__) : (-ENOSYS))
>                         ^
> arch/arm/mach-tegra/cpuidle-tegra114.c:52:6: note: in expansion of macro 'call_firmware_op'
>   if (call_firmware_op(do_idle) == -ENOSYS)
>       ^
> 
> Caused by commit f5217f3b9332 ("ARM: EXYNOS: add AFTR mode support to
> firmware do_idle method").

OK, I'll revert it firstly. Thanks.

> 
> I have used the samsung tree from next-20140923 for today.

OK.

- Kukjin

