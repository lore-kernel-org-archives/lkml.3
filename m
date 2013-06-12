Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab3FLB2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:28:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8989 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3FLB2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:28:02 -0400
X-AuditID: cbfee68f-b7f436d000000f81-05-51b7cea0836d
Message-id: <51B7CEA0.2060903@samsung.com>
Date: Wed, 12 Jun 2013 10:28:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org, anish198519851985@gmail.com,
        pmeerw@pmeerw.net
Subject: Re: [PATCH 1/5] extcon: Add an API to get extcon device from dt node
References: <1370276020-17446-1-git-send-email-kishon@ti.com>
 <1370276020-17446-2-git-send-email-kishon@ti.com>
In-reply-to: <1370276020-17446-2-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWyRsSkUHfBue2BBt8Pi1hcvtHFbHHwfr3F
	zE832SwOzH7IanHgzw5Gi+bF69ksLjztYbNY2LaExeLyrjlsFrOX9LNYLFrWymxxu3EFm8Xv
	XcfYLQ6vOMBkse7ldBYHfo8Fn6+we+ycdZfd49Xqmawed67tYfPYP3cNu8f5GQsZPc43H2H0
	6NuyitHj+I3tTB6fN8kFcEVx2aSk5mSWpRbp2yVwZTye85Kp4KhMxddjXSwNjKvFuxg5OSQE
	TCQW3j/HAmGLSVy4t56ti5GLQ0hgKaPEqemdLDBFPdtnsEIkFjFKbH9ynhnCecEo8fvYfSaQ
	Kl4BLYnFL1YCtXNwsAioShzdXAwSZgMK739xgw3EFhUIk1g5/QoLRLmgxI/J98BsEaCa0zt/
	gM1kFvjMJPG1eQ0jyBxhAV+JJXPB5ggJFEoc3dnBCmJzCthJ7FvQB2YzC+hI7G+dxgZhy0ts
	XvMWbI6EwFoOiQuHZ7GDJFgEBCS+TT7EAjJTQkBWYtMBZojHJCUOrrjBMoFRbBaSk2YhGTsL
	ydgFjMyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MQLj/vS/Z/07GO8esD7EmAy0ciKzlGhy
	PjBt5JXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	0ersWl9N3scnD+9+vUvl7TxPMxNu9ydBN8PPHn5lNaemNCHpa8uZMK32L4mvROd2T7yscuH1
	3Zk/es6Hqm1+zb6Tr63G+fdPjtXSE+y9zBOezbW+XbvIyc3N0Xup3s7I6ax8V9/Ldkp/0LNy
	z+zqkBeN+u192kximtHB9IPtlzVTCp+wPq/zUmIpzkg01GIuKk4EAGRVPckRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jAd0F57YHGvzt4ra4fKOL2eLg/XqL
	mZ9uslkcmP2Q1eLAnx2MFs2L17NZXHjaw2axsG0Ji8XlXXPYLGYv6WexWLSsldniduMKNovf
	u46xWxxecYDJYt3L6SwO/B4LPl9h99g56y67x6vVM1k97lzbw+axf+4ado/zMxYyepxvPsLo
	0bdlFaPH8RvbmTw+b5IL4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LI
	S8xNtVVy8QnQdcvMAfpDSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx
	eM5LpoKjMhVfj3WxNDCuFu9i5OSQEDCR6Nk+gxXCFpO4cG89WxcjF4eQwCJGie1PzjNDOC8Y
	JX4fu88EUsUroCWx+MVKoCoODhYBVYmjm4tBwmxA4f0vbrCB2KICYRIrp19hgSgXlPgx+R6Y
	LQJUc3rnD7CZzAKfmSS+Nq9hBJkjLOArsWQu2BwhgUKJozs7wA7iFLCT2LegD8xmFtCR2N86
	jQ3ClpfYvOYt8wRGgVlIVsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFJ
	5ZnUDsaVDRaHGAU4GJV4eA+YbQ8UYk0sK67MPcQowcGsJMKrmwsU4k1JrKxKLcqPLyrNSS0+
	xJgMDICJzFKiyfnAhJdXEm9obGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1M
	HJxSDYy+3PlnCxQe5Kuv/iTZy9Sz5b7JDbNXf3lunermzfW9stLq+m2++Qvmvcn/8rwj87kB
	X13HBU8dqelG6/QFTHfVv6++dFftwWtbZu7Da3dHHpthespsw4n9xxJ2tc10nNLyUX/P4ROC
	3ofveDFME6kKme2/drv2Ws2by1dkrxayWxxf/Oqz1sXrSizFGYmGWsxFxYkACxvBUm4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 06/04/2013 01:13 AM, Kishon Vijay Abraham I wrote:
> Added an API of_extcon_get_extcon_dev() to be used by drivers to get
> extcon device in the case of dt boot (this can be used instead of
> extcon_get_extcon_dev()).
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/extcon/extcon-class.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/extcon.h        |    8 ++++++++
>  2 files changed, 48 insertions(+)

I don't prefer that add of helper API in extcon core. I want to add
new of helper file as drivers/extcon/of-extcon.c.
So, I add drivers/extcon/of-extcon.c and include/linux/extcon/of-extcon.h
based on your this patch. I will send modified patch at once.

> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 60adc04..265d549 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -31,6 +31,7 @@
>  #include <linux/extcon.h>
>  #include <linux/slab.h>
>  #include <linux/sysfs.h>
> +#include <linux/of_platform.h>
>  
>  /*
>   * extcon_cable_name suggests the standard cable names for commonly used
> @@ -392,6 +393,45 @@ int extcon_set_cable_state(struct extcon_dev *edev,
>  }
>  EXPORT_SYMBOL_GPL(extcon_set_cable_state);
>  
> +struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
> +{
> +	struct class_dev_iter iter;
> +	struct device *extcon_dev;
> +	struct device_node *node;
> +	struct platform_device *extcon_parent_dev;
> +
> +	if (!dev->of_node) {
> +		dev_dbg(dev, "device does not have a device node entry\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	node = of_parse_phandle(dev->of_node, "extcon", index);
> +	if (!node) {
> +		dev_dbg(dev, "failed to get phandle in %s node\n",
> +			dev->of_node->full_name);
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	extcon_parent_dev = of_find_device_by_node(node);
> +	if (!extcon_parent_dev) {
> +		dev_dbg(dev, "unable to find device by node\n");
> +		return ERR_PTR(-EPROBE_DEFER);
> +	}
> +
> +	class_dev_iter_init(&iter, extcon_class, NULL, NULL);
> +	while ((extcon_dev = class_dev_iter_next(&iter))) {
> +		if (extcon_dev->parent != &extcon_parent_dev->dev)
> +			continue;
> +
> +		class_dev_iter_exit(&iter);
> +		return dev_get_drvdata(extcon_dev);
> +	}
> +
> +	class_dev_iter_exit(&iter);

Use extcon_get_extcon_dev() instead of using class_dev_iter_init/exit()

> +	return ERR_PTR(-ENODEV);
> +}
> +EXPORT_SYMBOL_GPL(of_extcon_get_extcon_dev);
> +
>  /**
>   * extcon_get_extcon_dev() - Get the extcon device instance from the name
>   * @extcon_name:	The extcon name provided with extcon_dev_register()
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index fcb51c8..3858bb9 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -182,6 +182,8 @@ struct extcon_specific_cable_nb {
>   */
>  extern int extcon_dev_register(struct extcon_dev *edev, struct device *dev);
>  extern void extcon_dev_unregister(struct extcon_dev *edev);
> +extern struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev,
> +	int index);
>  extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
>  
>  /*
> @@ -292,6 +294,12 @@ static inline int extcon_set_cable_state(struct extcon_dev *edev,
>  	return 0;
>  }
>  
> +static inline struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev,
> +	int index)
> +{
> +	return NULL;
> +}
> +
>  static inline struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
>  {
>  	return NULL;

Thanks,
Chanwoo Choi






