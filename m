Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaDYFnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:43:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17792 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaDYFnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:43:20 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-bb-5359f5f60af7
Message-id: <5359F5F5.7030109@samsung.com>
Date: Fri, 25 Apr 2014 14:43:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: kgene.kim@samsung.com, t.figa@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org, arnd@arndb.de,
        olof@lixom.net, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        sachin.kamat@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv4 3/7] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
 <1398388572-30239-4-git-send-email-cw00.choi@samsung.com>
 <5359E4E6.90102@linaro.org>
In-reply-to: <5359E4E6.90102@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsWyRsSkRPfb18hgg/tLxC3+TjrGbjFp3QEm
	i8v7tS3mHznHavH5QwtQ6P4EFoveBVfZLM42vWG32PT4GqvF5V1z2CxmnN/HZHH7Mq/F3zv/
	2CxOXf/MZnHyTy+jxZPDH1ktZkx+yWaxfsZrFotjM5YwWrT/3ctmsXfnZEYHUY8189YwerQ0
	97B5/P41idHj76oXzB47Z91l97hzbQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABXFJdNSmpOZllq
	kb5dAlfGiSdN7AW3+Cru/u9jbWC8zt3FyMkhIWAiMevqQlYIW0ziwr31bF2MXBxCAksZJQ5/
	+coIU/Tg3Q12iMQiRoknDy8zQTivGSUOXd0A1s4roCXRsvESE4jNIqAq0fbvOjuIzQYU3//i
	BhuILSoQJrFy+hUWiHpBiR+T74HZIgI6Eg8W7WUBGcos8JdZ4tXBj2CrhQUCJG69ncQCsW0+
	o8S6Xf+ZQRKcAhoSj17PA9vGDNS9v3UaG4QtL7F5zVtmiLtvcEi03DaBuEhA4tvkQ0CDOIDi
	shKbDkCVSEocXHGDZQKj2CwkN81CMnUWkqkLGJlXMYqmFiQXFCelFxnrFSfmFpfmpesl5+du
	YgSmjNP/nvXvYLx7wPoQYzLQyonMUqLJ+cCUk1cSb2hsZmRhamJqbGRuaUaasJI47/2HSUFC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGIsZZsdUrTt62SZFTIkt++6PBekJx2faBbmwlBk6
	LuJMKJ6yz1Ny8ZSJEnfaJicIsfUfDedtNTR3/XVu4uzjaZnrTwr9v84yz2iuUtqiXwd3CywM
	0uaqmat7NXdpnvTs/Mubg8033j16ovVOvMSTd/zBT/cEzFH6zPNG+1LGnZhFp3ccfXHfwE+J
	pTgj0VCLuag4EQB5+2xyLwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsVy+t9jAd1vXyODDXqW8Fr8nXSM3WLSugNM
	Fpf3a1vMP3KO1eLzhxag0P0JLBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyeL2ZaDOO//Y
	LE5d/8xmcfJPL6PFk8MfWS1mTH7JZrF+xmsWi2MzljBatP/dy2axd+dkRgdRjzXz1jB6tDT3
	sHn8/jWJ0ePvqhfMHjtn3WX3uHNtD5vH5iX1HldONLF69G1ZxejxeZNcAFdUA6NNRmpiSmqR
	Qmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCPSgpliTmlQKGAxOJi
	JX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaME0+a2Atu8VXc/d/H2sB4nbuLkZNDQsBE4sG7
	G+wQtpjEhXvr2boYuTiEBBYxSjx5eJkJwnnNKHHo6gZWkCpeAS2Jlo2XmEBsFgFVibZ/18G6
	2YDi+1/cYAOxRQXCJFZOv8ICUS8o8WPyPTBbREBH4sGivSwgQ5kF/jJLvDr4kREkISwQIHHr
	7SQWiG3zGSXW7frPDJLgFNCQePR6Htg2ZqDu/a3T2CBseYnNa94yT2AUmIVkySwkZbOQlC1g
	ZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZySnknvYFzVYHGIUYCDUYmHd4JsZLAQa2JZ
	cWXuIUYJDmYlEV7lVUAh3pTEyqrUovz4otKc1OJDjMnAMJjILCWanA9Ml3kl8YbGJmZGlkbm
	hhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLj0ScLMkHXL+uvfXUwKK/jPszHm
	33nfRqOXvwz27lee4vpnX9+L/YWcmp42+3cttMplmHo3O/u2HdtOxfINjBraqVWO79vvRiXG
	fFax2Sv4+LLirw3zFye0CsrcPFM4Z8d+zaZvX3cI/uYy1qu7HMJTdqxH4tkj7mOmEx5uzovL
	T+GxnmHTx6HEUpyRaKjFXFScCAALR37HjQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/25/2014 01:30 PM, Tushar Behera wrote:
> On 04/25/2014 06:46 AM, Chanwoo Choi wrote:
>> This patch fix the offset of CPU boot address and don't need to send smc call
>> of SMC_CMD_CPU1BOOT command for secondary CPU boot because Exynos3250 removes
>> WFE in secure mode.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/firmware.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
>> index aa01c42..386d01d 100644
>> --- a/arch/arm/mach-exynos/firmware.c
>> +++ b/arch/arm/mach-exynos/firmware.c
>> @@ -31,11 +31,17 @@ static int exynos_do_idle(void)
>>  static int exynos_cpu_boot(int cpu)
>>  {
>>  	/*
>> +	 * Exynos3250 doesn't need to send smc command for secondary CPU boot
>> +	 * because Exynos3250 removes WFE in secure mode.
>> +	 */
>> +	if (soc_is_exynos3250())
>> +		return 0;
>> +	/*
>>  	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
>>  	 * But, Exynos4212 has only one secondary CPU so second parameter
>>  	 * isn't used for informing secure firmware about CPU id.
>>  	 */
>> -	if (soc_is_exynos4212())
>> +	else if (soc_is_exynos4212())
> 
> This changes is not required.

Do you mean it as following?

	if (soc_is_exynos3250())
		return 0

	if (soc_is_exynos4212())
		cpu = 0;

> 
>>  		cpu = 0;
>>  
>>  	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
>> @@ -46,7 +52,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
>>  {
>>  	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
>>  
>> -	if (!soc_is_exynos4212())
>> +	if (!soc_is_exynos4212() && !soc_is_exynos3250())
>>  		boot_reg += 4*cpu;
>>  
>>  	__raw_writel(boot_addr, boot_reg);
>>
> 
> 

