Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaCTEHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:07:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40343 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaCTEHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:07:10 -0400
X-AuditID: cbfee690-b7f266d00000287c-28-532a693e22ed
Message-id: <532A6D33.7080301@samsung.com>
Date: Thu, 20 Mar 2014 13:23:15 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/4] drivers: clk: use CONFIG_COMMON_CLK_SAMSUNG for
 Samsung clock support
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
 <1394598781-3848-3-git-send-email-pankaj.dubey@samsung.com>
 <53298B26.8020400@samsung.com>
In-reply-to: <53298B26.8020400@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zfV27TK1ggxV/2Sw2Pb7GanF51xw2
	ixnn9zFZrJ/xmsWBxWPzknqPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvjato2xYDpfxcaJ
	n9gbGJdxdzFyckgImEj8ampmhbDFJC7cW8/WxcjFISSwjFGi5/dGRpiiXX1bmEBsIYHpjBK/
	JxRDFL1mlNixexZYEa+AlsT0NSdYQGwWAVWJyXfns4PYbAK6Ek/ez2UGsUUFwiQ2Te9jhagX
	lPgx+R5YvYiAisTlU9PB5jALZEsc+bIFrFdYIFli7qbX7HAXLe//B9bMKaAt0dT4jgWiwVpi
	5aRtUM3yEpvXvGUGaZAQWMUu0XbpDDPERQIS3yYfAmrgAErISmw6wAzxmaTEwRU3WCYwis1C
	ctMsJGNnIRm7gJF5FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZIFE3YwXjvgPUhxmSglROZ
	pUST84FRmFcSb2hsZmRhamJqbGRuaUaasJI4r9qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjEkqJvPu8S/gXbxvypZgf6lZzpZeHCFJ35xtnL6KC/3bxHuV2SlDvPLVBH2tf2u/bJCQ
	4p+szX/skdhcg8B5jtc6Epz7b7PcfzKzIOmdZsCtaPNXtzdm7p+y+bDT/wOta5t4Ax99eHBs
	1vL9OdYXJti2rypbuvG2ZOs/xTlzHj5b8XrL1Mk/n/cqsRRnJBpqMRcVJwIADYLEurgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoK5dplawwaa3TBabHl9jtbi8aw6b
	xYzz+5gs1s94zeLA4rF5Sb1H35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZ8bdvGWDCdr2LjxE/sDYzLuLsYOTkkBEwkdvVtYYKwxSQu3FvPBmILCUxn
	lPg9obiLkQvIfs0osWP3LEaQBK+AlsT0NSdYQGwWAVWJyXfns4PYbAK6Ek/ez2UGsUUFwiQ2
	Te9jhagXlPgx+R5YvYiAisTlU9PB5jALZEsc+bIFrFdYIFli7qbX7BDLljFKLO//B9bMKaAt
	0dT4jgWiwVpi5aRtUM3yEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjOEafSe1gXNlgcYhRgINRiYd3xR7NYCHWxLLiytxDjBIczEoivNbuWsFCvCmJ
	lVWpRfnxRaU5qcWHGJOBQTCRWUo0OR+YPvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCe
	WJKanZpakFoEs4WJg1OqgXHh+eY3lf5Xlz7eO+EZT+bxJe2KW3Zc8zVcGhW0YO2BNctOfypr
	kOOed3ujCadY0vP1KRsLF8+7+7VHrEe2M/f4fL+/1QH6O56zT2rl3zdJmOfSEcujiTFvNjpe
	vc3m/PqWXrjXMnb9tfstnniXi8VnaRe07TyU7C/3m3+zXvas4vcRffKPDzxSYinOSDTUYi4q
	TgQAbUhIPhUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 09:18 PM, Tomasz Figa wrote:
> Hi Pankaj,
>
> On 12.03.2014 05:32, Pankaj Dubey wrote:
>> This patch includes Samsung clock Kconfig file, and replaces PLAT_SAMSUNG
>> with COMMON_CLK_SAMSUNG for Samsung common clock support.
>> Any Samsung SoC want to use Samsung common clock infrastructure can simply
>> select COMMON_CLK_SAMSUNG.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   drivers/clk/Kconfig  |    2 ++
>>   drivers/clk/Makefile |    2 +-
>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>> index 7641965..f2b6179 100644
>> --- a/drivers/clk/Kconfig
>> +++ b/drivers/clk/Kconfig
>> @@ -112,3 +112,5 @@ source "drivers/clk/qcom/Kconfig"
>>   endmenu
>>
>>   source "drivers/clk/mvebu/Kconfig"
>> +
>> +source "drivers/clk/samsung/Kconfig"
>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>> index a367a98..f1da6ee 100644
>> --- a/drivers/clk/Makefile
>> +++ b/drivers/clk/Makefile
>> @@ -38,7 +38,7 @@ obj-$(CONFIG_PLAT_ORION)        += mvebu/
>>   obj-$(CONFIG_ARCH_MXS)            += mxs/
>>   obj-$(CONFIG_COMMON_CLK_QCOM)        += qcom/
>>   obj-$(CONFIG_ARCH_ROCKCHIP)        += rockchip/
>> -obj-$(CONFIG_PLAT_SAMSUNG)        += samsung/
>> +obj-$(CONFIG_COMMON_CLK_SAMSUNG)    += samsung/
>>   obj-$(CONFIG_ARCH_SHMOBILE_MULTI)    += shmobile/
>>   obj-$(CONFIG_ARCH_SIRF)            += sirf/
>>   obj-$(CONFIG_ARCH_SOCFPGA)        += socfpga/
>>
>
> This patch makes samsung/ subdirectory compile depending on 
> CONFIG_COMMON_CLK_SAMSUNG, but nothing selects it yet and thus breaking 
> bisection.
>
> Best regards,
> Tomasz
>

Thanks for review.
OK, I will take care of this in next revision.

-- 
Best Regards,
Pankaj Dubey

