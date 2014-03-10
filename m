Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaCJIHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:07:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17162 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaCJIHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:07:46 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-0a-531d72ce9428
Message-id: <531D76AB.2030401@samsung.com>
Date: Mon, 10 Mar 2014 17:24:11 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 1/3] drivers: clk: add samsung common clock config option
References: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
 <1393392247-6247-2-git-send-email-pankaj.dubey@samsung.com>
 <531D0718.8000305@gmail.com>
In-reply-to: <531D0718.8000305@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI91zRbLBBo9filpsenyN1eLyrjls
	FjPO72OyeDrhIpvFql1/GB1YPXbOusvucefaHjaPzUvqPT5vkgtgieKySUnNySxLLdK3S+DK
	mPZoFUtBj0jF1E172RsYn/F3MXJySAiYSKx/28cGYYtJXLi3HswWEljGKHGtTwmm5snbcyxd
	jFxA8UWMEu96X0E5rxklrm7vYAWp4hXQktixuosRxGYRUJU4deALC4jNJqAr8eT9XGYQW1Qg
	TGLT9D6oekGJH5PvgdWICKhLfJvSzw4ylFlgMqPEm5m97CAJYQFfieXr9rBDbFvCKPHx7iqw
	SZwCmhLTf84E62YWsJZYOWkbI4QtL7F5zVtmiLv3sUu0762BuEhA4tvkQ0D1HEBxWYlNB6BK
	JCUOrrjBMoFRbBaSm2YhmToLydQFjMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUIia+IO
	xvsHrA8xJgOtnMgsJZqcD4zMvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJpCeWpGanphak
	FsUXleakFh9iZOLglGpgLJNLZ6u2ElRZVB95bcXUC4lWC7v53nedE04zXFBZb35SUkhfp9v/
	2Bz3DzNZymc+vXC89H+181LXhHa3eQoGxUXLT0RWaK8+uOOm9WLuRXNnVLg/3/ZP5/flQNlD
	chp++Tu3HUg6/ePzk6pENv6bwieyg73MNQIsLSaVRmz+9Pbk8gdLlKNWKbEUZyQaajEXFScC
	AMwJIfvCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xgO65Itlgg1lnBS02Pb7GanF51xw2
	ixnn9zFZPJ1wkc1i1a4/jA6sHjtn3WX3uHNtD5vH5iX1Hp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZkx7tIqloEekYuqmvewNjM/4uxg5OSQETCSevD3HAmGL
	SVy4t56ti5GLQ0hgEaPEu95XLBDOa0aJq9s7WEGqeAW0JHas7mIEsVkEVCVOHfgC1s0moCvx
	5P1cZhBbVCBMYtP0Pqh6QYkfk++B1YgIqEt8m9LPDjKUWWAyo8Sbmb3sIAlhAV+J5ev2sENs
	W8Io8fHuKrBJnAKaEtN/zgTrZhawllg5aRsjhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY/eZ1A7GlQ0WhxgFOBiVeHgzXssEC7EmlhVX5h5i
	lOBgVhLhzYiTDRbiTUmsrEotyo8vKs1JLT7EmAwMg4nMUqLJ+cC0klcSb2hsYmZkaWRmYWRi
	bk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjJobvzA0Jm3sWzlz/otrWxL/R/woOHW3
	JrTT9XpAYx1773zNmdEXt/X6P3ngJS5XsnuO980/Bt5MMpevTrsz485nLpu7m5ZVBi1Yrf/Y
	oGbqb0ftK1MflTxY9WL65Qczl8wumxUdGzWjxjZFKHCv7r+KZ6cEbj7s+jGNu1bsufxezzbf
	eJv29P1KLMUZiYZazEXFiQCmzMnlIQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/10/2014 09:28 AM, Tomasz Figa wrote:
> Hi Pankaj,
>
> On 26.02.2014 06:24, Pankaj Dubey wrote:
>> add samsung common clock config option and let ARCH_EXYNOS or 
>> ARCH_S3CXXXX
>> select this if they want to use samsung common clock infrastructure.
>>
>> CC: Mike Turquette <mturquette@linaro.org>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   drivers/clk/Kconfig  |   10 ++++++++++
>>   drivers/clk/Makefile |    2 +-
>>   2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>> index 7641965..d93a325 100644
>> --- a/drivers/clk/Kconfig
>> +++ b/drivers/clk/Kconfig
>> @@ -23,6 +23,16 @@ config COMMON_CLK
>>   menu "Common Clock Framework"
>>       depends on COMMON_CLK
>>
>> +config COMMON_CLK_SAMSUNG
>> +    bool "Clock driver for Samsung SoCs"
>> +    depends on ARCH_S3C64XX || ARCH_S3C24XX || ARCH_EXYNOS || ARM64
>> +    ---help---
>> +          Supports clocking on Exynos SoCs:
>> +      - Exynos5250, Exynos5420 board.
>> +      - Exynos4 boards.
>> +      - S3C2412, S3C2416, S3C2466 boards.
>> +      - S3C64XX boards.
>
> I don't think listing the platforms here explicitly is a good idea, as 
> this option shouldn't generally be user-visible (related platforms 
> would not work without this option enabled) and adding support for 
> every new SoC would require changing the help string.
>
> I wonder if we really need this to be user-visible. What about moving 
> it out of this menu, making the symbol select COMMON_CLK and let the 
> platforms just select COMMON_CLK_SAMSUNG alone?
>
> Best regards,
> Tomasz
>

Thanks for review. I agree your point. In that case how about adding 
"drivers/clk/samsung/Kconfig" as below:

+config COMMON_CLK_SAMSUNG
+    bool
+    select COMMON_CLK
+
+config S3C2412_COMMON_CLK //These macros are introduced by Heiko's 
clock patches for S3C24XX SoC
+    bool
+    select COMMON_CLK_SAMSUNG
+
+config S3C2443_COMMON_CLK
+    bool
+    select COMMON_CLK_SAMSUNG

In this way we can get rid of clock related config options from 
"arch/arm/mach-s3c24xx/Kconfig" and in future
if any other old SoC such as S5P clocks getting converted to use common 
clock, they can add related config here rather
than arch/mach-xxx/Kconfig if required. Thus we can keep all common 
clock config option for Samsung SoC at one place.
All Exynos SOC can select only COMMON_CLK_SAMSUNG to use Samsung common 
clock infrastructure.

-- 
Best Regards,
Pankaj Dubey

