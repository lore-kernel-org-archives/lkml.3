Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3GYBvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:51:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40741 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3GYBvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:51:05 -0400
X-AuditID: cbfee68e-b7f276d000002279-59-51f084876b5f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-29-git-send-email-gregkh@linuxfoundation.org>
In-reply-to: <1374703539-9705-29-git-send-email-gregkh@linuxfoundation.org>
Subject: Re: [PATCH 28/36] video: backlight: lcd: convert class code to use
 dev_groups
Date: Thu, 25 Jul 2013 10:51:02 +0900
Message-id: <000501ce88d9$6b3f62c0$41be2840$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHmmxXO7mceqhZGJB2ibqCJPHJ2SgI/Rgw5mTKBzrA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zfd32lg+BBqfa+CyaF69ns7i88BKr
	xeVdc9gsdu96yurA4rF/7hp2jz3zf7B69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bWG5eZ
	C37JVJy88Ym9gXGfeBcjJ4eEgInE/AO3GCFsMYkL99azdTFycQgJLGOUuP75FitM0euuN0wQ
	iUWMEjdnHINyfjFKLD3awARSxSagJvHly2F2EFtEIFTi/+5msG5mAS+JX4ePgcWFBLoYJZrO
	+YHYnALeEl8+bQJazcEhLBAhcXSFNkiYRUBV4tH/T8wgYV4BS4lZVyxAwrwCghI/Jt9jgZio
	JbF+53EmCFteYvOat8wQdypI7Dj7mhHiAiuJvsWfoS4Qkdj34h0jyMkSApfYJU6dXMsOsUtA
	4tvkQywguyQEZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGR
	XnFibnFpXrpecn7uJkZIVPbtYLx5wPoQYzLQ+onMUqLJ+cCoziuJNzQ2M7IwNTE1NjK3NCNN
	WEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo56MqRaXRtSiSxtVdzrVH1kuELvV
	ZRG7w9H2Gnuuh1XJk9yPXTjPuX3PX9Fc/ir3pIdFdarv5skWzmjorXlYe8ZY7vw9/7Dtkg8X
	cO9Y1XT/l4xM5uxDPZL31fe864s6v1ruWOGSXrWOFeul3Hn3t5r03Z1uxTW1JVdyxmX2Y5vc
	T84xyprzSImlOCPRUIu5qDgRAPEQ/t/gAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd32lg+BBsu+c1o0L17PZnF54SVW
	i8u75rBZ7N71lNWBxWP/3DXsHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMrTcuMxf8kqk4eeMTewPjPvEuRk4OCQETidddb5ggbDGJC/fW
	s3UxcnEICSxilLg54xgThPOLUWLp0QawKjYBNYkvXw6zg9giAqES/3c3s4LYzAJeEr8OHwOL
	Cwl0MUo0nfMDsTkFvCW+fNrE2MXIwSEsECFxdIU2SJhFQFXi0f9PzCBhXgFLiVlXLEDCvAKC
	Ej8m32OBmKglsX7ncSYIW15i85q3zBB3KkjsOPuaEeICK4m+xZ+hLhCR2PfiHeMERqFZSEbN
	QjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHPPPpHYwrmywOMQowMGo
	xMO74vv7QCHWxLLiytxDjBIczEoivLEVHwKFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+Y
	jvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgTGf9azuRa0r
	qirM2XvcLLbvU73P4LGNb+0C+cJs5nda39yMVnas2DD1zdqN8xe2MPVnJSyZt/bPp8aXnYzM
	3K8cbsbETpozKfryW9m9D6+sWi4r/Tq4INtlav23P8dd73xl9TlcHPeu9//mP/vylRMvfH1g
	cFpHSXxDK+/OzONf369P/bl0m8UtJZbijERDLeai4kQAAOoohD0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 7:06 AM, Greg Kroah-Hartman wrote:
> 
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the video backlight lcd class
> code to use the correct field.
> 
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Richard, feel free to take this through your tree, or ACK it and I can
> take it through mine.

Hi Greg Kroah-Hartman,

I hope that it will go through your tree with my Ack.

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
>  drivers/video/backlight/lcd.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
> index 41964a71..93cf15ef 100644
> --- a/drivers/video/backlight/lcd.c
> +++ b/drivers/video/backlight/lcd.c
> @@ -89,7 +89,7 @@ static inline void lcd_unregister_fb(struct lcd_device *ld)
>  }
>  #endif /* CONFIG_FB */
> 
> -static ssize_t lcd_show_power(struct device *dev, struct device_attribute *attr,
> +static ssize_t lcd_power_show(struct device *dev, struct device_attribute *attr,
>  		char *buf)
>  {
>  	int rc;
> @@ -105,7 +105,7 @@ static ssize_t lcd_show_power(struct device *dev, struct device_attribute *attr,
>  	return rc;
>  }
> 
> -static ssize_t lcd_store_power(struct device *dev,
> +static ssize_t lcd_power_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	int rc;
> @@ -128,8 +128,9 @@ static ssize_t lcd_store_power(struct device *dev,
> 
>  	return rc;
>  }
> +static DEVICE_ATTR_RW(lcd_power);
> 
> -static ssize_t lcd_show_contrast(struct device *dev,
> +static ssize_t contrast_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	int rc = -ENXIO;
> @@ -143,7 +144,7 @@ static ssize_t lcd_show_contrast(struct device *dev,
>  	return rc;
>  }
> 
> -static ssize_t lcd_store_contrast(struct device *dev,
> +static ssize_t contrast_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	int rc;
> @@ -166,14 +167,16 @@ static ssize_t lcd_store_contrast(struct device *dev,
> 
>  	return rc;
>  }
> +static DEVICE_ATTR_RW(contrast);
> 
> -static ssize_t lcd_show_max_contrast(struct device *dev,
> +static ssize_t max_contrast_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct lcd_device *ld = to_lcd_device(dev);
> 
>  	return sprintf(buf, "%d\n", ld->props.max_contrast);
>  }
> +static DEVICE_ATTR_RO(max_contrast);
> 
>  static struct class *lcd_class;
> 
> @@ -183,12 +186,13 @@ static void lcd_device_release(struct device *dev)
>  	kfree(ld);
>  }
> 
> -static struct device_attribute lcd_device_attributes[] = {
> -	__ATTR(lcd_power, 0644, lcd_show_power, lcd_store_power),
> -	__ATTR(contrast, 0644, lcd_show_contrast, lcd_store_contrast),
> -	__ATTR(max_contrast, 0444, lcd_show_max_contrast, NULL),
> -	__ATTR_NULL,
> +static struct attribute *lcd_device_attrs[] = {
> +	&dev_attr_lcd_power.attr,
> +	&dev_attr_contrast.attr,
> +	&dev_attr_max_contrast.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(lcd_device);
> 
>  /**
>   * lcd_device_register - register a new object of lcd_device class.
> @@ -344,7 +348,7 @@ static int __init lcd_class_init(void)
>  		return PTR_ERR(lcd_class);
>  	}
> 
> -	lcd_class->dev_attrs = lcd_device_attributes;
> +	lcd_class->dev_groups = lcd_device_groups;
>  	return 0;
>  }
> 
> --
> 1.8.3.rc0.20.gb99dd2e

