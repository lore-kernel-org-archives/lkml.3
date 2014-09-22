Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaIVHzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:55:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36106 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaIVHy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:54:58 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-61-541fd5c542de
Message-id: <541FD5C5.5040901@samsung.com>
Date: Mon, 22 Sep 2014 16:54:45 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        myungjoo.ham@samsung.com, grant.likely@linaro.org,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] extcon: gpio: Minor cleanups
References: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
 <1410236078-11713-2-git-send-email-george.cherian@ti.com>
In-reply-to: <1410236078-11713-2-git-send-email-george.cherian@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWyRsSkQPfoVfkQg92rzC3mHznHatH/ZiGr
	xamDy1ktDvzZwWhx7tVKRovLu+awWTxZeIbJYun1i0wWtxtXsFlMmL6WxaJ17xF2i30X/rA6
	8HismbeG0eNyXy+Tx66dc1g9Vi7/wuaxaVUnm8eda3vYPHZ+b2D36NuyitHj+I3tTB6fN8kF
	cEVx2aSk5mSWpRbp2yVwZdzq3sJWcE2w4uqxj4wNjBv5uhg5OSQETCQufDnCBmGLSVy4tx7I
	5uIQEljKKHFp11X2LkYOsKJnb5Qh4tMZJTbcWckI4bxmlLiy7zgrSDevgJbEsvtTmUFsFgFV
	if6WhWBT2YDi+1/cALNFBcIkVk6/wgJRLyjxY/I9MFsEqKb/UjcTyFBmgUlMEtu294ElhAVM
	Jbq3/2SG2NbIKLHgQQ9YglPATWLOsVmMIDazgI7E/tZpbBC2vMTmNW/BGiQEZnJILHl/jhXi
	JAGJb5MPsUD8Iyux6QAzxM+SEgdX3GCZwCg2C8lRs5CMnYVk7AJG5lWMoqkFyQXFSelFJnrF
	ibnFpXnpesn5uZsYgfF9+t+zCTsY7x2wPsQowMGoxMP7o0U+RIg1say4MvcQoynQFROZpUST
	84FJJK8k3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyF
	X5at/pz8YZtU5PlgrYba800bzqwJu97SF7vHOfjN5cxb+yXdnPdnryloqp+x54lIyg6LVtb2
	9Va3N/maCv97vyrznPNeYVXmJP+ANYcTD63Jv2ewZ/Mc7neXP79Vv3hWRJPRR12vNTessWj/
	46X9MReM9z3sZdgx+y0z96eUV+7CB5ncJtYpsRRnJBpqMRcVJwIAd7QwXuoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd2jV+VDDA7d0beYf+Qcq0X/m4Ws
	FqcOLme1OPBnB6PFuVcrGS0u75rDZvFk4Rkmi6XXLzJZ3G5cwWYxYfpaFovWvUfYLfZd+MPq
	wOOxZt4aRo/Lfb1MHrt2zmH1WLn8C5vHplWdbB53ru1h89j5vYHdo2/LKkaP4ze2M3l83iQX
	wBXVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S5
	kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjVvcWtoJrghVXj31kbGDc
	yNfFyMEhIWAi8eyNchcjJ5ApJnHh3nq2LkYuDiGB6YwSG+6sZIRwXjNKXNl3nBWkildAS2LZ
	/anMIDaLgKpEf8tCNhCbDSi+/8UNMFtUIExi5fQrLBD1ghI/Jt8Ds0WAavovdTOBDGUWmMQk
	sW17H1hCWMBUonv7T2aIbY2MEgse9IAlOAXcJOYcm8UIYjML6Ejsb53GBmHLS2xe85Z5AqPA
	LCRLZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4OTxTGoH48oGi0OMAhyM
	Sjy8C5rkQ4RYE8uKK3MPMUpwMCuJ8B7NAQrxpiRWVqUW5ccXleakFh9iNAWGwURmKdHkfGBi
	yyuJNzQ2MTOyNDI3tDAyNlcS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwJitreD4bdfOjWpm
	QSqB3+dEx3ukPJ20fuaU2gP/9y8q6Zn1qGPGzudZLEo+VVp/vssbiet8+KhzMsytO2zJzaeF
	spe61xnulHpcXHuBeU6Y1/0S5sgr33XXHzjyNqPJV5aD+/El96gLfwVXnAmIb2V6w9VyZ9JP
	2QKDHyaK5dlrFLrNzWb9tlRiKc5INNRiLipOBADegW48NAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 09/09/2014 01:14 PM, George Cherian wrote:
> Minor Cleanups
>  - Order the include files in alphabetical order.
>  - Fix description of state_off in extcon_gpio.h
>  - Add a descrition for check_on_resume in extcon_gpio.h
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>

I modify the name/description of patch to keep standary coding style
and applied it.

Thanks,
Chanwoo Choi

> ---
>  drivers/extcon/extcon-gpio.c       | 10 +++++-----
>  include/linux/extcon/extcon-gpio.h |  4 +++-
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 5b7ec27..72f19a3 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -20,16 +20,16 @@
>   *
>  */
>  
> -#include <linux/module.h>
> -#include <linux/kernel.h>
> +#include <linux/extcon.h>
> +#include <linux/extcon/extcon-gpio.h>
> +#include <linux/gpio.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
> -#include <linux/gpio.h>
> -#include <linux/extcon.h>
> -#include <linux/extcon/extcon-gpio.h>
>  
>  struct gpio_extcon_data {
>  	struct extcon_dev *edev;
> diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
> index 8900fdf..0b17ad4 100644
> --- a/include/linux/extcon/extcon-gpio.h
> +++ b/include/linux/extcon/extcon-gpio.h
> @@ -34,8 +34,10 @@
>   * @irq_flags:		IRQ Flags (e.g., IRQF_TRIGGER_LOW).
>   * @state_on:		print_state is overriden with state_on if attached.
>   *			If NULL, default method of extcon class is used.
> - * @state_off:		print_state is overriden with state_on if detached.
> + * @state_off:		print_state is overriden with state_off if detached.
>   *			If NUll, default method of extcon class is used.
> + * @check_on_resume:	Boolean describing whether to check the state of gpio
> + *			while resuming from sleep.
>   *
>   * Note that in order for state_on or state_off to be valid, both state_on
>   * and state_off should be not NULL. If at least one of them is NULL,
> 

