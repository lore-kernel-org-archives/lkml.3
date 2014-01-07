Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaAGGHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 01:07:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12141 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaAGGHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 01:07:11 -0500
X-AuditID: cbfee690-b7f266d00000287c-d7-52cb99883821
Message-id: <52CB9989.9010609@samsung.com>
Date: Tue, 07 Jan 2014 15:07:05 +0900
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkSLdj5ukggzVHBS0uT1rPZLHp8TVW
	i8u75rBZ3G5cwWZxq/cAs8W+C39YLTb09TM5sHvs2jmH1WPnrLvsHpuX1Hv0bVnF6PF5k1wA
	axSXTUpqTmZZapG+XQJXxqZJd9gLdklXnPnxj6WB8aBYFyMnh4SAicTkTR3MELaYxIV769m6
	GLk4hASWMko0bjvAAlM0e1c7VGI6o8TEWfOZQBJCAq8YJbbtSQGxeQW0JCZ8aQSLswioSuzb
	fgesmQ0ovv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRQSUJW52z2ECWcAscIlRov/GP7BBwgJ2
	Eq0X/7NDLHOWWLTxFdipnAIuEg9+nmUFsZkFdCT2t05jg7DlJTavecsMMkhC4By7xPr7l6Au
	EpD4NvkQ0DYOoISsxKYDUC9LShxccYNlAqPYLCQ3zUIydhaSsQsYmVcxiqYWJBcUJ6UXmegV
	J+YWl+al6yXn525iBMbd6X/PJuxgvHfA+hBjMtDKicxSosn5wLjNK4k3NDYzsjA1MTU2Mrc0
	I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGhrMPG6b+2sDeXcLf4KU+Z9mU
	//Xeddl656reqr/4rFtQYS1glbpFZ3XalDfxXgEsLRN6M9afZ8vOeR4hn13v/Kvw2PzE6P/f
	7h+q41ua8CpucWFJc8nPZu0tOny9RWmCs2TUZqXr8/6ecefUZ7n27NzXMtq5Z2wf2F0+nhC0
	fW+hn/f//d+UWIozEg21mIuKEwEXOwn+0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd2OmaeDDO6eZrS4PGk9k8Wmx9dY
	LS7vmsNmcbtxBZvFrd4DzBb7LvxhtdjQ18/kwO6xa+ccVo+ds+6ye2xeUu/Rt2UVo8fnTXIB
	rFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDM2TbrDXrBLuuLMj38sDYwH
	xboYOTkkBEwkZu9qZ4OwxSQu3FsPZHNxCAlMZ5SYOGs+E0hCSOAVo8S2PSkgNq+AlsSEL41g
	cRYBVYl92++wgNhsQPH9L26ADRIVCJNYOf0KC0S9oMSPyffAbBEBZYmb3XOYQBYwC1xilOi/
	8Q9skLCAnUTrxf/sEMucJRZtfMUMYnMKuEg8+HmWFcRmFtCR2N86jQ3ClpfYvOYt8wRGgVlI
	dsxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFR/Ux6B+OqBotDjAIcjEo8
	vC/2ngoSYk0sK67MPcQowcGsJMKrmXI6SIg3JbGyKrUoP76oNCe1+BBjMjAIJjJLiSbnAxNO
	Xkm8obGJmZGlkbmhhZGxOWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwrtoUv37tWRvm
	VZEpy8VMJ8q1rOGsNJdWi657ucqPRfVJ9HXPK5dMBFP/eq1umr0x7jrbLtGzTqd2Fh5yVTnm
	alQ5wV2xeLKGkdEy7dj1TIHlHwplskK0Zs9YoCy/7mRAj9SflWtVDvEKfe7Q+rfg27y29Z3G
	oRdWTTfKi67ePpnpZilz/U55JZbijERDLeai4kQArpbxNy4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has conflict as following:
You have to implement extcon patch based mainline extcon-next branch.

Applying: extcon: gpio: Add power resume support
error: patch failed: drivers/extcon/extcon-gpio.c:103
error: drivers/extcon/extcon-gpio.c: patch does not apply
Patch failed at 0001 extcon: gpio: Add power resume support
The copy of the patch that failed is found in:
   /home/cwchoi00/kernel/git.kernel/extcon/.git/rebase-apply/patch
When you have resolved this problem, run "git am --resolved".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

This time, I will manually apply this patch on extcon branch.

Thanks,
Chanwoo Choi

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
> diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
> index 4195810..c7f0c3e 100644
> --- a/include/linux/extcon/extcon-gpio.h
> +++ b/include/linux/extcon/extcon-gpio.h
> @@ -51,6 +51,7 @@ struct gpio_extcon_platform_data {
>  	/* if NULL, "0" or "1" will be printed */
>  	const char *state_on;
>  	const char *state_off;
> +	bool check_on_resume;
>  };
> 
>  #endif /* __EXTCON_GPIO_H__ */
> --
> 1.7.5.4
> 
> 

