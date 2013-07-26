Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3GZDnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:43:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10000 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab3GZDnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:43:45 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-91-51f1f0700685
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <001a01ce8450$dcbd0bb0$96372310$@samsung.com>
In-reply-to: <001a01ce8450$dcbd0bb0$96372310$@samsung.com>
Subject: Re: [PATCH] driver core: replace strict_strto*() with kstrto*()
Date: Fri, 26 Jul 2013 12:43:43 +0900
Message-id: <000101ce89b2$5378c210$fa6a4630$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGkIV4S6h94/ChSBCBZycQQa/McpZnLINNg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zfd2CDx8DDe4eYrJoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBl/N9iVXBbquLU6eNsDYyN
	ol2MnBwSAiYSixf8ZYewxSQu3FvP1sXIxSEksIxRYuWKLewwReuWt4LZQgLTGSU69plDFP1i
	lJj18BRYgk1ATeLLl8NgtoiAqcTG91MYQWxmASeJn1tmskA0W0pcvLQWrIZTwEpi2YE/YLaw
	gIfE6UndQJs5OFgEVCUunskDCfMCld9teM0GYQtK/Jh8jwVipJbE+p3HmSBseYnNa94yQ9yp
	ILHj7GtGiBOMJKat38AKUSMise/FO0aQmyUEtrFL9HRMBxvEIiAg8W3yIRaQvRICshKbDkDN
	kZQ4uOIGywSg75CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRkj8
	TdjBeO+A9SHGZKD1E5mlRJPzgfGbVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQbGxYqli6IjSpqiVmbEpwce5OvyzGxn7Gd/frGncGKGz7SD0mKS
	bV6nU3c4r5GNm71436oJxyRNeI9zHItuOhSwIyNyS+d7k773foJ9D3+4GYldVbBNnb5BnDls
	rkVX5dvA64YdYV/bfyffrk57v1Qn7PfXf/WJIe9sd4nFNRzbaHR/lbjI40IlluKMREMt5qLi
	RAC1fMuv1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd38Dx8DDY4ftLZoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZvzfYlVwW6ri1OnjbA2MjaJdjJwcEgImEuuWt7JD2GISF+6tZwOxhQSmM0p07DPv
	YuQCsn8xSsx6eAqsiE1ATeLLl8NgtoiAqcTG91MYQWxmASeJn1tmskA0W0pcvLQWrIZTwEpi
	2YE/YLawgIfE6UndQAs4OFgEVCUunskDCfMCld9teM0GYQtK/Jh8jwVipJbE+p3HmSBseYnN
	a94yQ9ypILHj7GtGiBOMJKat38AKUSMise/FO8YJjEKzkIyahWTULCSjZiFpWcDIsopRNLUg
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjOLqfSe1gXNlgcYhRgINRiYdXweljoBBrYllxZe4hRgkO
	ZiUR3oZjQCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OByaevJJ4Q2MTMyNLIzMLIxNzc9KE
	lcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg3Jb8ml0qg3/q1wqDfYuO3fffFvvKWClTSGRy
	NMPH64fcBWPcqteynqy1bMy/c/OQQf3hOTdtTQ47pPyavW7mw1dWtlc1Bd3lrHwWVk2bI/Yu
	/uKcHV5NnkwPu9707bGyfH7XwuuyuPDq5RFzC3VFHp3gTznIYz3BSOih0cFdOUdYj7/aoMW/
	X4mlOCPRUIu5qDgRAB+GbfcyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 04:21:28PM +0900, Jingoo Han wrote:, Jingoo Han wrote:
> 
> The usage of strict_strto*() is not preferred, because
> strict_strto*() is obsolete. Thus, kstrto*() should be
> used.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/base/core.c                  |    2 +-
>  drivers/base/memory.c                |   10 ++++++----
>  drivers/base/power/sysfs.c           |    7 ++++++-
>  drivers/base/regmap/regmap-debugfs.c |    5 +++--
>  4 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 8856d74..edfbf05 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -38,7 +38,7 @@ long sysfs_deprecated = 0;
>  #endif
>  static __init int sysfs_deprecated_setup(char *arg)
>  {
> -	return strict_strtol(arg, 10, &sysfs_deprecated);
> +	return kstrtol(arg, 10, &sysfs_deprecated);
>  }
>  early_param("sysfs.deprecated", sysfs_deprecated_setup);
>  #endif
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 2b7813e..d0817fb 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -469,8 +469,9 @@ store_soft_offline_page(struct device *dev,
>  	u64 pfn;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	if (strict_strtoull(buf, 0, &pfn) < 0)
> -		return -EINVAL;
> +	ret = kstrtoull(buf, 0, &pfn);
> +	if (ret < 0)
> +		return ret;

In order to not risk any user space breakage,
I will just mechanically replaces strict_strto*() with kstrto*().


>  	pfn >>= PAGE_SHIFT;
>  	if (!pfn_valid(pfn))
>  		return -ENXIO;
> @@ -488,8 +489,9 @@ store_hard_offline_page(struct device *dev,
>  	u64 pfn;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	if (strict_strtoull(buf, 0, &pfn) < 0)
> -		return -EINVAL;
> +	ret = kstrtoull(buf, 0, &pfn);
> +	if (ret < 0)
> +		return ret;

Ditto.

>  	pfn >>= PAGE_SHIFT;
>  	ret = memory_failure(pfn, 0, 0);
>  	return ret ? ret : count;
> diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
> index a53ebd2..e0a3877 100644
> --- a/drivers/base/power/sysfs.c
> +++ b/drivers/base/power/sysfs.c
> @@ -202,11 +202,16 @@ static ssize_t autosuspend_delay_ms_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t n)
>  {
>  	long delay;
> +	int ret;
> 
>  	if (!dev->power.use_autosuspend)
>  		return -EIO;
> 
> -	if (strict_strtol(buf, 10, &delay) != 0 || delay != (int) delay)
> +	ret = kstrtol(buf, 10, &delay);
> +	if (ret)
> +		return ret;
> +
> +	if (delay != (int) delay)

Ditto.

>  		return -EINVAL;
> 
>  	device_lock(dev);
> diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
> index 5349575..664a75e 100644
> --- a/drivers/base/regmap/regmap-debugfs.c
> +++ b/drivers/base/regmap/regmap-debugfs.c
> @@ -281,8 +281,9 @@ static ssize_t regmap_map_write_file(struct file *file,
>  	reg = simple_strtoul(start, &start, 16);
>  	while (*start == ' ')
>  		start++;
> -	if (strict_strtoul(start, 16, &value))
> -		return -EINVAL;
> +	ret = kstrtoul(start, 16, &value);
> +	if (ret)
> +		return ret;

Ditto.

I will send v2 patch, soon.
Thank you.

Best regards,
Jingoo Han

> 
>  	/* Userspace has been fiddling around behind the kernel's back */
>  	add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> --
> 1.7.10.4


