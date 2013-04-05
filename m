Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161694Ab3DEGsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:48:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60499 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765390Ab3DEGsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:48:36 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-b9-515e73be3334
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Viresh Kumar'" <viresh.kumar@linaro.org>, rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <cover.1365079581.git.viresh.kumar@linaro.org>
 <927100d30bf40d4fec477cc7d8d464669a22d167.1365079581.git.viresh.kumar@linaro.org>
In-reply-to: <927100d30bf40d4fec477cc7d8d464669a22d167.1365079581.git.viresh.kumar@linaro.org>
Subject: RE: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to
 drivers/cpufreq
Date: Fri, 05 Apr 2013 15:48:29 +0900
Message-id: <2a5901ce31c9$95160980$bf421c80$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xM8d4hpaY03aLTXOLuSqGN7eoZwAlQAFw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zA919xXGBBvNOc1m87p7NajFp3QEm
	i409n9ktnjb9YLd4f+gZs8Wmx9dYLS7vmsNm8bn3CKPFjPP7mCwOLG1nsZhy+AuLRf/CXiaL
	z4d3sVusvfsUqPerhwO/x5p5axg9/q56wexx59oeNo/NS+o9bv97zOzxaHELo8fnTXIB7FFc
	NimpOZllqUX6dglcGZcbbrAWdIpVrPpxjqmBcZdgFyMnh4SAicTWRZ1sELaYxIV764FsLg4h
	gWWMEvP+dTDBFH2euZsJIrGIUWLtpgdQzl9GidU75zCCVLEJaEgcfv+MHcQWEbCUmNH8Eayb
	WeAnk8SmpXEQDX2MEos+vwdLcAokSKxr+APUzMEhLBAqsfuMKUiYRUBVYsbGN2BzeAVsJa5O
	/A1lC0r8mHyPBWKmlsT6nceh5stLbF7zlhlkjISAusSjv7ogpoiAkcT56XIQFSIS+168YwS5
	QEJgLYfE+VtXGSFWCUh8m3yIBaJVVmLTAWaIfyUlDq64wTKBUWIWksWzkCyehWTxLCQrFjCy
	rGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQISQ79OxjvHrA+xJgMtH4is5Rocj4wueSVxBsa
	mxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXFG677zi3Z9
	cXdZ4F1lu1hj+SOlZg0doYgDzed/1bH0PWip5i9JEOvqL/nu7qkxSzTl9rZ/Ge11S+42Fwix
	L4pkPzl5mUyiy9QnL4ojXKUC5x0qds4+Jfj1wB7b13MYZpvzem+rnlUV+On5B5nrFz7Z5/Re
	1z326tHVS1m77tVe6FXwuHdP/rISS3FGoqEWc1FxIgCyHmubJAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsVy+t9jAd19xXGBBg3/mC1ed89mtZi07gCT
	xcaez+wWT5t+sFu8P/SM2WLT42usFpd3zWGz+Nx7hNFixvl9TBYHlrazWEw5/IXFon9hL5PF
	58O72C3W3n0K1PvVw4HfY828NYwef1e9YPa4c20Pm8fmJfUet/89ZvZ4tLiF0ePzJrkA9qgG
	RpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLuVFMoS
	c0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmXG26wFnSKVaz6cY6pgXGXYBcj
	J4eEgInE55m7mSBsMYkL99azdTFycQgJLGKUWLvpAROE85dRYvXOOYwgVWwCGhKH3z9jB7FF
	BCwlZjR/BOtmFvjJJLFpaRxEQx+jxKLP78ESnAIJEusa/gA1c3AIC4RK7D5jChJmEVCVmLHx
	DdgcXgFbiasTf0PZghI/Jt9jgZipJbF+53Go+fISm9e8ZQYZIyGgLvHory6IKSJgJHF+uhxE
	hYjEvhfvGCcwCs1CMmgWkkGzkAyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg
	1PNMagfjygaLQ4wCHIxKPLwZfbGBQqyJZcWVuYcYJTiYlUR4d/LFBQrxpiRWVqUW5ccXleak
	Fh9iTAb6cyKzlGhyPjAt5pXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhm
	CxMHp1QDY1r76Sjz5zKswvLKLa4XBfrOB0933up2aHag0onaq0WWNy83zQjeVLRE6fL5+194
	VmVe93+2lbW/m2+2aOdv/2O3YgLu5C6vkQ551cJ66xSrGcthM7eOeWZCX7t61KYL1VeJG1u8
	F/Cac27T96PuLNtl0xensZw4u9q/QZWhc7HSI8uppUq+SizFGYmGWsxFxYkA9DS464EDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar wrote:
> 
> This patch moves cpufreq driver of Samsung's ARM based s3c24xx platform to
> drivers/cpufreq.
> 
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/Kconfig                                   | 46 ---------------
>  arch/arm/mach-s3c24xx/Kconfig                      | 66
+++++++++-------------
>  arch/arm/mach-s3c24xx/Makefile                     |  6 --
>  arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h |  0
>  arch/arm/mach-s3c24xx/iotiming-s3c2412.c           |  2 +-
>  arch/arm/plat-samsung/include/plat/cpu-freq-core.h | 10 ++--
>  arch/arm/plat-samsung/include/plat/cpu-freq.h      |  6 +-
>  drivers/cpufreq/Kconfig.arm                        | 58
+++++++++++++++++++
>  drivers/cpufreq/Makefile                           |  5 ++
>  .../cpufreq/s3c2410-cpufreq.c                      |  0
>  .../cpufreq/s3c2412-cpufreq.c                      |  3 +-
>  .../cpufreq/s3c2440-cpufreq.c                      |  0
>  .../cpufreq/s3c24xx-cpufreq-debugfs.c              |  0
>  .../cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c |  0
>  14 files changed, 100 insertions(+), 102 deletions(-)
>  rename arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h (100%)
>  rename arch/arm/mach-s3c24xx/cpufreq-s3c2410.c =>
> drivers/cpufreq/s3c2410-cpufreq.c (100%)
>  rename arch/arm/mach-s3c24xx/cpufreq-s3c2412.c =>
> drivers/cpufreq/s3c2412-cpufreq.c (99%)
>  rename arch/arm/mach-s3c24xx/cpufreq-s3c2440.c =>
> drivers/cpufreq/s3c2440-cpufreq.c (100%)
>  rename arch/arm/mach-s3c24xx/cpufreq-debugfs.c =>
> drivers/cpufreq/s3c24xx-cpufreq-debugfs.c (100%)
>  rename arch/arm/mach-s3c24xx/cpufreq.c => drivers/cpufreq/s3c24xx-
> cpufreq.c (100%)
> 
Basically, this moving looks good to me, but should be re-worked based on
for-next of samsung tree because this touches too many samsung stuff so this
should be sent to upstream via samsung tree.

See below,

Applying: cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
error: patch failed: arch/arm/Kconfig:2166
error: arch/arm/Kconfig: patch does not apply
error: patch failed: arch/arm/mach-s3c24xx/Kconfig:28
error: arch/arm/mach-s3c24xx/Kconfig: patch does not apply
error: patch failed: arch/arm/mach-s3c24xx/Makefile:17
error: arch/arm/mach-s3c24xx/Makefile: patch does not apply
error: patch failed: drivers/cpufreq/Makefile:63
error: drivers/cpufreq/Makefile: patch does not apply
error: drivers/cpufreq/s3c2412-cpufreq.c: does not exist in index
Patch failed at 0001 cpufreq: s3c24xx: move cpufreq driver to
drivers/cpufreq

Thanks.

- Kukjin

