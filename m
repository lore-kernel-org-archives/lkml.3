Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaGALwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 07:52:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51259 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaGALwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 07:52:25 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-62-53b2a0f60705
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Chander Kashyap'" <k.chander@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nicolas.pitre@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, daniel.lezcano@linaro.org,
        lorenzo.pieralisi@arm.com, rjw@rjwysocki.net, tomasz.figa@gmail.com
References: <1402914383-20471-1-git-send-email-k.chander@samsung.com>
In-reply-to: <1402914383-20471-1-git-send-email-k.chander@samsung.com>
Subject: RE: [Patch v7 0/6] add cpuidle support for Exynos5420
Date: Tue, 01 Jul 2014 20:52:21 +0900
Message-id: <03d501cf9522$eaf67200$c0e35600$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHLc/tBFj5pVnOkF6taZ4Cy7bYJ65uTWzAA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zA91vCzYFG+y7KWAx77OsxaoNS1gs
	Nj2+xmpxedccNovPvUcYLWac38dk8eb3C3aLT8/+sVucOX2J1WLVrj+MDlwea+atYfTYOesu
	u8eda3vYPDYvqffYcrWdxaNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyenfcYir4z13xv20W
	WwPjJs4uRg4OCQETiRUXxboYOYFMMYkL99azdTFycQgJLGOUeL2ojxUiYSLx9d4xRojEIkaJ
	Tx/aWCCcv4wSG4//YgGpYhPQkDj8/hk7SEIEpH32+0+sIA6zQBejxMUVnewgVUICrhIzF98B
	m8sp4CZxaf5kZpA7hAXsJHYtNQYJswioShyd854ZxOYVsJRYtukHG4QtKPFj8j2wZcwCWhLr
	dx5ngrDlJTavecsMcaqCxI6zrxlBbBEBI4l3XbugakQk9r14B/aChMBUDomF6+4yQywTkPg2
	+RALJCxkJTYdgJojKXFwxQ2WCYwSs5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kalecWJu
	cWleul5yfu4mRki8T9zBeP+A9SHGZKD1E5mlRJPzgekiryTe0NjMyMLUxNTYyNzSjDRhJXHe
	9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYs+7G2qgVBP4SkQ31Ov5kiZNG7feFKVfv
	NB0+/kLobVOAyuY//zg3xJ/krvlSHi074/Y996M3Vq2ybVB6cjFgMvcWjlXmHz8Y35ruzb6g
	SXPOiuQzMn9v3fd9wb9tTa1dbvoyMxb9x+/mt26b/5Ofm9t2nqjZtgDT4JVmQYw7yq9n3G5Y
	d2HnASWW4oxEQy3mouJEAGJufNoNAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd1vCzYFG6w+yGMx77OsxaoNS1gs
	Nj2+xmpxedccNovPvUcYLWac38dk8eb3C3aLT8/+sVucOX2J1WLVrj+MDlwea+atYfTYOesu
	u8eda3vYPDYvqffYcrWdxaNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNN
	zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAzlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsS
	BNdjZIAGEtYxZvTuuMVU8J+74n/bLLYGxk2cXYycHBICJhJf7x1jhLDFJC7cW8/WxcjFISSw
	iFHi04c2FgjnL6PExuO/WECq2AQ0JA6/f8YOkhARWMYoMfv9J1YQh1mgi1Hi4opOdpAqIQFX
	iZmL77CC2JwCbhKX5k9m7mLk4BAWsJPYtdQYJMwioCpxdM57ZhCbV8BSYtmmH2wQtqDEj8n3
	wJYxC2hJrN95nAnClpfYvOYtM8SpChI7zr4GO1tEwEjiXdcuqBoRiX0v3jFOYBSahWTULCSj
	ZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwenkmdQOxpUNFocYBTgYlXh4
	FRo2BguxJpYVV+YeYpTgYFYS4b01e1OwEG9KYmVValF+fFFpTmrxIUZToE8nMkuJJucDU11e
	SbyhsYmZkaWRmYWRibm5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbGpqTn1w0Oya976rXv
	1Sc5XveSB8F6W13uZH9NWNLGv2y6cOfe98F13+vl5Hme1u6YycPf3qi/ea3J6gdPS4P6gszv
	7KlJtVL9Kl35Ymd506VqR5X8P6b/D9e9qCqZaP7igsEpUSOvqe+07599fDeXKyBd0JZJ/NMN
	mUaDt94vrDjf6m+Isf6ixFKckWioxVxUnAgADQH76D0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chander Kashyap wrote:
> 
> Exynos5420 is a big-little Soc from Samsung. It has 4 A15 and 4 A7 cores.
> 
> This patchset adds cpuidle support for Exynos5420 SoC based on
> generic big.little cpuidle driver.
> 
> Tested on SMDK5420.
> Rebased on 3.16-rc1
> 
> Changelog is in respective patches.
> Chander Kashyap (5):
>   driver: cpuidle-big-little: add of_device_id structure
>   arm: exynos: add generic function to calculate cpu number
>   cpuidle: config: Add ARCH_EXYNOS entry to select cpuidle-big-little
>     driver
>   driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
>   exynos: cpuidle: do not allow cpuidle registration for Exynos5420
>   mcpm: exynos: populate suspend and powered_up callbacks
> 
>  arch/arm/mach-exynos/exynos.c        |    4 +++-
>  arch/arm/mach-exynos/mcpm-exynos.c   |   36 ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-exynos/regs-pmu.h      |    9 +++++++++
>  drivers/cpuidle/Kconfig.arm          |    2 +-
>  drivers/cpuidle/cpuidle-big_little.c |   12 +++++++++++-
>  5 files changed, 60 insertions(+), 3 deletions(-)
> 

+ Nicolas

Hi,

This series looks good to me and I asked Chander to test this series with
Nico's mcpm patches on smdk5420 and he said it works fine. So I will apply
this into samsung tree if Nicolas has no objection on 6/6.

BTW, one more, there are duplicated sign-off from Chander with different
e-mail address, I'm not sure it should be fine or not because I didn't see
same thing before.

Thanks,
Kukjin

