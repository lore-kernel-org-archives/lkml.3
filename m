Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbbASJU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:20:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12381 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbASJUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:20:24 -0500
X-AuditID: cbfee68d-f79296d000004278-04-54bccc51c3fa
Date: Mon, 19 Jan 2015 09:20:17 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4 1/9] devfreq: exynos: Add generic exynos memory bus
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
X-MTR: 20150119091320775@myungjoo.ham
Msgkey: 20150119091320775@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150119091320775@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <27342443.1253691421659213933.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkQDfwzJ4Qg7tb+S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG9/m/LAXbZCpWvp3E3sB4RbqLkZNDSEBdYtGSk2xdjBwcEgIm
	EosvaYGEJQTEJC7cWw8U5gIqWcoo0XF0FyNEwkTi68YOFojEHEaJncsfM4EkWARUJZZvusgC
	MohNQE9i5udkkLCwQLTE4y0n2EBsEYE8iSt3ZzCC9DIL9LBJdFz9zgxxhJLEmn2vWEBsXgFB
	iZMzn7BALFOVeLl1GzNEXE2iZfVSqCPEJS7MvcQOYfNKzGh/ClUvJzHt6xpmCFta4vysDYww
	3yz+/hgqzi9x7PYOJghbQGLqmYNQNVoSBzZNgarhk1iz8C0LTP2uU8uZYXbd3zIXqldCYmvL
	E1YQm1lAUWJK90N2kN+ZBTQl1u/SR/cKr4C7xIKpP8HhJiEwlUOi9eYj9gmMSrOQ1M1CMmoW
	wihkJQsYWVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBKaF0/+e9e5gvH3A+hCjAAejEg/v
	Bt89IUKsiWXFlbmHGE2BsTSRWUo0OR+YfPJK4g2NzYwsTE1MjY3MLc2UxHkVpX4GCwmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamDsEw5oTTvRPjn01izJ6KSiRL60S4u+XU4rltF7tlBcfcuX
	9Uze3nfn6JWuZFOy8bxwsJyXof2Iyc6bcYHnS77NXDPzhPncZsPbxdc2FPbxuxTviV64Rnrp
	tosaR9j3rFnQHru31frt7CuhpTYrN3GfTH56q3hTZdq0NQmsPI92NdmEmX8Sm2SgxFKckWio
	xVxUnAgAdSQrIQYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t/tPt3AM3tCDNbO5LC4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRnd
	5/+yFGyTqVj5dhJ7A+MV6S5GTg4hAXWJRUtOsoHYEgImEl83drBA2GISF+6tB4pzAdXMYZTY
	ufwxE0iCRUBVYvmmi0BFHBxsAnoSMz8ng4SFBaIlHm85ATZHRCBP4srdGYwgvcwCPWwSHVe/
	M0MsU5JYs+8V2AJeAUGJkzOfQC1TlXi5dRszRFxNomX1UkaIuLjEhbmX2CFsXokZ7U+h6uUk
	pn1dwwxhS0ucn7WBEeboxd8fQ8X5JY7d3sEEYQtITD1zEKpGS+LApilQNXwSaxa+ZYGp33Vq
	OTPMrvtb5kL1SkhsbXnCCmIzCyhKTOl+yA7yO7OApsT6XfroXuEVcJdYMPUnywRG2VlIUrOQ
	dM9C6EZWsoCRZRWjaGpBckFxUnqFsV5xYm5xaV66XnJ+7iZGcBJ6tngH4//z1ocYBTgYlXh4
	N/juCRFiTSwrrsw9xCjBwawkwsu3HijEm5JYWZValB9fVJqTWnyI0RQYZxOZpUST84EJMq8k
	3tDY2MTMxNTSxMLA1FxJnPf/udwQIYH0xJLU7NTUgtQimD4mDk6pBsbGkD+mxj1lKZMS/nk0
	P2/uLLC7JiiWKrtBZovA2QtCQpl9L1zmVr/3XFr5cz7L9nmTfzxxsue6sWrZqqTMqMde0U+W
	3wh5eC1cdQFDuGAkI7fBYvHpnBst27/yRl5ZUPHo7KGgqLvxqU6zP567k81frntm6k7u7nNt
	wmz/tVvnKv9vvHv12SklluKMREMt5qLiRABnspm3WAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J9Kagi001675

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
>  drivers/devfreq/Kconfig             |  15 +
>  drivers/devfreq/Makefile            |   1 +
>  drivers/devfreq/exynos/Makefile     |   1 +
>  drivers/devfreq/exynos/exynos-bus.c | 598 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 615 insertions(+)
>  create mode 100644 drivers/devfreq/exynos/exynos-bus.c
> 

[]

> +static void exynos_bus_exit(struct device *dev)
> +{
> +	struct exynos_memory_bus *bus = dev_get_drvdata(dev);
> +	int i, ret;
> +
> +	ret = exynos_bus_disable_edev(bus);
> +	if (ret < 0)
> +		dev_warn(dev, "failed to disable the devfreq-event devices\n");
> +
> +	for (i = 0; i < bus->block_count; i++)
> +		clk_disable_unprepare(bus->block[i].clk);
> +
> +	if (regulator_is_enabled(bus->regulator))
> +		regulator_disable(bus->regulator);

This is_enabled check is itchy.

Why do you need this here?
Please let me know what kind of errors here.
(note that this may simply hide errors made by other drivers)

Adding this condition does not introduce additional error, but
could you please let me know why it is here? This is supposed to be
paired with probe.


Except this point (valid if addressed or {explained and understood}),
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


Cheers,
MyungJoo

> +
> +	of_free_opp_table(dev);
> +}
> +
> +static struct devfreq_dev_profile exynos_memory_bus_profile = {
> +	.polling_ms	= 100,
> +	.target		= exynos_bus_target,
> +	.get_dev_status	= exynos_bus_get_dev_status,
> +	.exit		= exynos_bus_exit,
> +};
> +

[]
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
