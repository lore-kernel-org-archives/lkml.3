Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3IKCOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:14:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46829 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3IKCOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:14:37 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-23-522fd20b03ee
Message-id: <522FD20C.6080404@samsung.com>
Date: Wed, 11 Sep 2013 11:14:36 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 3/6] extcon-gpio: Add support for active-low presence
 detect pins
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-4-git-send-email-linux@roeck-us.net>
In-reply-to: <1377836978-24082-4-git-send-email-linux@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWyRsSkQJf7kn6Qwcepyhbzj5xjtTjwZwej
	xZveDhaLy7vmsFk8WXiGyWLp9YtMFrcbV7BZTJi+lsXi8IoDTBavDraxOHB5rJm3htFjwecr
	7B6vJ09g9LhzbQ+bx87vDewefVtWMXp83iTnsXFuaABHFJdNSmpOZllqkb5dAlfG741r2Aue
	iVb8+1HUwDhDsIuRk0NCwERi74NLjBC2mMSFe+vZuhi5OIQEljJKvJ30nAmmqHXNbKjEdEaJ
	lvUboZxXjBJnl15hBaniFdCSuD/zDTuIzSKgKtF+7AfYWDag+P4XN9hAbFGBMImV06+wQNQL
	SvyYfA/MFhFQk2g+1QI2lFngEpNE66e1YAlhgXCJnSu2gTULCVRLHL/+EmwBp4CzxNPXS5lB
	bGYBHYn9rdPYIGx5ic1r3jKDDJIQ+MkuMf/zTzaIiwQkvk0+BDSUAyghK7HpADPEa5ISB1fc
	YJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiBMXv637OJOxjv
	H7A+xJgMtHIis5Rocj4w5vNK4g2NzYwsTE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwLhyiaRY4MJvzHZTTEzCV8z5+8cnLDfis2r3Ipk3a9lmtp58v+Dleu+b
	mi4b26PF3/kHnulY8Fvv0JK6r3W/9yQ0tznMZVd7+Pf1yuzMq28f8E7310xcp+lTzJg/+bZm
	hUL1gunm/H/C9k5ja/1fvnrFh1hBl3OP9Mr29S6Ov/77sXTnk+yQXTxKLMUZiYZazEXFiQDl
	Ku3C7wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQV3uS/pBBi9/SVnMP3KO1eLAnx2M
	Fm96O1gsLu+aw2bxZOEZJoul1y8yWdxuXMFmMWH6WhaLwysOMFm8OtjG4sDlsWbeGkaPBZ+v
	sHu8njyB0ePOtT1sHju/N7B79G1ZxejxeZOcx8a5oQEcUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCWsYM35vXMNe8Ey04t+PogbGGYJdjJwcEgImEq1rZrNB2GISF+6tB7K5
	OIQEpjNKtKzfCOW8YpQ4u/QKK0gVr4CWxP2Zb9hBbBYBVYn2Yz8YQWw2oPj+FzfAJokKhEms
	nH6FBaJeUOLH5HtgtoiAmkTzqRawocwCl5gkWj+tBUsIC4RL7FyxDaxZSKBa4vj1l2ALOAWc
	JZ6+XsoMYjML6Ejsb53GBmHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj8ypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4ITwTHoH46oGi0OMAhyMSjy8N+T0g4RYE8uKK3MPMUpwMCuJ8E51Agrx
	piRWVqUW5ccXleakFh9iTAYGwURmKdHkfGCyyiuJNzQ2MTOyNDI3tDAyNidNWEmc92CrdaCQ
	QHpiSWp2ampBahHMFiYOTqkGxpY/aW1cn00Li7vL7Jy25mh/ufvVj3/XarWXZ3f0PA19MrVD
	2+pd+YKWSo3S7phHqtWTOh5rm1/q3baxM+jZ3B+STFukecIn3mVSOxgj9IZz9iHB6dtEKiNm
	zPRaGhrFYfbmztp9TP9vH7b8lh+tvXAdx5X9vvPML3sdXabSFnPv+MK1bZLPXiixFGckGmox
	FxUnAgDb7EdFTAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 01:29 PM, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/extcon/extcon-gpio.c       |    4 +++-
>  include/linux/extcon/extcon-gpio.h |    1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 973600e..d4e3c89 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -34,6 +34,7 @@
>  struct gpio_extcon_data {
>  	struct extcon_dev edev;
>  	unsigned gpio;
> +	bool gpio_active_low;
>  	const char *state_on;
>  	const char *state_off;
>  	int irq;
> @@ -48,7 +49,7 @@ static void gpio_extcon_work(struct work_struct *work)
>  		container_of(to_delayed_work(work), struct gpio_extcon_data,
>  			     work);
>  
> -	state = gpio_get_value(data->gpio);
> +	state = gpio_get_value(data->gpio) ^ data->gpio_active_low;

I prefer below modified code instead of exclusive keyword(^) to improve readability.

       state = gpio_get_value(data->gpio);
       if (data->gpio_active_low)
               state = !state;

>  	extcon_set_state(&data->edev, state);
>  }
>  
> @@ -96,6 +97,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  
>  	extcon_data->edev.name = pdata->name;
>  	extcon_data->gpio = pdata->gpio;
> +	extcon_data->gpio_active_low = pdata->gpio_active_low;
>  	extcon_data->state_on = pdata->state_on;
>  	extcon_data->state_off = pdata->state_off;
>  	if (pdata->state_on && pdata->state_off)
> diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
> index 2d8307f..1613899 100644
> --- a/include/linux/extcon/extcon-gpio.h
> +++ b/include/linux/extcon/extcon-gpio.h
> @@ -41,6 +41,7 @@
>  struct gpio_extcon_platform_data {
>  	const char *name;
>  	unsigned gpio;
> +	bool gpio_active_low;

You have to add description of gpio_active_low as folloiwng patch:

diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
index 7a2f27b..ff0bfcb 100644
--- a/include/linux/extcon/extcon-gpio.h
+++ b/include/linux/extcon/extcon-gpio.h
@@ -27,6 +27,9 @@
  * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
  * @name:              The name of this GPIO extcon device.
  * @gpio:              Corresponding GPIO.
+ * @gpio_active_low:   Boolean which is whether gpio active state is 1 or 0
+ *                     If true, low state of gpio means active.
+ *                     If false, high state of gpio means active.
  * @debounce:          Debounce time for GPIO IRQ in ms.
  * @irq_flags:         IRQ Flags (e.g., IRQF_TRIGGER_LOW).
  * @state_on:          print_state is overriden with state_on if attached.

Thanks,
Chanwoo Choi
