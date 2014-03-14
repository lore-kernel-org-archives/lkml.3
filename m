Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaCNDOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 23:14:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46240 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaCNDOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 23:14:05 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-e4-532273fbc8e8
Message-id: <532273FB.6040303@samsung.com>
Date: Fri, 14 Mar 2014 12:14:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 0/8] devfreq: exynos4: Support dt and use common ppmu
 driver
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <2117336.08cyWySR1X@amdc1032>
In-reply-to: <2117336.08cyWySR1X@amdc1032>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkSPd3sVKwQf8eeYuNM9azWsw/co7V
	4tyrlYwWZ5vesFssbFvCYnF51xw2i8+9RxgtZpzfx2Sx9PpFJovbjSvYLN78OMtkMWH6WhaL
	xyveslu8OtjG4sDnsWbeGkaPlcu/sHks3vOSyaNvyypGj+M3tjN5fN4k57FxbmgAexSXTUpq
	TmZZapG+XQJXxtRFU1kLlktXHJi8hbGB8YZoFyMnh4SAiURLyzpGCFtM4sK99WxdjFwcQgJL
	GSXWH53MClO05cs8JojEIkaJD9P+sUA4rxglWh/eA6viFdCSmDF5DzOIzSKgKnFwwh8wmw0o
	vv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRQQsJNaueAs2lFngFpPE2W9TwBLCAiEStw4dAWsW
	EkiV+LLpJJjNCTR0V9MzdhCbWUBHYn/rNDYIW15i85q3zCCDJAQmckg8u/kZ6iIBiW+TDwEN
	5QBKyEpsOsAM8ZqkxMEVN1gmMIrNQnLTLCRjZyEZu4CReRWjaGpBckFxUnqRqV5xYm5xaV66
	XnJ+7iZGYEyf/vds4g7G+wesDzEmA62cyCwlmpwPTAl5JfGGxmZGFqYmpsZG5pZmpAkrifOm
	P0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDIJ+SftndP64rgdRK6Zdf27E3SujovPrNZ
	6LjFFymT4hJGtZ6PwSLLU/LW8P0xLXNUaHoTut2c99LbFTu21p8y9glsi970SG5HY/u2nQea
	0osOO1yfxcXNeyCp4+K65Re373Z9uv6Z8OdN6j6KVjkW85W40/487HU47izCGjY7y285b6Ln
	LxUlluKMREMt5qLiRAA0Q0ix/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd3fxUrBBmc7xSw2zljPajH/yDlW
	i3OvVjJanG16w26xsG0Ji8XlXXPYLD73HmG0mHF+H5PF0usXmSxuN65gs3jz4yyTxYTpa1ks
	Hq94y27x6mAbiwOfx5p5axg9Vi7/wuaxeM9LJo++LasYPY7f2M7k8XmTnMfGuaEB7FENjDYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QDcrKZQl5pQC
	hQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDOmLprKWrBcuuLA5C2MDYw3RLsYOTkk
	BEwktnyZxwRhi0lcuLeerYuRi0NIYBGjxIdp/1ggnFeMEq0P77GCVPEKaEnMmLyHGcRmEVCV
	ODjhD5jNBhTf/+IGG4gtKhAmsXL6FRaIekGJH5PvgdkiAhYSa1e8BRvKLHCLSeLstylgCWGB
	EIlbh46ANQsJpEp82XQSzOYEGrqr6Rk7iM0soCOxv3UaG4QtL7F5zVvmCYwCs5DsmIWkbBaS
	sgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxghPGM6kdjCsbLA4xCnAwKvHwOhxWDBZi
	TSwrrsw9xCjBwawkwlsVoRQsxJuSWFmVWpQfX1Sak1p8iDEZGAQTmaVEk/OBySyvJN7Q2MTM
	yNLI3NDCyNicNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhhDnSXYnJTivdhqF/R47b/b
	O/eJ3sN79tWLk2dISjdbNP+Qd3zAvlSf4U9mYZOP60H/lj1SlZ37owRef1iuGFN+O7Yr9svc
	Cz95D7y84am8ITQ8u/DYXo49Td+NomwWfd7yL1/cyKaj9MOyP77nJ5Xsl9m9qepjyfUHd+V0
	eJuiMn57Kci/l1NiKc5INNRiLipOBADh0buKXAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/14/2014 01:43 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Thursday, March 13, 2014 05:17:21 PM Chanwoo Choi wrote:
>> This patchset support devicetree and use common ppmu driver instead of
>> individual code of exynos4_bus.c to remove duplicate code. Also this patchset
>> get the resources for busfreq from dt data by using DT helper function.
>> - PPMU register address
>> - PPMU clock
>> - Regulator for INT/MIF block
>>
>> This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
>> To remove power-leakage in suspend state, before entering suspend state,
>> disable ppmu clocks.
>>
>> Changes from v1:
>> - Add exynos4_bus.txt documentation for devicetree guide
>> - Fix probe failure if CONFIG_PM_OPP is disabled
>> - Fix typo and resource leak(regulator/clock/memory) when happening probe failure
>> - Add additionally comment for PPMU usage instead of previous PPC
>> - Split separate patch to remove ambiguous of patch
>>
>> Chanwoo Choi (8):
>>   devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
>>   devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
>>   devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
>>   devfreq: exynos4: Fix bug of resource leak and code clean on probe()
>>   devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
>>   devfreq: exynos4: Fix power-leakage of clock on suspend state
>>   devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
>>   devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
>>
>>  .../devicetree/bindings/devfreq/exynos4_bus.txt    |  49 +++
>>  drivers/devfreq/Kconfig                            |   1 +
>>  drivers/devfreq/exynos/Makefile                    |   2 +-
>>  drivers/devfreq/exynos/exynos4_bus.c               | 415 ++++++++++++++-------
>>  4 files changed, 341 insertions(+), 126 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
> 
> Thanks for updating this patchset.  There are still some minor issues
> left though:
> 
> - patch #4 should be at beginning of the patch series
> 
> - moving of devfreq_unregister_opp_notifier(dev, data->devfreq) from
>   exynos4_bus_exit() to exynos4_busfreq_remove() should be in patch #4
>   (which should really be at the beggining of patch series) not #3
> 
> - handling of iounmap(data->ppmu[i].hw_base) should be added to
>   exynos4_bus_exit() in patch #2 not #3
> 
> - patch #8 summary and description should mention fact that it adds DT
>   binding documentation (not the driver itself) and the patch itself
>   can be slighlty polished

OK, I'll re-order the sequence of patchset and modify minior issues about your comment.
Also, I'll modify the patch description for patch8.

> 
> One important note about this patchset not mentioned in the cover
> letter is that it is improving currently unused driver (because of
> DT-only mach-exynos conversion the only user was removed in June 2013
> and from the reading the code I suspect that even that user hadn't
> worked previously).  As such this patch series should not cause any
> regressions.

I don't understand correct your meaning.I explained DT support on upper
patchset description by using DT helper function and I added PPMU descritpion.
Also, Each patch include detailed description of patch content.

What is more needed?

Best Regards,
Chanwoo Choi





