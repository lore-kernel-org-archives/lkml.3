Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934564AbaGRKA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:00:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33425 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934490AbaGRKAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:00:52 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-1e-53c8f051d722
Message-id: <53C8F050.6060104@samsung.com>
Date: Fri, 18 Jul 2014 19:00:48 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        ch.naveen@samsung.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCHv6 2/4] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
 <1405663186-26464-3-git-send-email-cw00.choi@samsung.com>
 <6485839.CnzmD0SeQj@wuerfel>
In-reply-to: <6485839.CnzmD0SeQj@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42JZI2JSrBv44USwweVGaYu/k46xW9x9fpjR
	Yv6Rc6wW/W8Wslqce7WS0eJB0yomi94FV9kszja9YbfY9Pgaq8XCtiUsFvOOvGOxuLxrDpvF
	jPP7mCyWXr/IZDFh+loWi7d3prNYtO49wm6xfsZrFgchjzXz1jB6/P41idHjcl8vk8fK5V/Y
	PDav0PLYtKoTyFhS79G3ZRWjx+dNcgGcUVw2Kak5mWWpRfp2CVwZ/8/PYSyYL1HxYukdpgbG
	14JdjJwcEgImEgcPv2eBsMUkLtxbz9bFyMUhJLCUUeJ3xw8mmKLrHZOZIBLTGSV6TxxlhXBe
	M0o8P/8IyOHg4BXQkji33hOkgUVAVeLH/DuMIDYbUHj/ixtsILaoQJjEyulXwLbxCghK/Jh8
	D8wWEVCUmPriGTPITGaBA8wSv948ZAZJCAtkSkw49BfqpAWMEj2TbjKBLOMU0JT4/U4RpIZZ
	QEdif+s0NghbXmLzmrdggyQE9nBIfPn3kwXiIgGJb5MPsYD0SgjISmw6wAzxmaTEwRU3WCYw
	is1CctMsJGNnIRm7gJF5FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgKjj971nvDsbbB6wP
	MSYDrZzILCWanA9MJXkl8YbGZkYWpiamxkbmlmakCSuJ8yY9TAoSEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwDgzWKCIqzye94LUgzfbL+xg5DM9M1epv2Der1mb9Q2jwn9Gl6cerF1tpKUv
	f0y3kqe4++2PVqsr/5M+pC/WfmFZ9j4t29dx9sqOiJcKuUYPdu/lzjRTjFl+atmyjo59do76
	biwCyyv9y2+2rt1z+7x6o01W/TujLtPCX3kGE4s+2BuG3VtUpMRSnJFoqMVcVJwIAFbOdbYb	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQd3ADyeCDb6fELT4O+kYu8Xd54cZ
	LeYfOcdq0f9mIavFuVcrGS0eNK1isuhdcJXN4mzTG3aLTY+vsVosbFvCYjHvyDsWi8u75rBZ
	zDi/j8li6fWLTBYTpq9lsXh7ZzqLReveI+wW62e8ZnEQ8lgzbw2jx+9fkxg9Lvf1MnmsXP6F
	zWPzCi2PTas6gYwl9R59W1YxenzeJBfAGdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZg
	qGtoaWGupJCXmJtqq+TiE6DrlpkD9JCSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILge
	IwM0kLCGMeP/+TmMBfMlKl4svcPUwPhasIuRk0NCwETiesdkJghbTOLCvfVsXYxcHEIC0xkl
	ek8cZYVwXjNKPD//CMjh4OAV0JI4t94TpIFFQFXix/w7jCA2G1B4/4sbbCC2qECYxMrpV1hA
	bF4BQYkfk++B2SICihJTXzxjBpnJLHCAWeLXm4fMIAlhgUyJCYf+Qm1ewCjRM+kmE8gyTgFN
	id/vFEFqmAV0JPa3TmODsOUlNq95yzyBUWAWkh2zkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZwonkmvYNxVYPFIUYBDkYlHl6Lm8eDhVgTy4orcw8xSnAwK4nwZt8HCvGm
	JFZWpRblxxeV5qQWH2I0BQbBRGYp0eR8YBLMK4k3NDYxM7I0Mje0MDI2VxLnPdhqHSgkkJ5Y
	kpqdmlqQWgTTx8TBKdXAGPL/1o9PMus+/2BZHv4guDlG8IRI9I9ejojLM6f+ckmoDe/ddvgE
	y+Plx73e/HncdYy75PJpJ53OowuUvlxfIniqqXfCzvTAqyV1PT2bZl35WVJak2L2Q3eLRFC2
	LH/G23i7n8f1/y8Xlyza3CxcwOXieyjafF3si/RFS1hOm9pIPPkobrRpghJLcUaioRZzUXEi
	AP5ggHxKAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 07/18/2014 06:47 PM, Arnd Bergmann wrote:
> On Friday 18 July 2014 14:59:44 Chanwoo Choi wrote:
>> This patch control special clock for ADC in Exynos series's FSYS block.
>> If special clock of ADC is registerd on clock list of common clk framework,
>> Exynos ADC drvier have to control this clock.
>>
>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>> - 'adc' clock: bus clock for ADC
>>
>> Exynos3250 has additional 'sclk_adc' clock as following:
>> - 'sclk_adc' clock: special clock for ADC which provide clock to internal ADC
>>
>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_adc' clock
>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_adc'
>> clock in FSYS_BLK.
> 
> Do you know if any of the older ADC blocks have an "sclk" input as well?

No, I didn't check older ADC blocks. I only checked it on Exynos3250,
Exynos4210/4212/4412, Exynos5250/5420.

> 
> Further, why is it called "sclk_adc" rather than just "sclk"?

The sclk means 'special clock' in Exynos TRM. Exynos SoC has varisou sclk clocks.
'sclk_adc' is only used for ADC IP.

> 
>> @@ -199,13 +262,20 @@ static void exynos_adc_v2_start_conv(struct exynos_adc *info,
>>         writel(con1 | ADC_CON_EN_START, ADC_V2_CON1(info->regs));
>>  }
>>  
>> +#define __EXYNOS_ADC_V2_DATA                           \
>> +       .num_channels   = MAX_ADC_V2_CHANNELS,          \
>> +       .init_hw        = exynos_adc_v2_init_hw,        \
>> +       .exit_hw        = exynos_adc_v2_exit_hw,        \
>> +       .clear_irq      = exynos_adc_v2_clear_irq,      \
>> +       .start_conv     = exynos_adc_v2_start_conv,     \
>> +
>>  static struct exynos_adc_data const exynos_adc_v2_data = {
>> -       .num_channels   = MAX_ADC_V2_CHANNELS,
>> +       __EXYNOS_ADC_V2_DATA
>> +};
>>  
>> -       .init_hw        = exynos_adc_v2_init_hw,
>> -       .exit_hw        = exynos_adc_v2_exit_hw,
>> -       .clear_irq      = exynos_adc_v2_clear_irq,
>> -       .start_conv     = exynos_adc_v2_start_conv,
>> +static struct exynos_adc_data const exynos3250_adc_v2_data = {
>> +       __EXYNOS_ADC_V2_DATA
>> +       .needs_sclk = true,
>>  };
> 
> I think the macro hurts readability. Please just duplicate the definition
> here.

OK, I'll fix it.

> 
>>  static const struct of_device_id exynos_adc_match[] = {
>> @@ -215,6 +285,9 @@ static const struct of_device_id exynos_adc_match[] = {
>>         }, {
>>                 .compatible = "samsung,exynos-adc-v2",
>>                 .data = (void *)&exynos_adc_v2_data,
>> +       }, {
>> +               .compatible = "samsung,exynos3250-adc-v2",
>> +               .data = (void *)&exynos3250_adc_v2_data,
>>         },
>>         {},
> 
> Remove the '(void *)' cast here and mark the structure as 'const'.
> We intentionally use a 'const void *' type here to verify that
> the driver doesn't modify the per-device type data at runtime,
> which would be bad if you ever have multiple device instances.

OK, I'll remove it.

Thanks,
Chanwoo Choi


