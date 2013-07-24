Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3GXXxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:53:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52885 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3GXXxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:53:49 -0400
X-AuditID: cbfee691-b7fef6d000002d62-b5-51f0690c8719
Message-id: <51F0690C.4010909@samsung.com>
Date: Thu, 25 Jul 2013 08:53:48 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 07/36] extcon: convert extcon_class to use dev_groups
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-8-git-send-email-gregkh@linuxfoundation.org>
In-reply-to: <1374703539-9705-8-git-send-email-gregkh@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWyRsSkWJcn80OgQe8RXovmxevZLC7vmsNm
	cbtxBZsDs8f+uWvYPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugStj5x7vgq1CFbu2LWVsYOzm
	72Lk5JAQMJHYe7OFCcIWk7hwbz1bFyMXh5DAUkaJ1msLmLsYOcCK2r6pQMSnM0psunyaGcJ5
	xSjR/e8NI0g3r4CWxOOZl1lAbBYBVYmXX1aDTWUDiu9/cYMNxBYVCJNYOf0KC0S9oMSPyffA
	bBEBY4n+s7PYQWxmAU+J07e6wBYLA9k/+7MgdnUySlzf2cwKUsMp4CVxYN8LNoh6HYn9rdOg
	bHmJzWveMkN8s4hdYuWvfIh7BCS+TT7EAvGMrMSmA1AlkhIHV9xgmcAoNgvJRbOQTJ2FZOoC
	RuZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGIFxc/rfs4k7GO8fsD7EmAy0ciKzlGhyPjDu
	8kriDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuLky
	Uuuh4pF1IfYG1n5mHuszHOvj+83c/36yrok/mr0yIt35yHLFRdOEJu+KYNyoEl8g9/1HjJwa
	z3rPlh+nhVJ0JxnK+nYcm2Wo/0VFoe3WrEim41u+71bY/8b4003VqJ7c3K0rJi1Yda0v8Z22
	VXXF3LBjfVsa2Q+3z9u3MGZTv2aEYpGDEktxRqKhFnNRcSIANumXdLECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV2ezA+BBr+vslk0L17PZnF51xw2
	i9uNK9gcmD32z13D7tG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGTv3eBdsFarYtW0pYwNjN38XIweHhICJRNs3lS5GTiBTTOLCvfVsXYxcHEIC0xkl
	Nl0+zQzhvGKU6P73hhGkildAS+LxzMssIDaLgKrEyy+rmUBsNqD4/hc32EBsUYEwiZXTr7BA
	1AtK/Jh8D8wWETCW6D87ix3EZhbwlDh9q4sZ5AhhIPtnfxbErk5Gies7m1lBajgFvCQO7HvB
	BlGvI7G/dRqULS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS
	83M3MYLj8pnUDsaVDRaHGAU4GJV4eFd8fx8oxJpYVlyZe4hRgoNZSYT37QOgEG9KYmVValF+
	fFFpTmrxIcZkYAhMZJYSTc4Hpoy8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqem
	FqQWwWxh4uCUamC0M9iw3H7Cg6JihxmrnkY+YOpSkqyZ2NSrda6NU/XpmUSdza8m1VtJODPF
	2s5b4/DnwLPTZqJPP3ZfWqvA4bhac7Kzyj6ZxLPvLgtLTj7DJbXjpmhdiai3nfTWKuYyi1kL
	lk8xWPCiz+Zg7izRvVdWRWetfP/hhcGaCS3HZMzTlDeulO94Fb1aiaU4I9FQi7moOBEA+XNt
	hA8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 07:05 AM, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the extcon_class code to use the
> correct field.
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> MyungJoo, feel free to apply this to your tree, or ACK it and I can take it
> through mine.
> 
>  drivers/extcon/extcon-class.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 18ccadef..022ca369 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -148,6 +148,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
>  
>  	return count;
>  }
> +static DEVICE_ATTR_RW(state);
>  
>  static ssize_t name_show(struct device *dev, struct device_attribute *attr,
>  		char *buf)
> @@ -163,6 +164,7 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
>  
>  	return sprintf(buf, "%s\n", dev_name(edev->dev));
>  }
> +static DEVICE_ATTR_RO(name);
>  
>  static ssize_t cable_name_show(struct device *dev,
>  			       struct device_attribute *attr, char *buf)
> @@ -527,11 +529,12 @@ int extcon_unregister_notifier(struct extcon_dev *edev,
>  }
>  EXPORT_SYMBOL_GPL(extcon_unregister_notifier);
>  
> -static struct device_attribute extcon_attrs[] = {
> -	__ATTR(state, S_IRUGO | S_IWUSR, state_show, state_store),
> -	__ATTR_RO(name),
> -	__ATTR_NULL,
> +static struct attribute *extcon_attrs[] = {
> +	&dev_attr_state.attr,
> +	&dev_attr_name.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(extcon);
>  
>  static int create_extcon_class(void)
>  {
> @@ -539,7 +542,7 @@ static int create_extcon_class(void)
>  		extcon_class = class_create(THIS_MODULE, "extcon");
>  		if (IS_ERR(extcon_class))
>  			return PTR_ERR(extcon_class);
> -		extcon_class->dev_attrs = extcon_attrs;
> +		extcon_class->dev_groups = extcon_groups;
>  
>  #if defined(CONFIG_ANDROID)
>  		switch_class = class_compat_register("switch");
> 

Looks good to me. I tested this patch.

Acked-by: Chanwoo Choi<cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
