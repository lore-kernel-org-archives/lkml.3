Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaGWBl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:41:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20298 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaGWBlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:41:55 -0400
X-AuditID: cbfee690-b7fb56d000003439-39-53cf12e08054
Message-id: <53CF12E0.5030903@samsung.com>
Date: Wed, 23 Jul 2014 10:41:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: jic23@kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, ch.naveen@samsung.com, arnd@arndb.de,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv8 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and
 code clean
References: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWyRsSkQPeB0Plgg7lrbSz+TjrGbnH3+WFG
	i+tfnrNazD9yjtXiQdMqJoveBVfZLM42vWG32PT4GqvFwrYlLBbzjrxjsbi8aw6bxYzz+5gs
	1s94zeLA6/H71yRGj02rOtk8Ni+p9+jbsorR4/MmuQDWKC6blNSczLLUIn27BK6Mnt0X2Ap2
	C1d8/X6KrYFxLX8XIweHhICJRNtayS5GTiBTTOLCvfVsXYxcHEICSxklfi5bxwiRMJE41jCV
	HSKxiFFiWvdWJgjnNaPEu9PXWECqeAW0JC513WMBmcoioCrxqTEDJMwGFN7/4gYbiC0qECax
	cvoVqHJBiR+T74HZIgIiEvdOf2AEmckscJVJ4tDpyawgCWGBCInH22aC2UICLhJf755jArE5
	BVwldq8+A9bMLKAjsb91GhuELS+xec1bZpBBEgI/2SW+7ZsD9gKLgIDEt8mHWCBelpXYdIAZ
	4jNJiYMrbrBMYBSbheSmWUjGzkIydgEj8ypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MwIg9
	/e/ZhB2M9w5YH2JMBlo5kVlKNDkfGPF5JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoKEhJITyxJ
	zU5NLUgtii8qzUktPsTIxMEp1cBozXP+d/ZCjXvHLkxYHi/dttSAs9vItyCcZ9PCjMt7HTlX
	MGztuHVULPmRJPObOZ/VXASS52RlLl9o4Bt/Lf91x6nJRkxdBy1nfPx5uf+QaO9EUZtzm8Wd
	27XZHpx+qOm942lcRrbymuCdYoevfQ18u2LvmgWnjerY98W+rOYJXijsFRWvULRMiaU4I9FQ
	i7moOBEAx+yj7e4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO4DofPBBjd/mFj8nXSM3eLu88OM
	Fte/PGe1mH/kHKvFg6ZVTBa9C66yWZxtesNusenxNVaLhW1LWCzmHXnHYnF51xw2ixnn9zFZ
	rJ/xmsWB1+P3r0mMHptWdbJ5bF5S79G3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCWsYM3p2X2Ar2C1c8fX7KbYGxrX8XYycHBICJhLHGqayQ9hiEhfurWfr
	YuTiEBJYxCgxrXsrE4TzmlHi3elrLCBVvAJaEpe67gHZHBwsAqoSnxozQMJsQOH9L26wgdii
	AmESK6dfgSoXlPgx+R6YLSIgInHv9AdGkJnMAleZJA6dnswKkhAWiJB4vG0mmC0k4CLx9e45
	JhCbU8BVYvfqM2DNzAI6Evtbp7FB2PISm9e8ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4ITyT3sG4qsHiEKMAB6MSD29BzblgIdbEsuLK3EOMEhzMSiK8
	0a1AId6UxMqq1KL8+KLSnNTiQ4ymwBCYyCwlmpwPTFZ5JfGGxiZmRpZG5oYWRsbmSuK8B1ut
	A4UE0hNLUrNTUwtSi2D6mDg4pRoYPX7/6Wf/KPClXfXegv7D+2eYt4muefzw1Ys8SfHTDhN1
	PJatqV9jYK/8s9/mvteZHesE5k+Iq5u6fX6Ha5lSjdW5iZq3zeXK3RZGruK62LdDuP8Ec26A
	y6XHgjkzT3Pc4p246bTQ4ZfP7zsxxdrlXv3mtGHVg64dIiuuLXgp/33anUxLg4vpLUosxRmJ
	hlrMRcWJAKXw/L4eAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jonathan,

Could you please pick this patchset for 3.17?

Best Regards,
Chanwoo Choi

On 07/22/2014 11:04 AM, Chanwoo Choi wrote:
> This patchset support Exynos3250 ADC (Analog Digital Converter) because
> Exynos3250 has additional special clock for ADC IP.
> 
> Changes from v7:
> - Add acked message by Arnd Bergmann
> - Use two compatible string for Exynos3250 ADC as following:
>   : compatible = "samsung,exynos3250-adc", "samsung,exynos-adc-v2;
> 
> Changes from v6:
> - Use "exynos3250-adc" compatible string instead of "exynos3250-adc-v2"
> - Use "sclk" clock name instead of "sclk_adc"
> - Remove un-necessary macro for exyno-adc-data-v2 structure.
> - Remove '(void *)' cast and mark the exynos-adc-data structure as 'const'
> - Change the number of ADC channels (Exynos3250 has only two channels for ADC)
> 
> Changes from v5:
> - Add acked message by Kukjin Kim
> - Add reviewed messgae by Tomasz Figa
> - Fix typo (for for -> for)
> 
> Changes from v4:
> - Use 'exynos_adc_data' structure instead of 'exynos_adc_ops' structure
>   and remove enum variable of ADC version
> - Fix wrong name of special clock (sclk_tsadc -> sclk_adc)
> - Add reviewed message by Naveen Krishna Chatradhi
> - Add functions for ADC clock control
> 
> Changes from v3:
> - Add new 'exynos_adc_ops' structure to improve readability according to
>  Tomasz Figa comment[1]
>  [1] https://lkml.org/lkml/2014/4/16/238
> - Add new 'exynos3250-adc-v2' compatible string to support Exynos3250 ADC
> - Fix wrong compaitlbe string of ADC in Exynos3250 dtsi file
> 
> Changes from v2:
> - Check return value of clock function to deal with error exception
> - Fix minor coding style to improve readability
> 
> Changes from v1:
> - Add new "samsung,exynos-adc-v3" compatible to support Exynos3250 ADC
> - Add a patch about DT binding documentation
> 
> Chanwoo Choi (4):
>   iio: adc: exynos_adc: Add exynos_adc_data structure to improve
>     readability
>   iio: adc: exynos_adc: Control special clock of ADC to support
>     Exynos3250 ADC
>   iio: devicetree: Add DT binding documentation for Exynos3250 ADC
>   ARM: dts: Fix wrong compatible string for Exynos3250 ADC
> 
>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |  25 +-
>  arch/arm/boot/dts/exynos3250.dtsi                  |   5 +-
>  drivers/iio/adc/exynos_adc.c                       | 335 +++++++++++++++------
>  3 files changed, 275 insertions(+), 90 deletions(-)
> 

