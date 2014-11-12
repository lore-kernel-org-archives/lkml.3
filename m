Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaKLBM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:12:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45711 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaKLBMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:12:54 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f0-5462b413b827
Message-id: <5462B413.2090502@samsung.com>
Date: Wed, 12 Nov 2014 10:12:51 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: myungjoo.ham@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rongjun.ying@csr.com, Baohua.Song@csr.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RESEND PATCH 2/2] extcon: gpio: Add support for using cable names
References: <1415201388-32060-1-git-send-email-george.cherian@ti.com>
 <1415201388-32060-3-git-send-email-george.cherian@ti.com>
In-reply-to: <1415201388-32060-3-git-send-email-george.cherian@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkQFdkS1KIwZkgi5czr7JazD9yjtWi
	/81CVotTB5ezWpx7tZLR4vKuOWwWs5f0s1gsvX6RyeJ24wo2iwnT17JYtO49wm6x78IfVgce
	jzXz1jB6XO7rZfLYtXMOq8fK5V/YPDat6mTz6NuyitHj+I3tTB6fN8kFcERx2aSk5mSWpRbp
	2yVwZbz8uIyt4JpgxfU1E5kaGBfzdTFyckgImEj83/SMDcIWk7hwbz2QzcUhJLCUUWL7yW52
	mKKnJ96xgthCAtMZJe73qUAUvWaUOPtuL1iCV0BLYtbWeSwgNouAqsTDs0vB4mxA8f0vboBt
	EBUIk1g5/QoLRL2gxI/J98BsEaCa/kvdTCBDmQWmMUm8m36NsYuRg0NYwF9ic3sixLJGRonJ
	H96ANXAKuEksbmpmBrGZBXQk9rdOY4Ow5SU2r3nLDNIgIdDJIdF0+yYrxEUCEt8mH2IBGSoh
	ICux6QAzxGeSEgdX3GCZwCg2C8lNs5CMnYVk7AJG5lWMoqkFyQXFSelFJnrFibnFpXnpesn5
	uZsYgXF8+t+zCTsY7x2wPsQowMGoxMObsCYpRIg1say4MvcQoynQFROZpUST84HJIq8k3tDY
	zMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwZfT+NmifNP+gY
	MvGPi1a6+Eefv5MkYppey7B3i4UfiMswnpInHp/Barh17uSCVqsZDIENrv6+n6fL9rJXvJo6
	4+Cx83weZkVLCg6/v7PTd4fZus9Zl0yzX08NW5yt782z8eSR5TPvzVA/Y1NUdfTF3Gsrqoom
	nnp47tS+5JrpQsfq07lznH2VWIozEg21mIuKEwEkGexC3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQV3hLUkhBs+OmFm8nHmV1WL+kXOs
	Fv1vFrJanDq4nNXi3KuVjBaXd81hs5i9pJ/FYun1i0wWtxtXsFlMmL6WxaJ17xF2i30X/rA6
	8HismbeG0eNyXy+Tx66dc1g9Vi7/wuaxaVUnm0ffllWMHsdvbGfy+LxJLoAjqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoXiWFssScUqBQQGJx
	sZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxsuPy9gKrglWXF8zkamBcTFfFyMnh4SAicTT
	E+9YIWwxiQv31rOB2EIC0xkl7vepdDFyAdmvGSXOvtsLVsQroCUxa+s8FhCbRUBV4uHZpWBx
	NqD4/hc3wJpFBcIkVk6/wgJRLyjxY/I9MFsEqKb/UjcTyFBmgWlMEu+mX2PsYuTgEBbwl9jc
	ngixrJFRYvKHN2ANnAJuEoubmplBbGYBHYn9rdPYIGx5ic1r3jJPYBSYhWTHLCRls5CULWBk
	XsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnCaeSe9gXNVgcYhRgINRiYc3Y3NSiBBrYllx
	Ze4hRgkOZiUR3gdLgUK8KYmVValF+fFFpTmpxYcYTYFBMJFZSjQ5H5jC8kriDY1NzIwsjcwN
	LYyMzZXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFxcEo1MLq6sOR82ud67UZmw99//SHhugXSdzc/
	FvZ+ZHL+q+SkxWyvbq3f5LXR0LG15jNL5WyvIiZruwU/D3ncOcN8+V3Nhp5rq1dz3v3f8ruz
	XWLiHu3l35pFqzc+Pmf4ac11hZtfAi7PWW3b+9/U+/vPc+z9J1rn/RXXiPsRMdP+JKvCMwHr
	z3uFbAyVWIozEg21mIuKEwGKsbJdKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 11/06/2014 12:29 AM, George Cherian wrote:
> Add support for using cable names. Enables other drivers to register interest
> and get notified using extcon provided notifier call backs.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  Documentation/devicetree/bindings/extcon/extcon-gpio.txt | 2 ++
>  drivers/extcon/extcon-gpio.c                             | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> index 30aa2e1..2c9d29f 100644
> --- a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> +++ b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> @@ -7,6 +7,7 @@ Required Properties:
>   - compatible: should be:
>  	* "linux,extcon-gpio"
>   - gpios: specifies the gpio pin used.
> + - cable-name: Name of the cable used.
>  
>  Optional Properties:
>   - debounce: Debounce time for GPIO IRQ in ms
> @@ -18,4 +19,5 @@ Eg:
>  		compatible = "linux,extcon-gpio";
>  		gpios = <&gpio3 12 GPIO_ACTIVE_HIGH>;
>  		debounce = <20>;
> +		cable-name = "USB-HOST";
>  		};
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 85795de..0e1b3e8 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -38,6 +38,7 @@ struct gpio_extcon_data {
>  	int irq;
>  	struct delayed_work work;
>  	unsigned long debounce_jiffies;
> +	const char *cable_name[1];

*cable_name[1] -> **cable_name

>  };
>  
>  static void gpio_extcon_work(struct work_struct *work)
> @@ -100,6 +101,9 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  				msecs_to_jiffies(debounce);
>  	}
>  
> +	of_property_read_string_index(np, "cable-name", 0,
> +				      extcon_data->cable_name);
> +	extcon_data->edev->supported_cable = extcon_data->cable_name;

It is wrong. I don't want to allocate ables to supported_cable directly.
For consistency of extcon driver, you have to add the array of supported cables
by using devm_extcon_dev_allocate().

Thanks,
Chanwoo Choi

>  	ret = devm_extcon_dev_register(&pdev->dev, extcon_data->edev);
>  	if (ret < 0)
>  		return ret;
> 

