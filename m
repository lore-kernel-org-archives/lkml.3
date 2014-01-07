Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaAGGJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 01:09:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10749 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaAGGJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 01:09:45 -0500
X-AuditID: cbfee690-b7f266d00000287c-7a-52cb9a15f240
Message-id: <52CB9A16.9010305@samsung.com>
Date: Tue, 07 Jan 2014 15:09:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: RongJun Ying <rjying@gmail.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Barry Song <Barry.Song@csr.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>
Subject: Re: [PATCH v3] extcon: gpio: Add power resume support
References: <1389070590-3139-1-git-send-email-rongjun.ying@csr.com>
In-reply-to: <1389070590-3139-1-git-send-email-rongjun.ying@csr.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkWFd01ukgg3NPOC0uT1rPZLHp8TVW
	i8u75rBZ3G5cwWZxq/cAs8W+C39YLTb09TM5sHvs2jmH1WPnrLvsHpuX1Hv0bVnF6PF5k1wA
	axSXTUpqTmZZapG+XQJXxqzPncwFqwQrWg6eY2xg3MrXxcjBISFgIrGmubKLkRPIFJO4cG89
	WxcjF4eQwFJGia7vd9ggEiYSey/dZYRILGKUeNZ8kBXCecUosXXxAbAqXgEtiU97NzOD2CwC
	qhLXDy1nBbHZgOL7X9wAqxEVCJNYOf0KC0S9oMSPyffAbBEBZYmb3XOYQIYyC1xilOi/8Y8J
	JCEsYCfRevE/O4gtJOAssWjjK7AFnAIuEg9+ngVbwCygI7G/dRobhC0vsXnNW2aQQRICl9gl
	Xn17zAZxkYDEt8mHWCB+lpXYdIAZ4jVJiYMrbrBMYBSbheSmWUjGzkIydgEj8ypG0dSC5ILi
	pPQiE73ixNzi0rx0veT83E2MwLg7/e/ZhB2M9w5YH2JMBlo5kVlKNDkfGLd5JfGGxmZGFqYm
	psZG5pZmpAkrifOqPUoKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4TKTVL3rGAgPetB8X
	u5TKRbpz9kZbLVwvq5+i8rEjIMPXwXPRP1MniyYjg8raJwfOzfD/cnaz3uoprKtrVI/W/y7p
	ZPctcLIMdbp4ePL/o6Y1QlcU7v/1OlTscvFIj/Ku0laRV4sPFz+RsttbYpFpzHznR2LBnLL0
	a1XFC0USkhyr1J8eElFiKc5INNRiLipOBABlaglP0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAV3RWaeDDHa3MllcnrSeyWLT42us
	Fpd3zWGzuN24gs3iVu8BZot9F/6wWmzo62dyYPfYtXMOq8fOWXfZPTYvqffo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmzPncyF6wSrGg5eI6xgXEr
	XxcjJ4eEgInE3kt3GSFsMYkL99azdTFycQgJLGKUeNZ8kBXCecUosXXxATaQKl4BLYlPezcz
	g9gsAqoS1w8tZwWx2YDi+1/cAKsRFQiTWDn9CgtEvaDEj8n3wGwRAWWJm91zmECGMgtcYpTo
	v/GPCSQhLGAn0XrxPzuILSTgLLFo4yuwBZwCLhIPfp4FW8AsoCOxv3UaG4QtL7F5zVvmCYwC
	s5DsmIWkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxguP6mdQOxpUNFocYBTgY
	lXh4X+w9FSTEmlhWXJl7iFGCg1lJhFcz5XSQEG9KYmVValF+fFFpTmrxIcZkYBBMZJYSTc4H
	ppy8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamCMerd80+HH
	ar8ZNr+of7H2Z7v7u5eh6uubBQru2a1avOmbavXiKVrFchKdk14X1FTc8DC0S5er29m8ffvk
	R59fnXeWUVRvjDgvp/xWeYPnxZYzm56bXX68MbHKde9qnXvJJ4wZZmd8Xh/oM1P40vqOm5eW
	5ssbaUR4e063TNE+zd60tjbg6a1IJZbijERDLeai4kQAbnmkDS8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi RongJun,

On 01/07/2014 01:56 PM, RongJun Ying wrote:
> From: Rongjun Ying <rongjun.ying@csr.com>
> 
> When system on the suspend state, Some SoC can't get gpio interrupt.
> After system resume, need send extcon uevent to userspace.
> 
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> Reviewed-by: Barry Song <Baohua.Song@csr.com>
> ---
>  -v3:
>  'check_on_resume' instead of 'load_sleep_irq' as Chanwoo Choi's proposal.
> 
>  drivers/extcon/extcon-gpio.c       |   20 ++++++++++++++++++++
>  include/linux/extcon/extcon-gpio.h |    1 +
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 7e0dff5..fde52c1 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -40,6 +40,7 @@ struct gpio_extcon_data {
>  	int irq;
>  	struct delayed_work work;
>  	unsigned long debounce_jiffies;
> +	bool check_on_resume;
>  };
> 
>  static void gpio_extcon_work(struct work_struct *work)
> @@ -103,6 +104,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  	extcon_data->gpio_active_low = pdata->gpio_active_low;
>  	extcon_data->state_on = pdata->state_on;
>  	extcon_data->state_off = pdata->state_off;
> +	extcon_data->check_on_resume = pdata->check_on_resume;
>  	if (pdata->state_on && pdata->state_off)
>  		extcon_data->edev.print_state = extcon_gpio_print_state;
>  	if (pdata->debounce) {
> @@ -159,12 +161,30 @@ static int gpio_extcon_remove(struct platform_device *pdev)
>  	return 0;
>  }
> 
> +#ifdef CONFIG_PM_SLEEP
> +static int gpio_extcon_resume(struct device *dev)
> +{
> +	struct gpio_extcon_data *extcon_data;
> +
> +	extcon_data = dev_get_drvdata(dev);
> +	if (extcon_data->check_on_resume)
> +		queue_delayed_work(system_power_efficient_wq,
> +			&extcon_data->work, extcon_data->debounce_jiffies);
> +	return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops gpio_extcon_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume)

If CONFIG_PM_SLEEP is undefined, gpio_extcon_pm_ops cannot find gpio_extcon_resume function.
You should define dummy function for gpio_extcon_resume function.


