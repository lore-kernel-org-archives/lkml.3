Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbbASJgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:36:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42533 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbASJgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:36:33 -0500
X-AuditID: cbfee68f-f791c6d000004834-8a-54bccfdf1c50
Message-id: <54BCCFDF.5040305@samsung.com>
Date: Mon, 19 Jan 2015 18:35:27 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v4 1/9] devfreq: exynos: Add generic exynos memory bus
 frequency driver
References: <27342443.1253691421659213933.JavaMail.weblogic@epmlwas05d>
In-reply-to: <27342443.1253691421659213933.JavaMail.weblogic@epmlwas05d>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkUPf++T0hBr8um1s8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bFrVyeaxeUm9R9+WVYwenzfJBbBH
	cdmkpOZklqUW6dslcGVMO/KcveCaSMWr5fuYGxiPCHQxcnJICJhIXNj+hA3CFpO4cG89kM3F
	ISSwlFHi4YxLrDBFs65tYYdITGeU2PGhgwnCec0ocfvJdiCHg4NXQEti8uNKkAYWAVWJl08P
	M4HYbEDh/S9ugG0QFQiTWDn9CguIzSsgKPFj8j0wW0RARuLqxu0sIDOZBXrZJN6tX8QMkhAW
	iJW4N3kDI4gtJOAu0TS1mQ1kF6eAh0TnbyGQMLOAusSkeRDlzALyEpvXvGUGmSMhMJND4mr/
	KiaIgwQkvk0+xALSKyEgK7HpADPEY5ISB1fcYJnAKDYLyUmzkIydhWTsAkbmVYyiqQXJBcVJ
	6UXGesWJucWleel6yfm5mxiBcX3637P+HYx3D1gfYhTgYFTi4d3guydEiDWxrLgy9xCjKdAV
	E5mlRJPzgckjryTe0NjMyMLUxNTYyNzSTEmcd6HUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjJ3++SuFz4aJS07j4flwulbylurqRs+5V4qSc4ISw8uUpyhO36qyetOkY+uYmW8VORqJ
	q95g17Jfvm9uZeO3k3NXLcmXOzHF642G0AXNFmeZmYltLSaXfyvwxb+3C75vzb6huHNi35pG
	q/pNf4T0j9z87vIo7+cD/XeVqlMZaurWi7q5SdffVWIpzkg01GIuKk4EANiiizrmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd375/eEGPz5rWfxeM1iJouNM9az
	Wky6P4HF4vULQ4v+x6+ZLc42vWG32PT4GqvF5V1z2Cw+9x5htJhxfh+TxdLrF5ksbjeuYLN4
	vOItu0Xr3iPsFqt2/WF04PdYM28No8fOWXfZPRbvecnksWlVJ5vH5iX1Hn1bVjF6fN4kF8Ae
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0t5JC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY9qR5+wF10QqXi3fx9zAeESg
	i5GTQ0LARGLWtS3sELaYxIV769m6GLk4hASmM0rs+NDBBOG8ZpS4/WQ7kMPBwSugJTH5cSVI
	A4uAqsTLp4eZQGw2oPD+FzfYQGxRgTCJldOvsIDYvAKCEj8m3wOzRQRkJK5u3M4CMpNZoJdN
	4t36RcwgCWGBWIl7kzcwgthCAu4STVOb2UB2cQp4SHT+FgIJMwuoS0yaB1HOLCAvsXnNW+YJ
	jAKzkKyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCk8YzqR2MKxssDjEK
	cDAq8fByBOwJEWJNLCuuzD3EKMHBrCTCy7ceKMSbklhZlVqUH19UmpNafIjRFBgCE5mlRJPz
	gQktryTe0NjEzMjSyNzQwsjYXEmcV8m+LURIID2xJDU7NbUgtQimj4mDU6qBUadf7HWHZulr
	tr3ynW15aoKrTqzKsmjKfhfUt+wja8ySd/d+ZMwU4PHafO3eolMHvvzbXebaYn6374yfV93V
	18eFNVwuido9m2s08cSapx3T9N6ef6KYs1bt1hlBp5XPVPM9vwpPlDRYpu98Yrmdq8k0C2/2
	aL3vkuzsKxJLJwcuX8z+8xwbixJLcUaioRZzUXEiANlg82swAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

On 01/19/2015 06:20 PM, MyungJoo Ham wrote:
>>   
>>  This patch adds the generic exynos bus frequency driver for memory bus
>> with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
>> for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
>> support the memory bus frequency driver for Exynos SoCs.
>>
>> Each memory bus block has a clock for memory bus speed and frequency
>> table which is changed according to the utilization of memory bus on runtime.
>> And then each memory bus group has the one more memory bus blocks and
>> OPP table (including frequency and voltage), regulator, devfreq-event
>> devices.
>>
>> There are a little difference about the number of memory bus because each Exynos
>> SoC have the different sub-IP and different memory bus speed. In spite of this
>> difference among Exynos SoCs, we can support almost Exynos SoC by adding
>> unique data of memory bus to devicetree file.
>>
>> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Kukjin Kim <kgene@kernel.org>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/devfreq/Kconfig             |  15 +
>>  drivers/devfreq/Makefile            |   1 +
>>  drivers/devfreq/exynos/Makefile     |   1 +
>>  drivers/devfreq/exynos/exynos-bus.c | 598 ++++++++++++++++++++++++++++++++++++
>>  4 files changed, 615 insertions(+)
>>  create mode 100644 drivers/devfreq/exynos/exynos-bus.c
>>
> 
> []
> 
>> +static void exynos_bus_exit(struct device *dev)
>> +{
>> +	struct exynos_memory_bus *bus = dev_get_drvdata(dev);
>> +	int i, ret;
>> +
>> +	ret = exynos_bus_disable_edev(bus);
>> +	if (ret < 0)
>> +		dev_warn(dev, "failed to disable the devfreq-event devices\n");
>> +
>> +	for (i = 0; i < bus->block_count; i++)
>> +		clk_disable_unprepare(bus->block[i].clk);
>> +
>> +	if (regulator_is_enabled(bus->regulator))
>> +		regulator_disable(bus->regulator);
> 
> This is_enabled check is itchy.
> 
> Why do you need this here?
> Please let me know what kind of errors here.
> (note that this may simply hide errors made by other drivers)
> 
> Adding this condition does not introduce additional error, but
> could you please let me know why it is here? This is supposed to be
> paired with probe.

The regulator_is_enabled() is not necessary according to your comment.
I'll remove it.

> 
> 
> Except this point (valid if addressed or {explained and understood}),
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Thanks for your review.

Best Regards,
Chanwoo Choi

