Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbbAGLRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:17:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21898 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbbAGLRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:17:38 -0500
X-AuditID: cbfee68d-f79296d000004278-29-54ad15d05aeb
Message-id: <54AD15E5.5070803@samsung.com>
Date: Wed, 07 Jan 2015 16:47:57 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        linux-kernel@vger.kernel.org, Vivek Gautam <gautam.vivek@samsung.com>,
        kernel@pengutronix.de, Lee Jones <lee.jones@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH] mfd: syscon: fix syscon probing from dt
References: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
 <35536202.10QfWIDQqq@wuerfel> <1420628264.3191.27.camel@pengutronix.de>
In-reply-to: <1420628264.3191.27.camel@pengutronix.de>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWyRsSkRveC6NoQgxsLZS3+TjrGbtF25SC7
	xf9Hr1ktjv4usFg1dSeLxf2vRxktLu+aw2Zx994JFovT3awWq3b9YXTg8vj9axKjx9/n11k8
	ds66y+5x59oeNo95JwM9+v8aePRtWcXosf3aPGaPz5vkAjijuGxSUnMyy1KL9O0SuDLaftxk
	LWjSr+jfcJitgXGmWhcjJ4eEgIlEz/Z3zBC2mMSFe+vZuhi5OIQEljJKPHt5nh2maNv/J1CJ
	6YwS66fPYYJwWpkkPr/eDFbFK6AlcaTpOiOIzSKgKjHj6mQWEJtNQFfiyfu5YCtEBSIkPqz6
	ygZRLyjxY/I9sBoRAU+J9R/WsoMMZRbYzCSxdNU7sKHCAjYSe85eZYTYNoFRYuKy22AJTgEz
	ifetr8C2MQPZX14eZoWw5SU2r3nLDNIgIfCTXWLr7vksECcJSHybfAjI5gBKyEpsOgD1tKTE
	wRU3WCYwis1CctQsJGNnIRm7gJF5FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZg7J7+96x3
	B+PtA9aHGAU4GJV4eAv61oQIsSaWFVfmHmI0BbpiIrOUaHI+MEHklcQbGpsZWZiamBobmVua
	KYnzKkr9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaF70/JqE0mHOScL3p0VXS+y/x8KW
	L+J9I2mJ/7Lr3Spn9UtWF0RkZGsa8kaHGEw9tTfo8WslnRfieuflSmKn+i3zdH2hKr+D9/jx
	5vnPAibUihbwz33dFXbKyHL/9v0bfl3QD/f4mTbNYe/Whg8fhe2LZ4fEFC35IsgWY1o9TyJe
	3Dd84XE/JZbijERDLeai4kQAao1W4tgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoO4F0bUhBpc2CFv8nXSM3aLtykF2
	i/+PXrNaHP1dYLFq6k4Wi/tfjzJaXN41h83i7r0TLBanu1ktVu36w+jA5fH71yRGj7/Pr7N4
	7Jx1l93jzrU9bB7zTgZ69P818OjbsorRY/u1ecwenzfJBXBGNTDaZKQmpqQWKaTmJeenZOal
	2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCdqaRQlphTChQKSCwuVtK3wzQhNMRN
	1wKmMULXNyQIrsfIAA0krGHMaPtxk7WgSb+if8NhtgbGmWpdjJwcEgImEtv+P2GDsMUkLtxb
	D2RzcQgJTGeUWD99DhOE08ok8fn1ZnaQKl4BLYkjTdcZQWwWAVWJGVcns4DYbAK6Ek/ez2UG
	sUUFIiQ+rPrKBlEvKPFj8j2wGhEBT4n1H9aygwxlFtjMJLF01TuwocICNhJ7zl5lhNg2gVFi
	4rLbYAlOATOJ962vwLYxA9lfXh5mhbDlJTavecs8gVFgFpIls5CUzUJStoCReRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGcGJ4JrWDcWWDxSFGAQ5GJR7egr41IUKsiWXFlbmHGCU4mJVE
	eN/8AgrxpiRWVqUW5ccXleakFh9iNAWGwURmKdHkfGDSyiuJNzQ2MTc1NrU0sTAxs1QS51Wy
	bwsREkhPLEnNTk0tSC2C6WPi4JRqYFx6RIJXYG9PrrlqKzevSMiE4OzzsVc3h8jLvJ9692wR
	t4GC/LITKW68m5VPV+cZ3DC0ipXsPbgmysPWt8E1ffXqZazrA14prhH8Kq652i/Y8dmT2b++
	CHpa2cacfm8jFviNTeqS8bTE2be3H8h8N3vjoXeF7A9uvvnx54TNXZkkeV37pPK5CUosxRmJ
	hlrMRcWJAEGtHVciAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Wednesday 07 January 2015 04:27 PM, Philipp Zabel wrote:
> Am Dienstag, den 06.01.2015, 20:36 +0100 schrieb Arnd Bergmann:
>> On Tuesday 06 January 2015 16:30:36 Philipp Zabel wrote:
>>> Patch bdb0066df96e ("mfd: syscon: Decouple syscon interface from platform devices")
>>> breaks probing pure syscon devices from device tree, such as anatop and
>>> iomuxc-gpr on i.MX. This patch adds back the dt id table to match against
>>> "syscon" compatible device tree nodes.
>>>
>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>>
>>
>> I don't understand it. Why is this required?
>
> The debugfs entries vanished and I'd like to have a device to register
> platform device children to.

Yes debugfs entries will not be present for syscon, this is as per 
discussion happened here [1]. At that time one suggestion came from Arnd 
that we can have a different representation for syscon regmaps, instead 
of based on devices just based on of_node pointer.

1: https://lkml.org/lkml/2014/9/26/73

I was just thinking, missing debugfs entry is your concern, or you want 
to make child devices of syscon devices? Basically I am still trying to 
understand your requirement.

I guess for i.MX iomuxc it could be argued
> that the iomuxc-gpr syscon should be merged into the iomuxc pinctrl
> device instead of probing iomuxc-gpr as a platform device by itself.
> How about allowing to register a syscon for a given device:
>
> ----8<----
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index d2280d6..2633b27 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -42,13 +42,14 @@ static struct regmap_config syscon_regmap_config = {
>   	.reg_stride = 4,
>   };
>
> -static struct syscon *of_syscon_register(struct device_node *np)
> +struct syscon *syscon_register(struct device *dev, struct device_node *np)
>   {
>   	struct syscon *syscon;
>   	struct regmap *regmap;
>   	void __iomem *base;
>   	int ret;
>   	struct regmap_config syscon_config = syscon_regmap_config;
> +	struct resource res;
>
>   	if (!of_device_is_compatible(np, "syscon"))
>   		return ERR_PTR(-EINVAL);
> @@ -57,7 +58,12 @@ static struct syscon *of_syscon_register(struct device_node *np)
>   	if (!syscon)
>   		return ERR_PTR(-ENOMEM);
>
> -	base = of_iomap(np, 0);
> +	if (of_address_to_resource(np, 0, &res)) {
> +		ret = -ENOMEM;
> +		goto err_map;
> +	}
> +
> +	base = ioremap(res.start, resource_size(&res));
>   	if (!base) {
>   		ret = -ENOMEM;
>   		goto err_map;
> @@ -69,7 +75,8 @@ static struct syscon *of_syscon_register(struct device_node *np)
>   	 else if (of_property_read_bool(np, "little-endian"))
>   		syscon_config.val_format_endian = REGMAP_ENDIAN_LITTLE;
>
> -	regmap = regmap_init_mmio(NULL, base, &syscon_config);
> +	syscon_regmap_config.max_register = res.end - res.start - 3;
> +	regmap = regmap_init_mmio(dev, base, &syscon_config);
>   	if (IS_ERR(regmap)) {
>   		pr_err("regmap init failed\n");
>   		ret = PTR_ERR(regmap);
> @@ -91,6 +98,12 @@ err_map:
>   	kfree(syscon);
>   	return ERR_PTR(ret);
>   }
> +EXPORT_SYMBOL_GPL(syscon_register);
> +

In past a similar approach [2] for letting device driver to register 
themselves as syscon provided, has been rejected giving reason that 
syscon should not need it's own platform device.

2: 
https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35744.html


Thanks,
Pankaj Dubey
> +static struct syscon *of_syscon_register(struct device_node *np)
> +{
> +	return syscon_register(NULL, np);
> +}
>
>   struct regmap *syscon_node_to_regmap(struct device_node *np)
>   {
> diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
> index 75e543b..e0c4a86 100644
> --- a/include/linux/mfd/syscon.h
> +++ b/include/linux/mfd/syscon.h
> @@ -17,10 +17,14 @@
>
>   #include <linux/err.h>
>
> +struct device;
>   struct device_node;
> +struct syscon;
>
>   #ifdef CONFIG_MFD_SYSCON
>   extern struct regmap *syscon_node_to_regmap(struct device_node *np);
> +extern struct syscon *syscon_register(struct device *dev,
> +				      struct device_node *np);
>   extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
>   extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
>   extern struct regmap *syscon_regmap_lookup_by_phandle(
> @@ -32,6 +36,12 @@ static inline struct regmap *syscon_node_to_regmap(struct device_node *np)
>   	return ERR_PTR(-ENOSYS);
>   }
>
> +static struct syscon *syscon_register(struct device *dev,
> +				      struct device_node *np)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
> +
>   static inline struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
>   {
>   	return ERR_PTR(-ENOSYS);
> --
> ---->8----
>
> That way the syscon could be registered from iomuxc (pinctrl-imx6q):
>
> ----8<----
> diff --git a/drivers/pinctrl/freescale/pinctrl-imx6q.c b/drivers/pinctrl/freescale/pinctrl-imx6q.c
> index 4d1fcb8..74a68ec 100644
> --- a/drivers/pinctrl/freescale/pinctrl-imx6q.c
> +++ b/drivers/pinctrl/freescale/pinctrl-imx6q.c
> @@ -15,6 +15,7 @@
>   #include <linux/err.h>
>   #include <linux/init.h>
>   #include <linux/io.h>
> +#include <linux/mfd/syscon.h>
>   #include <linux/module.h>
>   #include <linux/of.h>
>   #include <linux/of_device.h>
> @@ -473,6 +474,12 @@ static const struct of_device_id imx6q_pinctrl_of_match[] = {
>
>   static int imx6q_pinctrl_probe(struct platform_device *pdev)
>   {
> +	struct device_node *syscon_np;
> +
> +	syscon_np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-iomuxc-gpr");
> +	if (syscon_np)
> +		syscon_register(&pdev->dev, syscon_np);
> +
>   	return imx_pinctrl_probe(pdev, &imx6q_pinctrl_info);
>   }
>
> ---->8----
>
> which makes the regmap debugfs entry return
> as /sys/kernel/debug/regmap/20e0000.iomuxc
> and allows to register children to the iomuxc-gpr node.
>
> regards
> Philipp
>
>
