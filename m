Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaDQFfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 01:35:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15146 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaDQFfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 01:35:50 -0400
X-AuditID: cbfee68f-b7f156d00000276c-a4-534f68354d15
Message-id: <534F6839.5070505@samsung.com>
Date: Thu, 17 Apr 2014 14:35:53 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] extcon: Add resource-managed extcon register function
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
 <1397644023-32516-2-git-send-email-sangjung.woo@samsung.com>
In-reply-to: <1397644023-32516-2-git-send-email-sangjung.woo@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkRNc0wz/Y4Mg9HovLu+awWdxuXMFm
	sWBPiQOzR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGWcX9LKWPBZu2Lq/Q7GBsbbyl2MnBwS
	AiYSMz8fZIKwxSQu3FvP1sXIxSEksJRRoqWpiwWmaNauRlaIxCJGiROr9rKBJIQEXjNKdCw3
	6GLk4OAV0JJoO+8AEmYRUJU48q0BrIQNKLz/xQ0wW1QgTGLl9CtgM3kFBCV+TL4HZosIaEvc
	n/AZzGYW8JTom9EOVi8s4Cfxad5ZqL3tQActf8cKkuAEKmpvW8MG0aAjsb91GpQtL7F5zVtm
	iKOns0tcnGMHcZCAxLfJh1hA7pQQkJXYdACqRFLi4IobLBMYxWYhOWkWkqmzkExdwMi8ilE0
	tSC5oDgpvchYrzgxt7g0L10vOT93EyMwWk7/e9a/g/HuAetDjMlAKycyS4km5wOjLa8k3tDY
	zMjC1MTU2Mjc0ow0YSVx3vsPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MCaHM9uKN/9f
	PunmIUMHZRHOD5un3di42fKHYcE5K/O3OxbLTN1jH8PKupD77TQnWVvjWyIBe/6fWH66IbE5
	brXJxWVXLdf734x0NK9dOsfdIjB7TcwFk0veE/KNZBVPq7Ev9+84ffKqrOdBw9bAULU3M/U5
	zD7Lhbk2tN6vXdietl9ppp/dRCWW4oxEQy3mouJEAOF7LKKsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jAV3TDP9gg/ULWCwu75rDZnG7cQWb
	xYI9JQ7MHn1bVjF6fN4kF8AU1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6k
	kJeYm2qr5OIToOuWmQO0Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY
	cX5JK2PBZ+2Kqfc7GBsYbyt3MXJySAiYSMza1cgKYYtJXLi3nq2LkYtDSGARo8SJVXvZQBJC
	Aq8ZJTqWG3QxcnDwCmhJtJ13AAmzCKhKHPnWAFbCBhTe/+IGmC0qECaxcvoVFhCbV0BQ4sfk
	e2C2iIC2xP0Jn8FsZgFPib4Z7WD1wgJ+Ep/mnWWF2NvOKNGy/B3YQZxARe1ta9ggGnQk9rdO
	g7LlJTavecs8gVFgFpIds5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDQ+
	k9rBuLLB4hCjAAejEg/vBHX/YCHWxLLiytxDjBIczEoivOJhQCHelMTKqtSi/Pii0pzU4kOM
	ycAgmMgsJZqcD0wUeSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAaCfB8ONqcnv+JsXvP6eWuNzpKYu4smHCweJytV35oXttNz/ecOb9Pe/LvRXSEZUf509Y
	sb7K8MvRS//nhp1U+7KerynUefuC1zOv7ztlnNlUp8X0Te2QVMf/+veTTjBKmtzJ/VOz/NnR
	jSXlQk72t+7O+Jsetsxzt8siM361RZdc2ytFFyRrblFiKc5INNRiLipOBABZtZ77CgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangjung,

Thanks for your contribution.

On 04/16/2014 07:26 PM, Sangjung Woo wrote:
> Add resource-managed extcon device register function for convenience.
> For example, if a extcon device is attached with new
> devm_extcon_dev_register(), that extcon device is automatically
> unregistered on driver detach.
> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  drivers/extcon/extcon-class.c |   83 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/extcon.h        |    8 ++++
>  2 files changed, 91 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 7ab21aa..accb49c 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -32,6 +32,7 @@
>  #include <linux/slab.h>
>  #include <linux/sysfs.h>
>  #include <linux/of.h>
> +#include <linux/gfp.h>

It is not necessary because 'device.h' already includes 'gfp.h' header file.

>  
>  /*
>   * extcon_cable_name suggests the standard cable names for commonly used
> @@ -819,6 +820,88 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  }
>  EXPORT_SYMBOL_GPL(extcon_dev_unregister);
>  
> +
> +/*
> + * Device resource management
> + */
> +

Should delete blank line.

> +struct extcon_devres {
> +	struct extcon_dev *edev;
> +};
> +
> +static void devm_extcon_release(struct device *dev, void *res)

Need to change function name as following to sustain consistency of existing extcon functions.
- devm_extcon_release -> devm_extcon_dev_release()

> +{
> +	struct extcon_devres *dr = (struct extcon_devres *)res;
> +
> +	extcon_dev_unregister(dr->edev);
> +}
> +
> +static int devm_extcon_match(struct device *dev, void *res, void *data)

ditto.
- devm_extcon_match -> devm_extcon_dev_match

> +{
> +	struct extcon_devres *dr = (struct extcon_devres *)res;
> +	struct extcon_devres *match = (struct extcon_devres *)data;

I think that this function don't need explicit casting
because as I knew, casting is automatically about tool-chain.

> +
> +	return dr->edev == match->edev;
> +}
> +
> +/**
> + * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
> + * @dev:	device to allocate extcon device
> + * @edev:	the new extcon device to register
> + *
> + * Managed extcon_dev_register() function. If extcon device is attached with
> + * this function, that extcon device is automatically unregistered on driver
> + * detach. Internally this function calls extcon_dev_register() function.
> + * To get more information, refer that function.
> + *
> + * If extcon device is registered with this function and the device needs to be
> + * unregistered separately, devm_extcon_dev_unregister() should be used.
> + *
> + * RETURNS:
> + * 0 on success, negative error number on failure.
> + */
> +int devm_extcon_dev_register(struct device *dev, struct extcon_dev *edev)
> +{
> +	struct extcon_devres *dr;

To improve readability, I prefer to change 'dr' variable name (e.g., dr ->devres)

> +	int rc;

I think 'rc' variable name is ambiguous.
I prefer to change variable name for return value. (rc -> ret)

> +
> +	dr = devres_alloc(devm_extcon_release, sizeof(struct extcon_devres),

ditto.
- devm_extcon_release -> devm_extcon_dev_release

We chan modify it as following:
	sizeof(struct extcon_devres) -> sizeof(*dr)

> +			GFP_KERNEL);
> +	if (!dr)
> +		return -ENOMEM;
> +
> +	rc = extcon_dev_register(edev);
> +	if (rc) {
> +		devres_free(dr);
> +		return rc;
> +	}
> +
> +	dr->edev = edev;
> +	devres_add(dev, dr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devm_extcon_dev_register);
> +
> +/**
> + * devm_extcon_dev_unregister() - Resource-managed extcon_dev_unregister()
> + * @dev:	device the extcon belongs to
> + * @edev:	the extcon device to unregister
> + *
> + * Unregister extcon device that is registered with devm_extcon_dev_register()
> + * function.
> + */
> +void devm_extcon_dev_unregister(struct device *dev, struct extcon_dev *edev)
> +{
> +	struct extcon_devres match_dr = { edev };

Should we define 'match_dr' variable? I think it is not necessary.
Maybe it could use 'edev' directly without casting.

> +
> +	WARN_ON(devres_destroy(dev, devm_extcon_release,
> +			devm_extcon_match, &match_dr));

I think that devres_release() is more proper than devres_destroy.

> +
> +	extcon_dev_unregister(edev);

If you use devres_release() instead of devres_destroy(), don't need to call 
extcon_dev_unregister() function separately because devres_release() function
would call 'release' function.

> +}
> +EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
> +
>  #ifdef CONFIG_OF
>  /*
>   * extcon_get_edev_by_phandle - Get the extcon device from devicetree
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index f488145..e1e85a1 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -188,6 +188,14 @@ extern void extcon_dev_unregister(struct extcon_dev *edev);
>  extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
>  
>  /*
> + * Resource-managed extcon device register function.
> + */
> +extern int devm_extcon_dev_register(struct device *dev,
> +				struct extcon_dev *edev);
> +extern void devm_extcon_dev_unregister(struct device *dev,
> +				struct extcon_dev *edev);

This functions need to consider if CONFIG_OF is disabled.
IF CONFIG_OF is disabled, devm_extcon_dev_register/unregister() function
must need static inline function for dummy function.

Thanks,
Chanwoo Choi
