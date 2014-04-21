Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaDUKcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:32:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32112 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaDUKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:32:48 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-52-5354f3ce071b
Message-id: <5354F3D5.3020800@samsung.com>
Date: Mon, 21 Apr 2014 19:32:53 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCHv4 1/8] extcon: Add resource-managed extcon register function
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
 <1398075015-19211-2-git-send-email-sangjung.woo@samsung.com>
In-reply-to: <1398075015-19211-2-git-send-email-sangjung.woo@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkUPfc55Bgg9XHDSxevzC0uLxrDpvF
	7cYVbBYL9pRYzJj8ks2B1aNvyypGj8+b5AKYorhsUlJzMstSi/TtErgyJjbMYi/4qlZx6IpL
	A+M8+S5GTg4JAROJvx8eMELYYhIX7q1n62Lk4hASWMoosfR3GwtM0Zrpv1ggEosYJbpnzmKH
	cF4zSkw6/o0VpIpXQEuidc5EsFEsAqoSB35tZwOx2YDi+1/cALNFBcIkVk6/wgJRLyjxY/I9
	MFtEQFvi/oTPYBuYBZYwSsw99gksISwQIHF52wKom9oZJdbMXAm2jVPAU2Lj0RlMIDazgI7E
	/tZpbBC2vMTmNW+ZQRokBJaxSxxe2MEOcZKAxLfJh4CmcgAlZCU2HWCG+E1S4uCKGywTGMVm
	ITlqFpKxs5CMXcDIvIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjMIpO/3vWv4Px7gHrQ4zJ
	QCsnMkuJJucDozCvJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTA6KvDsS/Def2rqslMBbB2uc/4UzpIWru2Muvby1KJTkyc0sO76pHu5K2WR0BMV
	vb9Ou+9LiwZ+XVXE6HAi8ZigQWuG98E5ew+H8T8xKbn74/ur3T9W1cgU2RQvFSjY8fSm6sy7
	LNI79yeG/dc26twgEhbH9O7Ykm57ub+VCsLvs2sUPp6Y1+GuxFKckWioxVxUnAgAi6sbkLgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgO65zyHBBjf/q1u8fmFocXnXHDaL
	240r2CwW7CmxmDH5JZsDq0ffllWMHp83yQUwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8eb
	mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsS
	BNdjZIAGEtYwZkxsmMVe8FWt4tAVlwbGefJdjJwcEgImEmum/2KBsMUkLtxbz9bFyMUhJLCI
	UaJ75ix2COc1o8Sk499YQap4BbQkWudMZASxWQRUJQ782s4GYrMBxfe/uAFmiwqESaycfoUF
	ol5Q4sfke2C2iIC2xP0Jn1lAhjILLGGUmHvsE1hCWCBA4vK2BVCr2xkl1sxcCbaNU8BTYuPR
	GUwgNrOAjsT+1mlsELa8xOY1b5knMArMQrJkFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIjtFnUjsYVzZYHGIU4GBU4uGdURISLMSaWFZcmXuIUYKDWUmEN2I9UIg3JbGy
	KrUoP76oNCe1+BBjMjAMJjJLiSbnA9NHXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNL
	UrNTUwtSi2C2MHFwSjUwVh17933vjlr9UysXnDF7lLGpWCYk/qPDJ0Yxvcf5rSqh9okyVsV/
	Hq9rCJzMbjWR+XO8cmPyxnslGn9+FbEus/rzMjWHQabrmf7pz3Mm5fYbcjxcX3flMc91N9cV
	0+fvr3J9n7TD4/BeuTKOXqk7DMub0/7qbrMPipOVZOk4YpIRlC6WWLpaiaU4I9FQi7moOBEA
	utQ5HxUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch has some bug and need code clean.
I'll fix it and resend only this patch on v5.

Thanks,
Chanwoo Choi

On 04/21/2014 07:10 PM, Sangjung Woo wrote:
> Add resource-managed extcon device register function for convenience.
> For example, if a extcon device is attached with new
> devm_extcon_dev_register(), that extcon device is automatically
> unregistered on driver detach.
> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  drivers/extcon/extcon-class.c |   64 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/extcon.h        |   17 +++++++++++
>  2 files changed, 81 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 7ab21aa..645b02b 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -819,6 +819,70 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  }
>  EXPORT_SYMBOL_GPL(extcon_dev_unregister);
>  
> +static void devm_extcon_dev_release(struct device *dev, void *res)
> +{
> +	extcon_dev_unregister((struct extcon_dev *)res);

'res' is double pointer. this line have to modify as following:
	extcon_dev_unregister(*(struct extcon_dev **)res);

> +}
> +
> +static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
> +{
> +	return res == data;

'res' is double pointer so this line have to modify as following:
	return *res == data;

and additionally add error exception code

	struct extcon_dev **r = res;

	if (!r || !*r) {
		WARN_ON(!r || !*r);
		return 0;
	}

	return *r == data;

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
> +	struct extcon_dev **ptr;
> +	int ret;
> +
> +	ptr = devres_alloc(devm_extcon_dev_release, sizeof(*ptr),
> +			GFP_KERNEL);
> +	if (!ptr)
> +		return -ENOMEM;
> +
> +	ret = extcon_dev_register(edev);
> +	if (ret) {
> +		devres_free(ptr);
> +		return ret;
> +	}
> +
> +	*ptr = edev;
> +	devres_add(dev, ptr);
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
> +	WARN_ON(devres_release(dev, devm_extcon_dev_release,
> +			devm_extcon_dev_match, edev));

Need to keep the indentation for readability.

> +}
> +EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
> +
>  #ifdef CONFIG_OF
>  /*
>   * extcon_get_edev_by_phandle - Get the extcon device from devicetree
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index f488145..6a17f69 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -188,6 +188,14 @@ extern void extcon_dev_unregister(struct extcon_dev *edev);
>  extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
>  
>  /*
> + * Resource-managed extcon device register function.
> + */
> +extern int devm_extcon_dev_register(struct device *dev,
> +				    struct extcon_dev *edev);
> +extern void devm_extcon_dev_unregister(struct device *dev,
> +				       struct extcon_dev *edev);
> +
> +/*
>   * get/set/update_state access the 32b encoded state value, which represents
>   * states of all possible cables of the multistate port. For example, if one
>   * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
> @@ -254,6 +262,15 @@ static inline int extcon_dev_register(struct extcon_dev *edev)
>  
>  static inline void extcon_dev_unregister(struct extcon_dev *edev) { }
>  
> +static inline devm_extcon_dev_register(struct device *dev,

Missing the vairable type of return value.

> +				       struct extcon_dev *edev)
> +{
> +	return 0;
> +}
> +
> +static inline devm_extcon_dev_unregister(struct device *dev,

Missing the vairable type of return value.

> +					 struct extcon_dev *edev) { }
> +
>  static inline u32 extcon_get_state(struct extcon_dev *edev)
>  {
>  	return 0;
> 

