Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaIOAWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 20:22:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35967 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaIOAWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 20:22:01 -0400
X-AuditID: cbfee68e-f79536d000000fd1-94-541631237a95
From: Kukjin Kim <kgene@kernel.org>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>, swarren@nvidia.com,
        acourbot@nvidia.com, "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>, drake@endlessm.com,
        tomeu@tomeuvizoso.net
References: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
 <5415D4A8.4010304@gmail.com>
In-reply-to: <5415D4A8.4010304@gmail.com>
Subject: RE: [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
Date: Mon, 15 Sep 2014 09:21:55 +0900
Message-id: <0d2401cfd07b$0e21e190$2a65a4b0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHiYMn8aSKlHGmAcbPWW92Bil+thQKzjDqXm8aX5EA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zY11lQ7EQg/u/RSy+PzzFavF30jF2
	i0fzHzNbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77Banrn9ms7gxvYXVYtWuP4wWlxvNHHg8
	Wpp72Dx+/5rE6LHoe5bHzll32T02L6n3uHKiidWjt/kdm0ffllWMHkf/snl83iQXwBXFZZOS
	mpNZllqkb5fAlbHlbCNLwTbJilMfG5kbGI8LdzFycEgImEg87xXsYuQEMsUkLtxbz9bFyMUh
	JLCMUWLRhkUsEAkTic75Z5ghEtMZJf7cfc0OkhAS+MsocX1FFsggNgFlicYmfZCwsICWxMIt
	TWC9IgI+ErvnTQEbyixwikni5I3jTBC9iRJP1k0GszkFNCW2P93KDtHsLdH38SkTyEwWAVWJ
	hvXmICavgIVE82w7kApeAUGJH5PvgY1nBlq1fifERGYBeYnNa94yQ5ysILHj7GtGiBOsJC58
	eM0GUSMise/FO0aQcyQEdnBI7Dy2lxUkwSIgIPFt8iEWSJjISmw6ADVHUuLgihssExglZyFZ
	PQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJBU0beD8eYB60OMAhyM
	Sjy8Ky4KhwixJpYVV+YeYjQFumgis5Rocj4wIeWVxBsamxlZmJqYGhuZW5opifMmSP0MFhJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cAoVuC2R0y9KUf564Hg9dUb29be15mqMuWWAOMqq+TC
	rmPN/9bNuB/oyiWu4sFr1vflhoZn4GyJFee0fdUKZx14anHmzU3+jhPehzs5Fl9tMPv690fp
	5ZZbrhPMXjkFfUxiTz3/3fphu1/zgjSdOYfMBR8b2DmWTM83jF08O0VnevS+2pOFTLOUWIoz
	Eg21mIuKEwGjw36GEAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jQV1lQ7EQg7N3+S2+PzzFavF30jF2
	i0fzHzNbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77Banrn9ms7gxvYXVYtWuP4wWlxvNHHg8
	Wpp72Dx+/5rE6LHoe5bHzll32T02L6n3uHKiidWjt/kdm0ffllWMHkf/snl83iQXwBXVwGiT
	kZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S0kkJZYk4p
	UCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFjy9lGloJtkhWnPjYyNzAeF+5i5OSQ
	EDCR6Jx/hhnCFpO4cG89WxcjF4eQwHRGiT93X7ODJIQE/jJKXF+R1cXIwcEmoCzR2KQPEhYW
	0JJYuKWJBcQWEfCR2D1vClgvs8ApJomTN44zQfQmSjxZNxnM5hTQlNj+dCs7RLO3RN/Hp0wg
	M1kEVCUa1puDmLwCFhLNs+1AKngFBCV+TL4HNp4ZaNX6nRATmQXkJTaveQt1soLEjrOvGSFO
	sJK48OE1G0SNiMS+F+8YJzAKz0IyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8
	dL3k/NxNjOBU9Ex6B+OqBotDjAIcjEo8vAHnhUOEWBPLiitzDzFKcDArifCeuigaIsSbklhZ
	lVqUH19UmpNafIjRFOjPicxSosn5wDSZVxJvaGxiZmRpZGZhZGJuriTOe7DVOlBIID2xJDU7
	NbUgtQimj4mDU6qBMeyRdcnFSxVPtGZab2fnldG3UI2eHyx9rHOCtaKjT86/Q3sq/b4/yVB6
	rvSqb9miVZzznk7q+GLFKBk/QeThnkrWyc+TplXq1PyfLZUSInn3/pbMj/0mXy9V3f211co0
	6v/XnfkMc7ex+17W3GZy9vEdZZdvhw+csHn88a+mrGhh+M5Y9wUMD5VYijMSDbWYi4oTAUJV
	3g9bAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi Kukjin,
> 
Hi,

> On 26.08.2014 16:10, Tomasz Figa wrote:
> > On Exynos-based boards running secure firmware the sequence of low level
> > operations to enter and leave system-wide sleep mode is different than
> > on those without the firmware. Namely:
> >  - CP15 power control and diagnostic registers cannot be written directly,
> >  - the way of setting boot address and boot flag is different,
> >  - different resume handler needs to be used,
> >  - dedicated SMC call needs to be performed instead of letting the CPU enter
> >    WFI.
> >
> > This series introduces .suspend() and .resume() firmware operations to
> > perform low level firmware-specific suspend and resume and then leverages
> > them to provide suspend-resume path meeting the above requirements. Three
> > additional patches extend device tree sources of Trats2 board with necessary
> > setup to enable suspend/resume support.
> >
> > This series has been tested on Exynos4412-based Trats2 board, without any
> > additional patches. Unfortunately v3.17-rc1 regressed ODROID support and
> > suspend stopped working on those boards, due to unknown reasons still being
> > investigated. It does not seem to be related to anything in this series,
> > though, so I would not consider this as a stopper.
> >
> > Changes since v2:
> > (https://lkml.org/lkml/2014/7/17/431)
> >  - added board-specific fixes for device tree sources of Trats2 board,
> >  - rebased on next-20140826 of linux-next tree.
> >
> > Changes since v1:
> >  - dropped outer_resume() - will be handled in assembly in further patches,
> >    as support for L2C in non-secure mode gets added,
> >  - moved CP15 resume to assembly as it needs to be done before MMU is enabled,
> >  - surrounded CP15 save with a check for cpuid part, because it is valid only
> >    on Cortex A9,
> >  - rebased on next-20140717 tag of linux-next tree.
> >
> > Tomasz Figa (5):
> >   ARM: firmware: Introduce suspend and resume operations
> >   ARM: EXYNOS: Add support for firmware-assisted suspend/resume
> >   ARM: dts: exynos4412-trats2: Keep eMMC regulators soft-disabled
> >   ARM: dts: exynos4x12: Add utility macro to define pin sleep states
> >   ARM: dts: exynos4412-trats2: Add sleep mode pin configuration
> >
> >  Documentation/arm/firmware.txt            |  28 +--
> >  arch/arm/boot/dts/exynos4412-trats2.dts   | 320 +++++++++++++++++++++++++++++-
> >  arch/arm/boot/dts/exynos4x12-pinctrl.dtsi |  16 ++
> >  arch/arm/include/asm/firmware.h           |   8 +
> >  arch/arm/mach-exynos/Makefile             |   1 +
> >  arch/arm/mach-exynos/common.h             |   4 +
> >  arch/arm/mach-exynos/firmware.c           |  45 +++++
> >  arch/arm/mach-exynos/pm.c                 |  16 +-
> >  arch/arm/mach-exynos/sleep.S              |  28 +++
> >  arch/arm/mach-exynos/smc.h                |   4 +
> >  10 files changed, 438 insertions(+), 32 deletions(-)
> >
> 
> Would you consider applying this series? It has been waiting on the ML
> long enough (note no changes in core patches since last revision, just
> few more board specific patches). Thanks in advance.
> 
Sure, I will. Thanks for your gentle reminder.

- Kukjin

