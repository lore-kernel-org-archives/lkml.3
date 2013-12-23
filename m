Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3LWEUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 23:20:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49856 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab3LWET6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 23:19:58 -0500
X-AuditID: cbfee690-b7f266d00000287c-0e-52b7b9edc9aa
Message-id: <52B7B9F0.1020801@samsung.com>
Date: Mon, 23 Dec 2013 13:20:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: rjying <rjying@gmail.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        Barry Song <21cnbao@gmail.com>, RongJun Ying <Rongjun.Ying@csr.com>,
        Binghua Duan <Binghua.Duan@csr.com>
Subject: Re: [PATCH 1/1] extcon: gpio: Add power resume support
References: <1387526987-12455-1-git-send-email-rongjun.ying@csr.com>
In-reply-to: <1387526987-12455-1-git-send-email-rongjun.ying@csr.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkSPftzu1BBo2reS0+3xWyaGjYwWhx
	edccNovbjSvYLG71HmC22HfhD6sDm8eunXNYPXbOusvu0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBkrpv5nLjjOW7Ht1wOmBsafXF2MnBwSAiYSD6e3MkPYYhIX7q1nA7GFBJYySjTOyYCp
	OdF8jLWLkQsoPp1RYs6yLVDOK0aJO1unAnVzcPAKaEl0nqkCMVkEVCVuz+cG6WUDiu5/cQNs
	pqhAmMTK6VdYQGxeAUGJH5PvsYCUiwjISpw9Gw4ykVlgO6PE3LvbWEFqhAXsJVZ+XMQIcY+L
	RO+hd2BzOAVcJa7/mQ0WZxbQkdjfOo0NwpaX2LzmLTPIIAmBY+wSuxd3gRWxCAhIfJt8CGyZ
	BNCyTQeg/pWUOLjiBssERrFZSE6ahWTsLCRjFzAyr2IUTS1ILihOSi8y0StOzC0uzUvXS87P
	3cQIjK7T/55N2MF474D1IcZkoJUTmaVEk/OB0ZlXEm9obGZkYWpiamxkbmlGmrCSOK/ao6Qg
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxqQVNybIU22TKFmBft3LR/ws/EjUo7jvxt0JXs
	ueZy81DRjz+rzKSWXjDh2Bk5KTbwyvdJM9eJrPdeMvPM1mf/f2lvm9m84XCWeYnZmpCp/ae+
	Xjo84eacP2/531RnX24VOz1P8+LtZu1buRahlnactxZMtD5Wcnlj3IXHd3o14iIut/Sc5Fug
	oMRSnJFoqMVcVJwIAJjnr+zEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoO7bnduDDC6dZbP4fFfIoqFhB6PF
	5V1z2CxuN65gs7jVe4DZYt+FP6wObB67ds5h9dg56y67R9+WVYwenzfJBbBENTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmrJj6n7ngOG/Ftl8PmBoYf3J1MXJySAiYSJxo
	PsYKYYtJXLi3nq2LkYtDSGA6o8ScZVtYIZxXjBJ3tk5l7mLk4OAV0JLoPFMFYrIIqErcns8N
	0ssGFN3/4gYbiC0qECaxcvoVFhCbV0BQ4sfkeywg5SICshJnz4aDTGQW2M4oMffuNrC9wgL2
	Eis/LmIEsYUEXCR6D70Dm8Mp4Cpx/c9ssDizgI7E/tZpbBC2vMTmNW+ZJzAKzEKyYhaSsllI
	yhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7eZ1I7GFc2WBxiFOBgVOLh5WjZHiTE
	mlhWXJl7iFGCg1lJhDf6x7YgId6UxMqq1KL8+KLSnNTiQ4zJwACYyCwlmpwPTCx5JfGGxiZm
	RpZG5oYWRsbmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cB4JnmSk1OLvIDpbfPbP/kr
	wmNWubbzzXWW7fBrY3+3W7trZvfj5DZP0Yx0OYUFXzJV/Xb7pV3inyu7Z9NFtjlrDBTD+x9M
	/7T0cJSVxfPd8Z/nrPHmXC72cmZyzPvtL9e67Ty3XfR5hgC7ZvE6m1fWqyaqV8drSvkGu6nq
	fPAVOH1Ks+ZaPZcSS3FGoqEWc1FxIgCdqFEDIgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 05:09 PM, rjying wrote:
> From: Rongjun Ying <rongjun.ying@csr.com>
> 
> After system resume, need send extcon uevent to userspace

Why did extcon send uevent after wakeup from suspend?

If extcon cable is attatched or detached on suspend state,
Kernel can detect the interrupt about changed state of extcon.
So, kernel would execute proper operation about interrupt
after wakeup from suspend state.

I think it isn't necessary.

Thanks,
Chanwoo Choi

> 
> Change-Id: I32a9e1c6646035f95765bba79a7acaccb8ce45a7
> 
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> ---
>  drivers/extcon/extcon-gpio.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 7e0dff5..d916522 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -159,12 +159,29 @@ static int gpio_extcon_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +static int gpio_extcon_resume(struct device *dev)
> +{
> +	struct gpio_extcon_data *extcon_data;
> +
> +	extcon_data = dev_get_drvdata(dev);
> +	queue_delayed_work(system_power_efficient_wq, &extcon_data->work,
> +			      extcon_data->debounce_jiffies);
> +	return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops gpio_extcon_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume)
> +};
> +
>  static struct platform_driver gpio_extcon_driver = {
>  	.probe		= gpio_extcon_probe,
>  	.remove		= gpio_extcon_remove,
>  	.driver		= {
>  		.name	= "extcon-gpio",
>  		.owner	= THIS_MODULE,
> +		.pm = &gpio_extcon_pm_ops,
>  	},
>  };
>  
> 

