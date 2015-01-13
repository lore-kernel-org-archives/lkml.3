Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbbAMIz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:55:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42723 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbAMIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:55:25 -0500
X-AuditID: cbfee691-f79b86d000004a5a-f8-54b4dd7a6001
Message-id: <54B4DD7A.504@samsung.com>
Date: Tue, 13 Jan 2015 17:55:22 +0900
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
Subject: Re: [PATCHv3 1/8] devfreq: exynos: Add generic exynos memory bus
 frequency driver
References: <520952065.968311421138534993.JavaMail.weblogic@epmlwas05d>
In-reply-to: <520952065.968311421138534993.JavaMail.weblogic@epmlwas05d>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkQLfq7pYQg/5ubYvHaxYzWWycsZ7V
	YtL9CSwWr18YWvQ/fs1scbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRxu3EFm8Xj
	FW/ZLVr3HmG3WLXrD6MDv8eaeWsYPXbOusvusXjPSyaPTas62Tw2L6n36NuyitHj8ya5APYo
	LpuU1JzMstQifbsErozTp96wFFyUrVhwegtTA+N98S5GTg4JAROJ6yu3sEPYYhIX7q1n62Lk
	4hASWMooMW1yBztM0dXmn0wQiUWMErOOvmWFcF4zSlyau5ARpIpXQE3i+f89TCA2i4CqxL6j
	q8FsNgEtif0vbrCB2KICYRIrp19hgagXlPgx+R6YLSIgI3F143YWkKHMAr1sEu/WL2IGSQgL
	xEh03b8NtkBIwF3i455uMJtTwEOiZdclMJtZQF1i0jyIemYBeYnNa94yQ5w9lUNiYxsjxEEC
	Et8mHwJawAEUl5XYdACqRFLi4IobLBMYxWYhOWkWkqmzkExdwMi8ilE0tSC5oDgpvchUrzgx
	t7g0L10vOT93EyMwsk//ezZxB+P9A9aHGAU4GJV4eHdkbwkRYk0sK67MPcRoCnTFRGYp0eR8
	YPrIK4k3NDYzsjA1MTU2Mrc0UxLn1ZH+GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcVuJ
	7YcPj9qyRaZcfLnhsmVOxOPdf6tZmwvm3eeU4lHM/PPs8cOp7IWP21f4LzzVvE6qV34K16XJ
	DcwmIYEmfk3NDAkWH+o+6ypKsisKnOXgOdQg8i1Qd33o/MVs04Tnt1ryxnxmy97Neqhu4ZWb
	HCviEkSTJ98/7ZKXXnBl+j+PaiV9jYX7lViKMxINtZiLihMBThUg++cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jAd2qu1tCDJoPKVo8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bFrVyeaxeUm9R9+WVYwenzfJBbBH
	NTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDdraRQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMOH3qDUvBRdmKBae3MDUw3hfv
	YuTkkBAwkbja/JMJwhaTuHBvPVsXIxeHkMAiRolZR9+yQjivGSUuzV3ICFLFK6Am8fz/HrAO
	FgFViX1HV4PZbAJaEvtf3GADsUUFwiRWTr/CAlEvKPFj8j0wW0RARuLqxu0sIEOZBXrZJN6t
	X8QMkhAWiJHoun8bbIGQgLvExz3dYDangIdEy65LYDazgLrEpHkQ9cwC8hKb17xlnsAoMAvJ
	jllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhxPJPewbiqweIQowAHoxIP
	r0DelhAh1sSy4srcQ4wSHMxKIrzzbwOFeFMSK6tSi/Lji0pzUosPMZoCg2Ais5Rocj4wqeWV
	xBsam5gZWRqZG1oYGZsrifMq2beFCAmkJ5akZqemFqQWwfQxcXBKNTBOfdctvaaLaabkEtGC
	S3079jy24RRWnT7HbUdu46IOg005+UwyHwWS3q3iNWX88WuLyyx58e/PKgoKXujOYJEs2ZPm
	yLpd8uqbsOb7Zbt2vlY/euzQ2S09P9wXr5ATrHs55/HaFz6Vf3fdsVi2wPbiGW3b7XNVKyyd
	1x1UL5y24d/aV4HupsarlFiKMxINtZiLihMBdtZGPjIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

On 01/13/2015 05:42 PM, MyungJoo Ham wrote:
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
>>  drivers/devfreq/Kconfig          |  15 +
>>  drivers/devfreq/Makefile         |   1 +
>>  drivers/devfreq/exynos-busfreq.c | 589 +++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 605 insertions(+)
>>  create mode 100644 drivers/devfreq/exynos-busfreq.c
> 
> Exynos drivers are located at drivers/devfreq/exynos/
> Please relocate/rename exynos-busfreq.c

OK. I'll move it at drivers/devfreq/exynos directory.
Do you prefer 'exynos-bus.c' instead of 'exynos-busfreq.c'?
If you reply, I'll change it.

> 
> []
> 
>> diff --git a/drivers/devfreq/exynos-busfreq.c b/drivers/devfreq/exynos-busfreq.c
>> new file mode 100644
>> index 0000000..b180f43
>> --- /dev/null
>> +++ b/drivers/devfreq/exynos-busfreq.c
> 
> []
> 
>> +
>> +#define BUS_SATURATION_RATIO	40
> 
> In order to be a common driver, this should be tunable.
> 
> Because .dts is supposed to have hardware configuration only,
> you may keep a table of { chip-name, saturation ratio} in this
> driver and look up the saturation ratio based on the chip-name.

OK, I'll add new property for saturation_ratio.

I'll implement to use default saturation_ratio value ,
if dt node don't include saturation_ratio property.

> 
>> +#define SAFEVOLT		50000
>> +
>> +struct exynos_memory_bus_opp_info {
>> +	unsigned long rate;
>> +	unsigned long volt;
>> +};
>> +
>> +struct exynos_memory_bus_block {
>> +	struct clk *clk;
>> +	struct exynos_memory_bus_opp_info *freq_table;
>> +};
>> +
> 
> []
> 
>> +#ifdef CONFIG_PM_SLEEP
>> +static int exynos_busfreq_resume(struct device *dev)
>> +{
>> +	struct exynos_memory_bus_data *data = dev_get_drvdata(dev);
>> +	int ret;
>> +
>> +	ret = exynos_busfreq_enable_edev(data);
>> +	if (ret < 0) {
>> +		dev_err(dev, "failed to enable the devfreq-event devices\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int exynos_busfreq_suspend(struct device *dev)
>> +{
>> +	struct exynos_memory_bus_data *data = dev_get_drvdata(dev);
>> +	int ret;
>> +
>> +	ret = exynos_busfreq_disable_edev(data);
>> +	if (ret < 0) {
>> +		dev_err(dev, "failed to disable the devfreq-event devices\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +#endif
> 
> Please disable regulator at suspend and resume it at resume.
> 
> You may interfere with low-power mode of corresponding voltage line,
> which is often implemented to be activated if the regulator is
> explicitely disabled for "alive" regulators like this one.

OK, I'll modify it.

Thanks for your review.

Best Regards,
Chanwoo Choi
