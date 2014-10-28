Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbaJ1EFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:05:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40616 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbaJ1EFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:05:07 -0400
X-AuditID: cbfee68d-f79296d000004278-7b-544f15f074be
Message-id: <544F15F0.9080102@samsung.com>
Date: Tue, 28 Oct 2014 13:05:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        yj44.cho@samsung.com, jaewon02.kim@samsung.com, ideal.song@samsung.com
Subject: Re: [PATCHv2 1/2] ARM: EXYNOS: Add EXYNOS4415 SoC ID
References: <1414373759-4362-1-git-send-email-cw00.choi@samsung.com>
 <1414373759-4362-2-git-send-email-cw00.choi@samsung.com>
 <02b501cff262$127d44b0$3777ce10$@kernel.org>
In-reply-to: <02b501cff262$127d44b0$3777ce10$@kernel.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkWPeDqH+IQcd3aYu/k46xW+z6e5/R
	YtL9CSwWOxqOsFr0P37NbHG26Q27xabH11gtLu+aw2Yx4/w+Jou1R+6yWyy9fpHJ4tT1z0Cx
	yS/ZLFbt+sNosXfnZEYHfo8189Ywevz+NYnRY+esu+wem1Z1snlsXlLvceVEE6tH35ZVjB6f
	N8kFcERx2aSk5mSWpRbp2yVwZbQ3FhYs5avY+3o9awPjF+4uRk4OCQETiX9frrJA2GISF+6t
	Z+ti5OIQEljKKPH4dR8zTNGXv2/YIRKLGCUaHvyFqnrNKPFgx3omkCpeAS2JG+tOsYHYLAKq
	En9O94HZbEDx/S9ugNmiAmESK6dfYYGoF5T4MfkekM3BISKgKLF5gQLITGaBF0wSl9e/ZQep
	ERawlZhxrokZYtk6RokzBy6BNXMKWEqsefUFzGYW0JHY3zqNDcKWl9i85i1Yg4TATA6JHyt7
	WSAuEpD4NvkQ2DYJAVmJTQegXpOUOLjiBssERrFZSG6ahWTsLCRjFzAyr2IUTS1ILihOSi8y
	1CtOzC0uzUvXS87P3cQIjPLT/5717mC8fcD6EKMAB6MSD6/BQ78QIdbEsuLK3EOMpkBXTGSW
	Ek3OB6aSvJJ4Q2MzIwtTE1NjI3NLMyVxXkWpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUa
	GBlcIxQdRTdkLNuW2C6kflVV+GHYXdP2Q0JZm9TSzWSWxocWLXl3tcign//KhS+Krb4vpFXS
	PbsXpHLUCXh7z49v4YrhObpl49OWSxXb515WdVU6+s+F//O2dR+6nvsL3Hs04bVOj/uCc5IZ
	wdaz9WY5XrDa5Kkv8yn/yql/DAtYFlZtEyl4r8RSnJFoqMVcVJwIANIk/hLtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd0Pov4hBrPuC1n8nXSM3WLX3/uM
	FpPuT2Cx2NFwhNWi//FrZouzTW/YLTY9vsZqcXnXHDaLGef3MVmsPXKX3WLp9YtMFqeufwaK
	TX7JZrFq1x9Gi707JzM68HusmbeG0eP3r0mMHjtn3WX32LSqk81j85J6jysnmlg9+rasYvT4
	vEkugCOqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWNGe2NhwVK+ir2v17M2
	MH7h7mLk5JAQMJH48vcNO4QtJnHh3nq2LkYuDiGBRYwSDQ/+QjmvGSUe7FjPBFLFK6AlcWPd
	KTYQm0VAVeLP6T4wmw0ovv/FDTBbVCBMYuX0KywQ9YISPybfA7I5OEQEFCU2L1AAmcks8IJJ
	4vL6t2CbhQVsJWaca2KGWLaOUeLMgUtgzZwClhJrXn0Bs5kFdCT2t05jg7DlJTavecs8gVFg
	FpIds5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcAp5Jr2DcVWDxSFGAQ5G
	JR5ew4d+IUKsiWXFlbmHGCU4mJVEeL12AIV4UxIrq1KL8uOLSnNSiw8xmgKDYCKzlGhyPjC9
	5ZXEGxqbmBlZGpkbWhgZmyuJ8x5stQ4UEkhPLEnNTk0tSC2C6WPi4JRqYOSYeT/O42ubyJLz
	DGYvN+64ePbfU+mlJv/WWOyz/Oa8W0rqk4z6u/v7fIUD1vXVyl/YzHPzRsvaSYJ7/zq5s3zO
	a4ipqD9edK9SKpuLYyITh+ofBveLNQnt4eqiHBETZ23ujQ5r0F3FrH3q0J4VzgcWF05eMTts
	QdzcnSlay2/Yr49hYGx+90SJpTgj0VCLuag4EQCDf4WjNwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

On 10/28/2014 12:48 PM, Kukjin Kim wrote:
> Chanwoo Choi wrote:
>>
>> This patch add Exynos4415's SoC ID.
>>
> Since the CPU ID has been removed as per comments, need to update the commit
> message accordingly.

OK, I'll update it.

> 
>> Exynos4415 is based on the 32-bit RISC
>> processor for Smartphone. Exynos4415 uses Cortex A9 quad-cores and has a target
>> speed of 1.6GHz and provides 8.5GB/s memory bandwidth.
>>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/Kconfig  | 5 +++++
>>  arch/arm/mach-exynos/exynos.c | 2 ++
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>> index 46f3c0d..349c867 100644
>> --- a/arch/arm/mach-exynos/Kconfig
>> +++ b/arch/arm/mach-exynos/Kconfig
>> @@ -75,6 +75,11 @@ config SOC_EXYNOS4412
>>  	default y
>>  	depends on ARCH_EXYNOS4
>>
>> +config SOC_EXYNOS4415
>> +	bool "SAMSUNG EXYNOS4415"
>> +	default y
>> +	depends on ARCH_EXYNOS4
>> +
> 
> I think, this is not required more...

But,
The clock driver must need to CONFIG_SOC_EXYNOS4415 configuration
to build it. The clock driver[1] of exynos4415 used CONFIG_SOC_EXYNOS4415 as following diff:
  [1] https://lkml.org/lkml/2014/10/26/159

diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
index 8909c93..4561297 100644
--- a/drivers/clk/samsung/Makefile
+++ b/drivers/clk/samsung/Makefile
@@ -5,6 +5,7 @@
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-pll.o clk-cpu.o
 obj-$(CONFIG_SOC_EXYNOS3250)	+= clk-exynos3250.o
 obj-$(CONFIG_ARCH_EXYNOS4)	+= clk-exynos4.o
+obj-$(CONFIG_SOC_EXYNOS4415)	+= clk-exynos4415.o

Best Regards,
Chanwoo Choi
