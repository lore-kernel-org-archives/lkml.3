Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaDZLjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:39:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22853 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaDZLjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:39:40 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-59-535b9afbb5fa
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, jic23@kernel.org
Subject: [PATCH 0/5 v2] iio: exynos_adc: fix minor nits in the driver
Date: Sat, 26 Apr 2014 17:07:51 +0530
Message-id: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWyRsSkSvf3rOhgg42zBC1eHtK0OLvsIJtF
	8+L1bBavjvxgsnjQtIrJYsnk+awW8468Y7G4vGsOm8WM8/uYLBZt+8/swOUxu+Eii8fOWXfZ
	PTat6mTz2D93DbvHkjeHWD36tqxi9Pi8SS6APYrLJiU1J7MstUjfLoEr40tzE3PBCs6Kmytt
	Ghgvs3cxcnJICJhIfFr+iRHCFpO4cG89WxcjF4eQwFJGiV979zLCFJ2a8ogVxBYSmM4oMfWj
	GkRRP5PEhnvnwBJsAmYSBxetBprKwSEiICsxs1sPpIZZ4BGjxIyHvWCDhAVcJSatm84MYrMI
	qErsuDwXzOYVcJFo2bedFaRXQkBBYs4kG5BeCYFV7BKfZ4FcBFIvIPFt8iEWiBpZiU0HmCFu
	k5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAkP89L9nvTsYbx+wPsSY
	DDRuIrOUaHI+MEbySuINjc2MLExNTI2NzC3NSBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoFx9VnfPat174aeCdI62CZ9rFMs7e6fOoO4vy+91+q12sjf0FGr6Fk8fXbWBIY6
	nkMdTuJzPvDp1C/ptVjk+ZCJx99Kn5u53CnY4NX74H951gv0BbT67oidtqn8W7iGcWnLxnWK
	KsvsrMI5WMN438ZO/2a78cjRekXh97nbVl5kW/+urtOd30KJpTgj0VCLuag4EQDAExYdhwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd3fs6KDDebd57B4eUjT4uyyg2wW
	zYvXs1m8OvKDyeJB0yomiyWT57NazDvyjsXi8q45bBYzzu9jsli07T+zA5fH7IaLLB47Z91l
	99i0qpPNY//cNeweS94cYvXo27KK0ePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4
	UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoPuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqG
	BMH1GBmggYQ1jBlfmpuYC1ZwVtxcadPAeJm9i5GTQ0LAROLUlEesELaYxIV769lAbCGB6YwS
	Uz+qdTFyAdn9TBIb7p0DK2ITMJM4uGg1UDMHh4iArMTMbj2QGmaBR4wSMx72MoLUCAu4Skxa
	N50ZxGYRUJXYcXkumM0r4CLRsm87K0ivhICCxJxJNhMYuRcwMqxiFE0tSC4oTkrPNdQrTswt
	Ls1L10vOz93ECI6gZ1I7GFc2WBxiFOBgVOLh3ZETFSzEmlhWXJl7iFGCg1lJhHdRSnSwEG9K
	YmVValF+fFFpTmrxIcZkoOUTmaVEk/OB0Z1XEm9obGJuamxqaWJhYmZJmrCSOO+BVutAIYH0
	xJLU7NTUgtQimC1MHJxSDYzqeUwuse9SnZYmfnNv8Kqfw7qm6atuyowFO1VjL96eeThSPKtl
	e9GaS2ft2UIrT3xTCHHd8XqH7umvj1/8eptw55Qht9l72/zD615f7p28acIb9ZUHZO/eWGHa
	u07E7FqDTUkGS9mpO3uVO9besNIvTvkvm8S6wch1z6bChL1zz2/q0L1R4FyhxFKckWioxVxU
	nAgAL1ttPuQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes the 
1. bug causing a crash during module removal for exynos_adc.ko.
-> The bug was seen by Doug, while trying to compile the whole IIO subsystem
   as module @ https://lkml.org/lkml/2014/4/21/481 from Doug.

2. rearrange the clock and regulator enable/disable calls during
   probe, remove, suspend and resume calls
-> Comments give by Jonathan @ https://lkml.org/lkml/2014/4/23/644

3. reduces the timeout and uses wait_for_completion_timeout instead of the
   interruptible varient.
-> This change was under review @ https://lkml.org/lkml/2013/11/5/92
   Final comments were given by Tomasz, to split and submit.

Naveen Krishna Ch (2):
  iio: exynos_adc: use indio_dev->dev structure to handle child nodes
  iio: exynos_adc: rearrange clk and regulator enable/disable calls

Naveen Krishna Chatradhi (3):
  iio: exynos_adc: reduce timeout and use wait_for_completion_timeout
  iio: exynos_adc: do a soft reset in case of timeout
  iio: exynos_adc: do a reinit_completion before the conversion

 drivers/iio/adc/exynos_adc.c |  138 +++++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 63 deletions(-)

-- 
1.7.9.5

