Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaIAE1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 00:27:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47807 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaIAE1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 00:27:21 -0400
X-AuditID: cbfee68f-f797f6d000001173-b7-5403f5a69973
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, arnd@arndb.de,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        "'Tomasz Figa'" <t.figa@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
References: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com>
Subject: RE: [PATCH] mfd: syscon: Decouple syscon interface from syscon devices
Date: Mon, 01 Sep 2014 09:58:55 +0530
Message-id: <000501cfc59d$5c717330$15545990$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHpa/2m/d4/OY0ITARCUM8RI+G5jZu4X+Bg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkWnfZV+YQg6Zv8hZ/Jx1jt1g26S6b
	xfddX9gtehdcZbO4//Uoo8Wmx9dYLS7vmsNmMeP8PiaL25d5LT4d/c9qsX7GaxaLjmWMFqt2
	/WG0uPlsO5MDn0dLcw+bx+9fkxg9ds66y+5x59oeNo/NS+o9+rasYvT4vEkugD2KyyYlNSez
	LLVI3y6BK+PawsNMBSccK35+F2pgXGjaxcjJISFgIrH2ykpWCFtM4sK99WxdjFwcQgJLGSWe
	dL9nhyma2ziNBcQWEpjOKHHgfxJE0V9Gic/Tn4IVsQnoSjx5P5cZxBYRyJbov72aBaSIWWAR
	k8SHac+ZILo9JM7OmscGYnMKeEqcv9UCZgsL+Et8ubcYrJlFQFWicWYnI4jNK2Ap8ah7LQuE
	LSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZIS5VkNhx9jUjxBFGEpfOdDBC1IhLTHrwkB3kIAmB
	hRwSDXv+QC0TkPg2+RDQUA6ghKzEpgNQcyQlDq64wTKBUWIWktWzkKyehWT1LCQrFjCyrGIU
	TS1ILihOSi8y1itOzC0uzUvXS87P3cQITAmn/z3r38F494D1IUYBDkYlHt4Hs5hDhFgTy4or
	cw8xmgJdNJFZSjQ5H5h48kriDY3NjCxMTUyNjcwtzZTEeRdK/QwWEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwOj+9vyUePNnTttZWv+fTf6seX319YL13h+/3lGLYNjAwCb5d26LRJGwpNe9
	s0rv1gtOXfX5tsPmNV/D808u+TPnbLDX02JnK4vdwY5vw3YfVOhR2fsj+gtXxqXXqZ9XaVTP
	sP4htSLUK3qGpJH1oRUzX2YJc2kc/vf1beekq2kT/nTVlK3S9/2lxFKckWioxVxUnAgAz6z0
	5gQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQd1lX5lDDJbMFbX4O+kYu8WySXfZ
	LL7v+sJu0bvgKpvF/a9HGS02Pb7GanF51xw2ixnn9zFZ3L7Ma/Hp6H9Wi/UzXrNYdCxjtFi1
	6w+jxc1n25kc+DxamnvYPH7/msTosXPWXXaPO9f2sHlsXlLv0bdlFaPH501yAexRDYw2GamJ
	KalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKymUJeaUAoUC
	EouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzri08zFRwwrHi53ehBsaFpl2MnBwSAiYS
	cxunsUDYYhIX7q1nA7GFBKYzShz4n9TFyAVk/2WU+Dz9KTtIgk1AV+LJ+7nMILaIQLZE/+3V
	LCBFzAKLmCQ+THvOBNHtIXF21jywSZwCnhLnb7WA2cIC/hJf7i0Ga2YRUJVonNnJCGLzClhK
	POpeywJhC0r8mHwPzGYW0JJYv/M4E4QtL7F5zVtmiEsVJHacfc0IcYSRxKUzHYwQNeISkx48
	ZJ/AKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCE84z6R2M
	qxosDjEKcDAq8fA+mMUcIsSaWFZcmXuIUYKDWUmE98hpoBBvSmJlVWpRfnxRaU5q8SFGU6BP
	JzJLiSbnA5NhXkm8obGJuamxqaWJhYmZpZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGRqEW
	g1WVARH3tLdylCrrbO2UKgzgbavpCEpf6njzVusSTb4vpi3XZy8x1rf4HdAqt1y09qrnBbcy
	/XPWUX11tfzqnFbL8g59XW7SleHn9d7h+BWV3Q0NK502mCk+uCcy2+jvjl3WMXG3NzAmu79l
	ESvZc5g5yHzR9fiOJ6zfGK9+qu1/s0VFiaU4I9FQi7moOBEAYQ0S8U4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I forgot to add maintainer into CC. 

+Lee Jones

Any comments on this patch. 
As a lot of Exynos PMU patch sets are dependent on this patch.

Thanks,
Pankaj Dubey
	

> -----Original Message-----
> From: Pankaj Dubey [mailto:pankaj.dubey@samsung.com]
> Sent: Friday, August 22, 2014 1:40 PM
> To: linux-arm-kernel@lists.infradead.org;
linux-samsung-soc@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: kgene.kim@samsung.com; linux@arm.linux.org.uk; arnd@arndb.de;
> vikas.sajjan@samsung.com; joshi@samsung.com; naushad@samsung.com;
> thomas.ab@samsung.com; chow.kim@samsung.com; Tomasz Figa; Pankaj Dubey
> Subject: [PATCH] mfd: syscon: Decouple syscon interface from syscon
devices
> 
> From: Tomasz Figa <t.figa@samsung.com>
> 
> Currently a syscon entity can be only registered directly through a
platform device
> that binds to a dedicated driver. However in certain use cases it is
desirable to make a
> device used with another driver a syscon interface provider. For example,
certain
> SoCs (e.g. Exynos) contain system controller blocks which perform various
functions
> such as power domain control, CPU power management, low power mode
control,
> but in addition contain certain IP integration glue, such as various
signal masks,
> coprocessor power control, etc. In such case, there is a need to have a
dedicated
> driver for such system controller but also share registers with other
drivers. The latter
> is where the syscon interface is helpful.
> 
> This patch decouples syscon object from syscon driver, so that it can be
registered
> from any driver in addition to the original "syscon" platform driver.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
> 
> RFC patch [1] was posted by Tomasz Figa. This patch addresses some of
comments
> given by Arnd to RFC patch, and further decouples syscon from device
model. It also
> gives flexibility of registering with syscon at early stage using
device_node object.
> 
> [1]: https://lkml.org/lkml/2014/6/17/331
> 
>  drivers/mfd/syscon.c       |  112 ++++++++++++++++++++++++++++----
> ------------
>  include/linux/mfd/syscon.h |   14 ++++++
>  2 files changed, 86 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c index
ca15878..a91db30
> 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -14,6 +14,7 @@
> 
>  #include <linux/err.h>
>  #include <linux/io.h>
> +#include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> @@ -22,33 +23,32 @@
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/mfd/syscon.h>
> +#include <linux/slab.h>
> 
> -static struct platform_driver syscon_driver;
> +static DEFINE_SPINLOCK(syscon_list_slock);
> +static LIST_HEAD(syscon_list);
> 
>  struct syscon {
> +	struct device_node *np;
>  	struct regmap *regmap;
> +	struct list_head list;
>  };
> 
> -static int syscon_match_node(struct device *dev, void *data) -{
> -	struct device_node *dn = data;
> -
> -	return (dev->of_node == dn) ? 1 : 0;
> -}
> -
>  struct regmap *syscon_node_to_regmap(struct device_node *np)  {
> -	struct syscon *syscon;
> -	struct device *dev;
> +	struct syscon *entry, *syscon = NULL;
> 
> -	dev = driver_find_device(&syscon_driver.driver, NULL, np,
> -				 syscon_match_node);
> -	if (!dev)
> -		return ERR_PTR(-EPROBE_DEFER);
> +	spin_lock(&syscon_list_slock);
> 
> -	syscon = dev_get_drvdata(dev);
> +	list_for_each_entry(entry, &syscon_list, list)
> +		if (entry->np == np) {
> +			syscon = entry;
> +			break;
> +		}
> 
> -	return syscon->regmap;
> +	spin_unlock(&syscon_list_slock);
> +
> +	return syscon ? syscon->regmap : ERR_PTR(-EPROBE_DEFER);
>  }
>  EXPORT_SYMBOL_GPL(syscon_node_to_regmap);
> 
> @@ -68,24 +68,22 @@ struct regmap
> *syscon_regmap_lookup_by_compatible(const char *s)  }
> EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> 
> -static int syscon_match_pdevname(struct device *dev, void *data) -{
> -	return !strcmp(dev_name(dev), (const char *)data);
> -}
> -
>  struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)  {
> -	struct device *dev;
> -	struct syscon *syscon;
> -
> -	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> -				 syscon_match_pdevname);
> -	if (!dev)
> -		return ERR_PTR(-EPROBE_DEFER);
> -
> -	syscon = dev_get_drvdata(dev);
> +	struct syscon *entry, *syscon = NULL;
> +	struct platform_device *pdev = NULL;
> +
> +	spin_lock(&syscon_list_slock);
> +	list_for_each_entry(entry, &syscon_list, list) {
> +		 pdev = of_find_device_by_node(entry->np);
> +		if (pdev && !strcmp(dev_name(&pdev->dev), s)) {
> +			syscon = entry;
> +			break;
> +		}
> +	}
> +	spin_unlock(&syscon_list_slock);
> 
> -	return syscon->regmap;
> +	return syscon ? syscon->regmap : ERR_PTR(-EPROBE_DEFER);
>  }
>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
> 
> @@ -121,17 +119,49 @@ static struct regmap_config syscon_regmap_config = {
>  	.reg_stride = 4,
>  };
> 
> +void of_syscon_unregister(struct device_node *np) {
> +	struct syscon *entry;
> +
> +	spin_lock(&syscon_list_slock);
> +
> +	list_for_each_entry(entry, &syscon_list, list)
> +		if (entry->np == np) {
> +			list_del(&entry->list);
> +			break;
> +		}
> +
> +	spin_unlock(&syscon_list_slock);
> +}
> +EXPORT_SYMBOL_GPL(of_syscon_unregister);
> +
> +int of_syscon_register(struct device_node *np, struct regmap *regmap) {
> +	struct syscon *syscon;
> +
> +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> +	if (!syscon)
> +		return -ENOMEM;
> +
> +	syscon->regmap = regmap;
> +	syscon->np = np;
> +
> +	spin_lock(&syscon_list_slock);
> +	list_add_tail(&syscon->list, &syscon_list);
> +	spin_unlock(&syscon_list_slock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_syscon_register);
> +
>  static int syscon_probe(struct platform_device *pdev)  {
>  	struct device *dev = &pdev->dev;
>  	struct syscon_platform_data *pdata = dev_get_platdata(dev);
> -	struct syscon *syscon;
> +	struct regmap *regmap;
>  	struct resource *res;
>  	void __iomem *base;
> -
> -	syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
> -	if (!syscon)
> -		return -ENOMEM;
> +	int ret;
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res)
> @@ -144,14 +174,16 @@ static int syscon_probe(struct platform_device
*pdev)
>  	syscon_regmap_config.max_register = res->end - res->start - 3;
>  	if (pdata)
>  		syscon_regmap_config.name = pdata->label;
> -	syscon->regmap = devm_regmap_init_mmio(dev, base,
> +	regmap = devm_regmap_init_mmio(dev, base,
>  					&syscon_regmap_config);
> -	if (IS_ERR(syscon->regmap)) {
> +	if (IS_ERR(regmap)) {
>  		dev_err(dev, "regmap init failed\n");
> -		return PTR_ERR(syscon->regmap);
> +		return PTR_ERR(regmap);
>  	}
> 
> -	platform_set_drvdata(pdev, syscon);
> +	ret = of_syscon_register(dev->of_node, regmap);
> +	if (ret)
> +		return ret;
> 
>  	dev_dbg(dev, "regmap %pR registered\n", res);
> 
> diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h index
> 75e543b..dc2807b 100644
> --- a/include/linux/mfd/syscon.h
> +++ b/include/linux/mfd/syscon.h
> @@ -18,8 +18,12 @@
>  #include <linux/err.h>
> 
>  struct device_node;
> +struct regmap;
> 
>  #ifdef CONFIG_MFD_SYSCON
> +extern int of_syscon_register(struct device_node *np, struct regmap
> +*regmap); extern void of_syscon_unregister(struct device_node *np);
> +
>  extern struct regmap *syscon_node_to_regmap(struct device_node *np);
extern
> struct regmap *syscon_regmap_lookup_by_compatible(const char *s);  extern
struct
> regmap *syscon_regmap_lookup_by_pdevname(const char *s); @@ -27,6 +31,16
> @@ extern struct regmap *syscon_regmap_lookup_by_phandle(
>  					struct device_node *np,
>  					const char *property);
>  #else
> +static inline int of_syscon_register(struct device_node *np,
> +				       struct regmap *regmap)
> +{
> +	return -ENOSYS;
> +}
> +
> +static inline void of_syscon_unregister(struct device_node *np) { }
> +
>  static inline struct regmap *syscon_node_to_regmap(struct device_node
*np)  {
>  	return ERR_PTR(-ENOSYS);
> --
> 1.7.9.5

