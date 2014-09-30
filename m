Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbaI3EEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:04:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48022 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaI3EEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:04:43 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-ac-542a2bd80eb0
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "=?iso-8859-1?Q?'Heiko_St=FCbner'?=" <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de, b29396@freescale.com,
        lee.jones@linaro.org, boris.brezillon@free-electrons.com,
        tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        kgene.kim@samsung.com, Li.Xiubo@freescale.com, geert+renesas@glider.be,
        swarren@nvidia.com, linux-rockchip@lists.infradead.org
References: <1411980458-32329-1-git-send-email-pankaj.dubey@samsung.com>
 <1617081.XFKIz4hM4O@phil>
In-reply-to: <1617081.XFKIz4hM4O@phil>
Subject: RE: [PATCH v6] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Tue, 30 Sep 2014 09:33:38 +0530
Message-id: <000d01cfdc63$99576bb0$cc064310$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFY72dYauXnyKTIQTnx2v0J1//RogIyfzmPnPVRStA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+e9cdpwOTsvlv6ElA/ugaanT/mqIHzIOCV1QJPyicx5U8rI2
	lSIqQyubtzkVY14w0jIphLnyQsSaKUlYmuY1b7W0FLS0vE/bPAV++/G+z/s8z4eXwkTVhIRK
	TstgVWnyFCkpwJ86y254j3h5Rh3v80JWXRcfTbcV48j0/QGOqit1AO18mSdQYe0nEk3+6QTo
	Xm8egQxfBwnU315FoqWpHQzd//CKh8b6hWipc4dAwxW5BMp7BFBj+xZAIzMtvDARk5tTQDKb
	GzrAWAx9gNnuKOYxJT3eTJt+nM98HnxJMs11N5nCnAWSKTI2AqZlsAZjlg2HzjvFCE4msCnJ
	WazqWGicICnvcT6pNIZe+djci2eDel8NcKAgLYO/n/XwOD4AeyeaSA0QUCK6HkDLQAH/v6jp
	dhlmZxFdAaD1p5gTWQEcHc8h7AuS9oaWxepdkTON4ORa0a4TRndjsGahhsddJ8Bftx4COzvQ
	R+CidW13vp+OhqbhIdLOOO0Bl7cqdk2FdBCcKxjFON4H10oncDtj9FFYuLqCcewFLQu9BNfU
	Hbb2zAOuRDBc7hj7p3eBuqlpvr0QpC0UNM6VAy6MhiulZpuIsi3coMGEcT4H4euGYVwLoH5P
	tH5PtH5PtH5PRC3AG4GYVSqU6vhElcxHLU9VZ6Yl+ijSUw3A9jXvtme0rWDCFGIGNAWkTkLq
	sGeUiJBnqa+mmkGArVEJJhEr0m2PlpYR6+sf6IcCZAH+fieCAqUuwnnJeqSITpRnsJdYVsmq
	YlWZKazaDHiUgyQbJCQLLmi70qNzN3IcK/nd38J8tsNdB8K9sOch70nXh8r8aJEwu+Fu45tu
	XdVE+ezsHelmfEVt6xOp0j2yJdKKr86aDRsXL58zxoV2DTSfctO80IrLXaKCQXaror1MXFpz
	+lpM2/UfyyXdEYqVSsczYXXNQw0eRqvm7WLS+lmfCCmuTpL7emIqtfwv/8VzJzADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jQd0b2lohBgtbjSz+TjrGbvFwZz+L
	xYEXC1ks5s6exGjx/9FrVoveBVfZLO5/Pcpo0Xmhg9Vi0+NrrBaXd81hs/j04D+zxYzz+5gs
	bl/mtfh09D+rxY3pLawWHcsYLVbt+sNocfPZdiYHIY+W5h42j9+/JjF6PNl0kdHj3+F+Jo+J
	Z3U9ds66y+5x59oeNo/NS+o9epvfsXn0bVnF6LH92jxmj8+b5AJ4ohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAvlNSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYwZnQs72Yr2GJXcWnzBZYGxqWGXYycHBICJhLrW6cwQ9hi
	EhfurWcDsYUEpjNK/P0g2sXIBWT/ZZS4dbeZFSTBJqAr8eT9XLAGEQELifs/+thAipgFTjJL
	zHs3jwmiO0XiY+NiRhCbU0BN4v3fH2BxYYEwiQM3roNtYBFQlfj8ZzrYUF4BS4lXPbeYIWxB
	iR+T77GA2MwCOhK9378xQ9jaEk/eXWCFuFRBYsfZ14wQR1hJfD58G6peXGLSg4fsExiFZiEZ
	NQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAqeya1g3Flg8UhRgEO
	RiUeXg55rRAh1sSy4srcQ4wSHMxKIrx8mkAh3pTEyqrUovz4otKc1OJDjKZAn05klhJNzgem
	2bySeENjE3NTY1NLEwsTM0slcd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYxb7fzKcr0jq/73
	vRA6u+TG48a611Of9DbPuVHpFnZWr6En/2l9k2/q59qT25O/rn038Z7cXZ1zohpTpmTvCt1s
	s+/npT/d56o5TWr4WXdMFrAsKtZnTlp4UmwVV+Wn08+MAlRPGMzo2s+/SETpy5HGqHeHpC5l
	yZyo0Lxon3NfM0TDLF3fZbYSS3FGoqEWc1FxIgAw+bchewMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, September 29, 2014 9:38 PM, Heiko Stübner wrote,
> Am Montag, 29. September 2014, 14:17:38 schrieb Pankaj Dubey:
> > Currently a syscon entity can be only registered directly through a
> > platform device that binds to a dedicated syscon driver. However in
> > certain use cases it is desirable to make a device used with another
> > driver a syscon interface provider.
> >
> > For example, certain SoCs (e.g. Exynos) contain system controller
> > blocks which perform various functions such as power domain control,
> > CPU power management, low power mode control, but in addition contain
> > certain IP integration glue, such as various signal masks, coprocessor
> > power control, etc. In such case, there is a need to have a dedicated
> > driver for such system controller but also share registers with other
> > drivers. The latter is where the syscon interface is helpful.
> >
> > In case of DT based platforms, this patch decouples syscon object from
> > syscon platform driver, and allows to create syscon objects first time
> > when it is required by calling of syscon_regmap_lookup_by APIs and
> > keep a list of such syscon objects along with syscon provider
> > device_nodes and regmap handles.
> >
> > For non-DT based platforms, this patch keeps syscon platform driver
> > structure where is can be probed and such non-DT based drivers can use
> > syscon_regmap_lookup_by_pdev API and get access to regmap handles.
> > Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> > we can completely remove platform driver of syscon, and keep only
> > helper functions to get regmap handles.
> >
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> > Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> 
> On Rockchip boards during core clock init (aka before timers)
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> 

Thanks for testing.

> Except one issue described inline below
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> 
> 
> And I'm really looking forward to having this in the kernel :-)
> 
> Thanks for working on this
> Heiko
> 
> 

[snip]

> >
> >  drivers/mfd/syscon.c |  106
> > +++++++++++++++++++++++++++++++++++++++----------- 1 file
> changed, 84
> > insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c index
> > ca15878..00a8410 100644
> > --- a/drivers/mfd/syscon.c
> > +++ b/drivers/mfd/syscon.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/err.h>
> >  #include <linux/io.h>
> >  #include <linux/module.h>
> > +#include <linux/list.h>
> >  #include <linux/of.h>
> >  #include <linux/of_address.h>
> >  #include <linux/of_platform.h>
> > @@ -22,31 +23,104 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/regmap.h>
> >  #include <linux/mfd/syscon.h>
> > +#include <linux/slab.h>
> >
> >  static struct platform_driver syscon_driver;
> >
> > +static DEFINE_SPINLOCK(syscon_list_slock);
> > +static LIST_HEAD(syscon_list);
> > +
> >  struct syscon {
> > +	struct device_node *np;
> >  	struct regmap *regmap;
> > +	struct list_head list;
> > +};
> > +
> > +static struct regmap_config syscon_regmap_config = {
> > +	.reg_bits = 32,
> > +	.val_bits = 32,
> > +	.reg_stride = 4,
> >  };
> >
> > -static int syscon_match_node(struct device *dev, void *data)
> > +static struct syscon *of_syscon_register(struct device_node *np)
> >  {
> > -	struct device_node *dn = data;
> > +	struct syscon *syscon;
> > +	struct regmap *regmap;
> > +	void __iomem *base;
> > +	int ret;
> > +	enum regmap_endian endian = REGMAP_ENDIAN_DEFAULT;
> > +
> > +	if (!of_device_is_compatible(np, "syscon"))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> > +	if (!syscon)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	base = of_iomap(np, 0);
> > +	if (!base) {
> > +		ret = -ENOMEM;
> > +		goto err_map;
> > +	}
> > +
> > +	/* Parse the device's DT node for an endianness specification */
> > +	if (of_property_read_bool(np, "big-endian"))
> > +		endian = REGMAP_ENDIAN_BIG;
> > +	 else if (of_property_read_bool(np, "little-endian"))
> > +		endian = REGMAP_ENDIAN_LITTLE;
> > +
> > +	/* If the endianness was specified in DT, use that */
> > +	if (endian != REGMAP_ENDIAN_DEFAULT)
> > +		syscon_regmap_config.val_format_endian = endian;
> > +
> > +	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> > +	if (IS_ERR(regmap)) {
> > +		pr_err("regmap init failed\n");
> > +		ret = PTR_ERR(regmap);
> > +		goto err_regmap;
> > +	}
> > +
> > +	syscon->regmap = regmap;
> > +	syscon->np = np;
> > +
> > +	spin_lock(&syscon_list_slock);
> > +	list_add_tail(&syscon->list, &syscon_list);
> > +	spin_unlock(&syscon_list_slock);
> >
> > -	return (dev->of_node == dn) ? 1 : 0;
> > +	/* Change back endianness of syscon_regmap_config.
> > +	 * As this is static config in this file and in one system we may
> > +	 * have more than one syscon
> > +	 */
> > +	syscon_regmap_config.val_format_endian =
> REGMAP_ENDIAN_DEFAULT;
> 
> This should also be done in the error case. Currently when you goto
err_regmap the
> overridden value will be left in the struct.
> 

Thanks, will handle this in error condition also.

> While on this, is there a concurrency issue here, aka of_syscon_register
could be
> called in parallel and what happens with
syscon_regmap_config.val_format_endian
> then?

I can think of two approaches to solve this.

1: Updating syscon_regmap_config, under spin_lock "syscon_list_slock".
2: Creation of local copy of syscon_regmap_config in "of_syscon_register"
and using 
it. In this case changing back of endianness in syscon_regmap_config, will
not be needed
and code will be a bit cleaner.

I would prefer second one, what is your opinion?

Thanks,
Pankaj Dubey

> 
> 
> > +
> > +	return syscon;
> > +
> > +err_regmap:
> > +	iounmap(base);
> > +err_map:
> > +	kfree(syscon);
> > +	return ERR_PTR(ret);
> >  }
> >
> >  struct regmap *syscon_node_to_regmap(struct device_node *np)  {
> > -	struct syscon *syscon;
> > -	struct device *dev;
> > +	struct syscon *entry, *syscon = NULL;
> >
> > -	dev = driver_find_device(&syscon_driver.driver, NULL, np,
> > -				 syscon_match_node);
> > -	if (!dev)
> > -		return ERR_PTR(-EPROBE_DEFER);
> > +	spin_lock(&syscon_list_slock);
> >
> > -	syscon = dev_get_drvdata(dev);
> > +	list_for_each_entry(entry, &syscon_list, list)
> > +		if (entry->np == np) {
> > +			syscon = entry;
> > +			break;
> > +		}
> > +
> > +	spin_unlock(&syscon_list_slock);
> > +
> > +	if (!syscon)
> > +		syscon = of_syscon_register(np);
> > +
> > +	if (IS_ERR(syscon))
> > +		return ERR_CAST(syscon);
> >
> >  	return syscon->regmap;
> >  }
> > @@ -110,17 +184,6 @@ struct regmap
> > *syscon_regmap_lookup_by_phandle(struct
> > device_node *np, }
> >  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);
> >
> > -static const struct of_device_id of_syscon_match[] = {
> > -	{ .compatible = "syscon", },
> > -	{ },
> > -};
> > -
> > -static struct regmap_config syscon_regmap_config = {
> > -	.reg_bits = 32,
> > -	.val_bits = 32,
> > -	.reg_stride = 4,
> > -};
> > -
> >  static int syscon_probe(struct platform_device *pdev)  {
> >  	struct device *dev = &pdev->dev;
> > @@ -167,7 +230,6 @@ static struct platform_driver syscon_driver = {
> >  	.driver = {
> >  		.name = "syscon",
> >  		.owner = THIS_MODULE,
> > -		.of_match_table = of_syscon_match,
> >  	},
> >  	.probe		= syscon_probe,
> >  	.id_table	= syscon_ids,

