Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaJXLqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:46:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8471 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbaJXLqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:46:22 -0400
X-AuditID: cbfee691-f79b86d000004a5a-cc-544a3c0cdea4
Message-id: <544A3C0C.6060603@samsung.com>
Date: Fri, 24 Oct 2014 20:46:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        ben-linux@fluff.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
        arnd@arndb.de, olof@lixom.net, mturquette@linaro.org,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, jh80.chung@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com, yj44.cho@samsung.com
Subject: Re: [PATCH 1/5] ARM: EXYNOS: Add EXYNOS4415 SoC ID
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
 <1413775935-17743-1-git-send-email-cw00.choi@samsung.com>
 <544A3B67.4010507@gmail.com>
In-reply-to: <544A3B67.4010507@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42JZI2JSoMtj4xViMGOlhsXfScfYLSatO8Bk
	8WdCK5vFrr/3GS0m3Z/AYrGj4QirxY1fbawWvQuuslmcbXrDbjHlz3Imi02Pr7FaXN41h81i
	xvl9TBa3L/NaLL1+kcni6YSLbBanrn8Gik9+yWZxbMYSRotVu/4wWuzdOZnRQdRjzbw1jB4t
	zT1sHr9/TWL0+LvqBbPHzll32T3uXNvD5rF5Sb3HlRNNrB59W1YxenzeJBfAFcVlk5Kak1mW
	WqRvl8CV8ebSWbaCb2IVh29MZmtgnCfcxcjJISFgIvFlzmE2CFtM4sK99UA2F4eQwFJGiVcP
	frLCFL34cZgFIrGIUeLqtBWMEM5rRokJV28xglTxCmhJLDl6mQnEZhFQlbi+cgkLiM0GFN//
	4gbYClGBMImV06+wQNQLSvyYfA/MFhFQl/g2pZ8dZCizwD9miW83zrGDJIQFrCUWfZzMDrFt
	AaNE7+prYAlOAU2Jr9/3AtkcQB16EvcvaoGEmQXkJTavecsMcfYNDokt++ogDhKQ+Db5EAtI
	uYSArMSmA1AlkhIHV9xgmcAoNgvJSbMQhs5CMnQBI/MqRtHUguSC4qT0IlO94sTc4tK8dL3k
	/NxNjMCEcfrfs4k7GO8fsD7EKMDBqMTDe2OGZ4gQa2JZcWXuIUZToCMmMkuJJucD01JeSbyh
	sZmRhamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mkre0Z284yez2
	5UvpdN2zm3pEODXutE1TaQ2Svzglfm7qFGW1RYkvL3LEfle5p8Ex7c/mlu45Uu+tvshd/Lfx
	X5Os4vweg9u+TLOWhAqWKX807Z3SKuGjv2vG0RBO986LBspN06b2/eKLmDxhw1yH18cvMG11
	NmXv6lTu68i2OH9kUibjCZ57SizFGYmGWsxFxYkA1x6LSxMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAV0eG68Qg+n7FSz+TjrGbjFp3QEm
	iz8TWtksdv29z2gx6f4EFosdDUdYLW78amO16F1wlc3ibNMbdospf5YzWWx6fI3V4vKuOWwW
	M87vY7K4fZnXYun1i0wWTydcZLM4df0zUHzySzaLYzOWMFqs2vWH0WLvzsmMDqIea+atYfRo
	ae5h8/j9axKjx99VL5g9ds66y+5x59oeNo/NS+o9rpxoYvXo27KK0ePzJrkArqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoCeVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBlvLp1lK/gmVnH4xmS2BsZ5wl2MnBwSAiYS
	L34cZoGwxSQu3FvP1sXIxSEksIhR4uq0FYwQzmtGiQlXbzGCVPEKaEksOXqZCcRmEVCVuL5y
	CVg3G1B8/4sbbCC2qECYxMrpV1gg6gUlfky+B2aLCKhLfJvSzw4ylFngH7PEtxvn2EESwgLW
	Eos+TmaH2LaAUaJ39TWwBKeApsTX73uBbA6gDj2J+xe1QMLMAvISm9e8ZZ7AKDALyY5ZCFWz
	kFQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGckJ5J72Bc1WBxiFGAg1GJh/fGDM8Q
	IdbEsuLK3EOMEhzMSiK8XiZeIUK8KYmVValF+fFFpTmpxYcYTYEhMJFZSjQ5H5gs80riDY1N
	zIwsjcwNLYyMzZXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFxcEo1MAr9strQrs6eF6iylvXhtVn1
	qWeU1pu/7l2deX+mxlGX9CucVradd2oCb90/4XniU8JqPuOgVqn8zefuHLW48FtIpd+xeEKS
	bnduSNGTdTKO9hu3TGZKuKtqnFw6Tzlx7kzZNWzSIuttC1hLah7Fn4gwV20ONngt4pLpu1R2
	1vQDDiKV5ybrK7EUZyQaajEXFScCAC1B1g5eAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 10/24/2014 08:43 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 20.10.2014 05:32, Chanwoo Choi wrote:
>> This patch add Exynos4415's SoC ID. Exynos4415 is based on the 32-bit RISC
>> processor for Smartphone. Exynos4415 uses Cortex A9 quad-cores and has a target
>> speed of 1.6GHz and provides 8.5GB/s memory bandwidth.
>>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/Kconfig  | 5 +++++
>>  arch/arm/mach-exynos/common.h | 8 ++++++++
>>  arch/arm/mach-exynos/exynos.c | 2 ++
>>  3 files changed, 15 insertions(+)
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
>>  config SOC_EXYNOS5250
>>  	bool "SAMSUNG EXYNOS5250"
>>  	default y
>> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
>> index d4d09bc..ffc0c22 100644
>> --- a/arch/arm/mach-exynos/common.h
>> +++ b/arch/arm/mach-exynos/common.h
>> @@ -21,6 +21,7 @@
>>  #define EXYNOS4210_CPU_ID	0x43210000
>>  #define EXYNOS4212_CPU_ID	0x43220000
>>  #define EXYNOS4412_CPU_ID	0xE4412200
>> +#define EXYNOS4415_CPU_ID	0xE4415000
>>  #define EXYNOS4_CPU_MASK	0xFFFE0000
>>  
>>  #define EXYNOS5250_SOC_ID	0x43520000
>> @@ -42,6 +43,7 @@ IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
>>  IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
>>  IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
>>  IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
>> +IS_SAMSUNG_CPU(exynos4415, EXYNOS4415_CPU_ID, EXYNOS4_CPU_MASK)
> 
> Is there a need for this legacy helper for this SoC?

No, I'll drop it on next patchset.

> 
>>  IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
>>  IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS5_SOC_MASK)
>>  IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
>> @@ -72,6 +74,12 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
>>  # define soc_is_exynos4412()	0
>>  #endif
>>  
>> +#if defined(CONFIG_SOC_EXYNOS4415)
>> +# define soc_is_exynos4415()	is_samsung_exynos4415()
>> +#else
>> +# define soc_is_exynos4415()	0
>> +#endif
> 
> Ditto.

I'll drop it on next patchset.

Best Regards,
Chanwoo Choi

> 
> Best regards,
> Tomasz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

