Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbbAMImV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:42:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16658 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbbAMImT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:42:19 -0500
X-AuditID: cbfee68d-f79296d000004278-86-54b4da6a8546
Date: Tue, 13 Jan 2015 08:42:18 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv3 1/8] devfreq: exynos: Add generic exynos memory bus
 frequency driver
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>
Cc: =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150113074916899@myungjoo.ham
Msgkey: 20150113074916899@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150113074916899@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <520952065.968311421138534993.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkUDfr1pYQg64pohaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjZUNJwTqdiontW5kbGGdodzFycggJqEssWnKSDcSWEDCR+Hf0
	MTOELSZx4d56oDgXUM1SRom2Lw3MMEXvrq5lhkjMYZTYu7OXHSTBIqAqsWLVJJYuRg4ONgE9
	iZmfk0HCwgJREl9v/wRbICKQJ3Hl7gxGkF5mgR42iY6r35khrlCSWLPvFQuIzSsgKHFy5hOw
	ORJAM1/tMIQIq0k8Xv4Y6lBxiQtzL7FD2LwSM9qfskDYchLTvq6BulNa4vysDYwwzyz+DvMY
	v8Sx2zuYIGwBialnDjJCrNKSODvTBSLMJ7Fm4VsWmPJdp5Yzw6y6v2UuVKuExNaWJ6wgNrOA
	osSU7ofsIGOYBTQl1u/SR/UIiO0u8XruDXBwSghM5ZD4tXoL0wRGpVlI6mYhGTULYRSykgWM
	LKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAlPC6X/Pencw3j5gfYhRgINRiYd3R/aWECHW
	xLLiytxDjKbAOJrILCWanA9MPHkl8YbGZkYWpiamxkbmlmZK4ryKUj+DhQTSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTBObNz8iP/MzXsind+NjgZz2ldverDb8Brfo0MKetnZMiHvr5h9/Sgc
	cTNPUuOOfX7OU5V/nL3sfy4p/mycd/F45r9/n9XOxU5aluTHsTayNP/qO+/Lyn+MFmqVl7x3
	zQ0wOerx5PPHqWc268sW/n/2L0N1YdG72vk7GvKnnN/t77VhxdbVP/5UK7EUZyQaajEXFScC
	APK64m8EAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t/tPt2sW1tCDOb94bS4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRkv
	G0oK1ulUTGzfytzAOEO7i5GTQ0hAXWLRkpNsILaEgInEu6trmSFsMYkL99YDxbmAauYwSuzd
	2csOkmARUJVYsWoSSxcjBwebgJ7EzM/JIGFhgSiJr7d/gs0REciTuHJ3BiNIL7NAD5tEx9Xv
	zBDLlCTW7HvFAmLzCghKnJz5BGyOBNDMVzsMIcJqEo+XP4a6R1ziwtxL7BA2r8SM9qcsELac
	xLSva6DulJY4P2sDI8zNi78/horzSxy7vYMJwhaQmHrmICPEKi2JszNdIMJ8EmsWvmWBKd91
	ajkzzKr7W+ZCtUpIbG15wgpiMwsoSkzpfsgOMoZZQFNi/S59VI+A2O4Sr+feYJvAKDsLSWoW
	ku5ZCN3IShYwsqxiFE0tSC4oTkqvMNErTswtLs1L10vOz93ECE4/z5bsYGy4YH2IUYCDUYmH
	d0f2lhAh1sSy4srcQ4wSHMxKIrx2c4BCvCmJlVWpRfnxRaU5qcWHGE2BMTaRWUo0OR+YGvNK
	4g2NjU3MTEwtTSwMTM2VxHn/n8sNERJITyxJzU5NLUgtgulj4uCUamBs/Djza5SB6h9Ohnjd
	ynNPJa1jd5zcrm73yd5p5Uv5P4HLt79e0efkrr9ny+b/0iuqOF4KlV0S7ZywKvjzWoMLTsa5
	aRscnpvvuFs+Z8rfuo1uf97pbfXmkjgVlSQinHCivEG7sXTpXOf4ts/3I5dVH7LnLn1hyXck
	8vbnr/e59q+7F1ZSs0tIiaU4I9FQi7moOBEAcoOKKVUDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0D8gR4r026246

>   
>  This patch adds the generic exynos bus frequency driver for memory bus
> with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
> for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
> support the memory bus frequency driver for Exynos SoCs.
> 
> Each memory bus block has a clock for memory bus speed and frequency
> table which is changed according to the utilization of memory bus on runtime.
> And then each memory bus group has the one more memory bus blocks and
> OPP table (including frequency and voltage), regulator, devfreq-event
> devices.
> 
> There are a little difference about the number of memory bus because each Exynos
> SoC have the different sub-IP and different memory bus speed. In spite of this
> difference among Exynos SoCs, we can support almost Exynos SoC by adding
> unique data of memory bus to devicetree file.
> 
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Kukjin Kim <kgene@kernel.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/Kconfig          |  15 +
>  drivers/devfreq/Makefile         |   1 +
>  drivers/devfreq/exynos-busfreq.c | 589 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 605 insertions(+)
>  create mode 100644 drivers/devfreq/exynos-busfreq.c

Exynos drivers are located at drivers/devfreq/exynos/
Please relocate/rename exynos-busfreq.c

[]

> diff --git a/drivers/devfreq/exynos-busfreq.c b/drivers/devfreq/exynos-busfreq.c
> new file mode 100644
> index 0000000..b180f43
> --- /dev/null
> +++ b/drivers/devfreq/exynos-busfreq.c

[]

> +
> +#define BUS_SATURATION_RATIO	40

In order to be a common driver, this should be tunable.

Because .dts is supposed to have hardware configuration only,
you may keep a table of { chip-name, saturation ratio} in this
driver and look up the saturation ratio based on the chip-name.

> +#define SAFEVOLT		50000
> +
> +struct exynos_memory_bus_opp_info {
> +	unsigned long rate;
> +	unsigned long volt;
> +};
> +
> +struct exynos_memory_bus_block {
> +	struct clk *clk;
> +	struct exynos_memory_bus_opp_info *freq_table;
> +};
> +

[]

> +#ifdef CONFIG_PM_SLEEP
> +static int exynos_busfreq_resume(struct device *dev)
> +{
> +	struct exynos_memory_bus_data *data = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = exynos_busfreq_enable_edev(data);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to enable the devfreq-event devices\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int exynos_busfreq_suspend(struct device *dev)
> +{
> +	struct exynos_memory_bus_data *data = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = exynos_busfreq_disable_edev(data);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to disable the devfreq-event devices\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +#endif

Please disable regulator at suspend and resume it at resume.

You may interfere with low-power mode of corresponding voltage line,
which is often implemented to be activated if the regulator is
explicitely disabled for "alive" regulators like this one.

> +
> +static const struct dev_pm_ops exynos_busfreq_pm = {
> +	SET_SYSTEM_SLEEP_PM_OPS(exynos_busfreq_suspend, exynos_busfreq_resume)
> +};
> +
> +static const struct of_device_id exynos_busfreq_of_match[] = {
> +	{ .compatible = "samsung,exynos-memory-bus", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, exynos_busfreq_of_match);
> +
> +static struct platform_driver exynos_busfreq_platdrv = {
> +	.probe		= exynos_busfreq_probe,
> +	.remove		= exynos_busfreq_remove,
> +	.driver = {
> +		.name	= "exynos-memory-bus",
> +		.owner	= THIS_MODULE,
> +		.pm	= &exynos_busfreq_pm,
> +		.of_match_table = of_match_ptr(exynos_busfreq_of_match),
> +	},
> +};
> +module_platform_driver(exynos_busfreq_platdrv);
> +
> +MODULE_DESCRIPTION("Generic Exynos Memory Bus Frequency driver");
> +MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
> +MODULE_LICENSE("GPL v2");
> -- 
> 1.8.5.5
> 
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
