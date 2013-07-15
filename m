Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3GOHOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:14:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23506 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3GOHN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:13:59 -0400
X-AuditID: cbfee68f-b7f436d000000f81-e9-51e3a135f7ec
From: Jingoo Han <jg1.han@samsung.com>
To: "'Yijing Wang'" <wangyijing@huawei.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Hanjun Guo'" <guohanjun@huawei.com>, jiang.liu@huawei.com,
        Jingoo Han <jg1.han@samsung.com>
References: <1373869765-52572-1-git-send-email-wangyijing@huawei.com>
In-reply-to: <1373869765-52572-1-git-send-email-wangyijing@huawei.com>
Subject: Re: [PATCH] video: remove unused variable "dev" in vga16fb_destroy()
Date: Mon, 15 Jul 2013 16:13:56 +0900
Message-id: <000101ce812a$dec735d0$9c55a170$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIR3w7P7IUBkl/d02cHm24xWRKEIJjel0NQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zfV3ThY8DDX5OEbB4eUjT4uDOmewW
	lxdeYrW4/30um8WJvg+sFpd3zWGzWPfwBZPF+vm32CzuXJvG5MDp0XLkLavHqwt3WDz6tqxi
	9Dh+YzuTx+dNcgGsUVw2Kak5mWWpRfp2CVwZ6xtXsBbcZK+40/+MtYFxKVsXIyeHhICJRPf7
	+6wQtpjEhXvrgeJcHEICyxgl9t/bzAhTtGP9DSaIxHRGiZ/X1zJCOL8YJaZ3zmQCqWITUJP4
	8uUwO0hCRGAyo8SSX+tZQBLMAvMYJbZN0QexhQRcJe60nwaLcwq4SSy8OgesWVjAV6J5XT9Y
	nEVAVeLShcVgq3kFLCW2LdnPBGELSvyYfA9qppbE+p3HmSBseYnNa94yQ5yqILHj7GuwXhEB
	I4kd79qg6kUk9r14B3a1hMBPdom+dztYIZYJSHybfAioiAMoISux6QDUHEmJgytusExglJiF
	ZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFCorp/B+PdA9aHGJOB
	1k9klhJNzgcmhbySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MIp0PWdxE3t0a8U93euq1RMdehfqbbO/+V33qOzbxbpip/fWeN9vfi/yU+S7sqBN
	zltNNi6lP7mFqpGpZ4+8Zd4jsafA7lpxAke1csoVTp/X/SkbZcU9rD58upO+6LUj45dbp9U0
	Z261tDv5Xiixe3vpD7+Pf8NnnlS9x1BUUhHVeG7fz2KVt0osxRmJhlrMRcWJAO6DsfYAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQV3ThY8DDaZf4bZ4eUjT4uDOmewW
	lxdeYrW4/30um8WJvg+sFpd3zWGzWPfwBZPF+vm32CzuXJvG5MDp0XLkLavHqwt3WDz6tqxi
	9Dh+YzuTx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2
	Si4+AbpumTlABykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM9Y3rmAt
	uMlecaf/GWsD41K2LkZODgkBE4kd628wQdhiEhfurQeKc3EICUxnlPh5fS0jhPOLUWJ650yw
	KjYBNYkvXw6zgyREBCYzSiz5tZ4FJMEsMI9RYtsUfRBbSMBV4k77abA4p4CbxMKrc8CahQV8
	JZrX9YPFWQRUJS5dWMwIYvMKWEpsW7KfCcIWlPgx+R7UTC2J9TuPM0HY8hKb17xlhjhVQWLH
	2ddgvSICRhI73rVB1YtI7HvxjnECo9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIThnPpHYwrmywOMQowMGoxMN7QONxoBBrYllxZe4hRgkOZiUR3mXKjwKF
	eFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YzvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0o
	JJCeWJKanZpakFoEs4WJg1OqgbHnaw5/5YVDYaoXTwcIh+7XEJgbO70077A9i0WP4imZDKs9
	a+YxflNhUl20ZJ6q8NxTmtm63Alv1dh+eq/c67ik4Xu4xB47I9vKG1oiU96mVsfGb97SFWo2
	8RX/7DP7F7/M+nU1a06S0FNFi9jP7uoTdq9Rf3FS2Udr4pq69Z3/fv2IumYY7qHEUpyRaKjF
	XFScCAA2M8sKXQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 15, 2013 3:29 PM, Yijing Wang wrote:
> 
> Delete unused variable "dev" to fix build warning in
> drivers/video/vga16fb.c
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Jingoo Han <jg1.han@samsung.com>

It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/vga16fb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
> index 830ded4..2827333 100644
> --- a/drivers/video/vga16fb.c
> +++ b/drivers/video/vga16fb.c
> @@ -1265,7 +1265,6 @@ static void vga16fb_imageblit(struct fb_info *info, const struct fb_image *image
> 
>  static void vga16fb_destroy(struct fb_info *info)
>  {
> -	struct platform_device *dev = container_of(info->device, struct platform_device, dev);
>  	iounmap(info->screen_base);
>  	fb_dealloc_cmap(&info->cmap);
>  	/* XXX unshare VGA regions */
> --
> 1.7.1


