Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaAGCwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:52:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28883 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431AbaAGCwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:52:16 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-23-52cb6bde3add
Message-id: <52CB6BE0.1090409@samsung.com>
Date: Tue, 07 Jan 2014 11:52:16 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: rjying <rjying@gmail.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Barry Song <Barry.Song@csr.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>
Subject: Re: [PATCH v2] extcon: gpio: Add power resume support
References: <1388122847-3276-1-git-send-email-rongjun.ying@csr.com>
In-reply-to: <1388122847-3276-1-git-send-email-rongjun.ying@csr.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkUPde9ukggym/lSwuT1rPZLHp8TVW
	i8u75rBZ3G5cwWZxq/cAs8W+C39YLTb09TM5sHvs2jmH1WPnrLvsHpuX1Hv0bVnF6PF5k1wA
	axSXTUpqTmZZapG+XQJXxvempawFJ0UrTjScZGlgPCDYxcjJISFgItExaw8rhC0mceHeerYu
	Ri4OIYGljBJn//5mgyl6vnkDK0RiEaPEs93HoZxXjBI915awg1TxCmhJtLY8BhvFIqAqceru
	a0YQmw0ovv/FDbBJogJhEiunX2GBqBeU+DH5HpDNwSEiICtx9mw4yExmgUuMEv03/jGB1AgL
	2ElsenISbI6QgLPEryffwOZwCrhIvF57kRnEZhbQkdjfOo0NwpaX2LzmLTPE1ZfYJY5szIa4
	R0Di2+RDYLskgHZtOgBVIilxcMUNlgmMYrOQXDQLydRZSKYuYGRexSiaWpBcUJyUXmSqV5yY
	W1yal66XnJ+7iREYdaf/PZu4g/H+AetDjMlAKycyS4km5wOjNq8k3tDYzMjC1MTU2Mjc0ow0
	YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGDvctwWviVkheFl1++1+M/f81a8Z
	Vu/ukDV6Ue/Y+r1fiq95s/2syplbd0n1vS0t3yGr/qH77HqlIB8z3R03IuP3eS5lWXlw5aRT
	0/WeaJz7FBd6w1j9cmlmDvfZB8WXJkz4uenZG1eDc+U+37h6vQqKT4vrTE3dEiKzSetuhfP7
	BfJfbq499laJpTgj0VCLuag4EQCxmYpj0AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd172aeDDN7/kbK4PGk9k8Wmx9dY
	LS7vmsNmcbtxBZvFrd4DzBb7LvxhtdjQ18/kwO6xa+ccVo+ds+6ye2xeUu/Rt2UVo8fnTXIB
	rFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDO+Ny1lLTgpWnGi4SRLA+MB
	wS5GTg4JAROJ55s3sELYYhIX7q1n62Lk4hASWMQo8Wz3cVYI5xWjRM+1JewgVbwCWhKtLY/B
	OlgEVCVO3X3NCGKzAcX3v7jBBmKLCoRJrJx+hQWiXlDix+R7QDYHh4iArMTZs+EgM5kFLjFK
	9N/4xwRSIyxgJ7HpyUmwOUICzhK/nnwDm8Mp4CLxeu1FZhCbWUBHYn/rNDYIW15i85q3zBMY
	BWYhWTELSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH9TOpHYwrGywOMQpw
	MCrx8L7YeypIiDWxrLgy9xCjBAezkgivZsrpICHelMTKqtSi/Pii0pzU4kOMycAQmMgsJZqc
	D0w4eSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAOOv07IAv
	7d/yGi+qFbF+szxvFvX1lcGsoJkHfFzfi01Rm2dTHXD+cmfohNtf9ZiEG4IlP1bMmOHPek5K
	eL7XvEXlHH17FngIyTnrPPh1v2T66Z6dMrdM058msbG6dTvIBG4NSAyxM91S+3XFPqagn+6S
	BvcWLQiV/cS4POdYXF12TPyynfNeKLEUZyQaajEXFScCACVUA7suAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2013 02:40 PM, rjying wrote:
> From: Rongjun Ying <rongjun.ying@csr.com>
> 
> When system on the suspend state, Some SoC can't get gpio interrupt.
> After system resume, need send extcon uevent to userspace.
> 
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> ---
>  -v2: Add lost_sleep_irq flags.
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
> +	bool lost_sleep_irq;

I prefer 'check_on_resume' instead of 'load_sleep_irq'. 

>  };
>  
>  static void gpio_extcon_work(struct work_struct *work)
> @@ -103,6 +104,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  	extcon_data->gpio_active_low = pdata->gpio_active_low;
>  	extcon_data->state_on = pdata->state_on;
>  	extcon_data->state_off = pdata->state_off;
> +	extcon_data->lost_sleep_irq = pdata->lost_sleep_irq;

ditto.

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
> +	if (extcon_data->lost_sleep_irq)

ditto.

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
> +	bool lost_sleep_irq;

ditto.

>  };
>  
>  #endif /* __EXTCON_GPIO_H__ */
> 

Thanks,
Chanwoo Choi
