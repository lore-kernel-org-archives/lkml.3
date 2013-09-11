Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab3IKX5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:57:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27510 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3IKX5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:57:10 -0400
X-AuditID: cbfee68e-b7f756d000004512-46-523103545d4d
Message-id: <52310355.7060004@samsung.com>
Date: Thu, 12 Sep 2013 08:57:09 +0900
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
Subject: Re: [PATCH v2 3/6] extcon-gpio: Add support for active-low presence
 detect pins
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-4-git-send-email-linux@roeck-us.net>
 <522FD20C.6080404@samsung.com> <20130911022513.GA5251@roeck-us.net>
In-reply-to: <20130911022513.GA5251@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsWyRsSkRDeE2TDI4N42U4v5R86xWhz4s4PR
	4k1vB4vF5V1z2CyeLDzDZLH0+kUmi9uNK9gsJkxfy2JxeMUBJotXB9tYHLg81sxbw+ix4PMV
	do/Xkycwety5tofNY+f3BnaPvi2rGD0+b5Lz2Dg3NIAjissmJTUnsyy1SN8ugStjyuk1TAV3
	xSsmvFnL1sDYItzFyMkhIWAi8XLvd0YIW0ziwr31bF2MXBxCAksZJc5dfMwMU3R8yjc2EFtI
	YDqjxKYlyRBFrxglOn7NYQVJ8ApoSZzsXA82iUVAVeJg52wWEJsNKL7/xQ2wZlGBMImV06+w
	QNQLSvyYfA/MFhFQk2g+1QK2mVngEpNE66e1YAlhgSiJyQ8/M0FsO8gocfDvbrBtnAKGEvcv
	bmcCsZkFdCT2t05jg7DlJTavecsM0iAh8JNdYtMiiHUsAgIS3yYfArI5gBKyEpsOQL0mKXFw
	xQ2WCYxis5AcNQvJ2FlIxi5gZF7FKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERi1p/8969vB
	ePOA9SHGZKCVE5mlRJPzgVGfVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQbGRRPLXnF8nF73MDR3tW9e1+Fb251vVyw7v9mBR3THlun3DmXM2iAi
	XRoYHuz0d8cRhx0pE+y/ly06FrRX+sRDRX7D3aHXDHYcEb6gwb9t7zHF6dFqHlE3o391mys+
	Od9SJJ1ZuFyGR2Dq/salCqv+/9m81k1yXmL7mY/W7M0vYiWiDM5OXdO2XYmlOCPRUIu5qDgR
	AGmIRnnwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQd0QZsMgg5c/dSzmHznHanHgzw5G
	ize9HSwWl3fNYbN4svAMk8XS6xeZLG43rmCzmDB9LYvF4RUHmCxeHWxjceDyWDNvDaPHgs9X
	2D1eT57A6HHn2h42j53fG9g9+rasYvT4vEnOY+Pc0ACOqAZGm4zUxJTUIoXUvOT8lMy8dFsl
	7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygI5UUyhJzSoFCAYnFxUr6dpgmhIa46VrA
	NEbo+oYEwfUYGaCBhDWMGVNOr2EquCteMeHNWrYGxhbhLkZODgkBE4njU76xQdhiEhfurQez
	hQSmM0psWpLcxcgFZL9ilOj4NYcVJMEroCVxsnM9I4jNIqAqcbBzNguIzQYU3//iBlizqECY
	xMrpV1gg6gUlfky+B2aLCKhJNJ9qYQMZyixwiUmi9dNasISwQJTE5IefmSC2HWSUOPh3N9g2
	TgFDifsXtzOB2MwCOhL7W6exQdjyEpvXvGWewCgwC8mSWUjKZiEpW8DIvIpRNLUguaA4KT3X
	UK84Mbe4NC9dLzk/dxMjOCU8k9rBuLLB4hCjAAejEg9vxyyDICHWxLLiytxDjBIczEoivLf+
	AYV4UxIrq1KL8uOLSnNSiw8xJgPDYCKzlGhyPjBd5ZXEGxqbmBlZGpkbWhgZm5MmrCTOe6DV
	OlBIID2xJDU7NbUgtQhmCxMHp1QDY/1LtVqzansWQadr8767+fkfP88qJ9KRG/Ljv6kI32lu
	tuZ5EVp/FLf6/7xsfGEB90+pKZasr3+ZiFXn5cqUiUo77oh6JaEm/7N3ubnQ379crxcn7F4Y
	M6Hgt/wZTb3PUnUrp+1/pt1irnD3cxNP37R4O+ltylPvW+YvaP++zPOm9LPTDaqZSizFGYmG
	WsxFxYkABltAu00DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

As I mentioned on previous reply, I modify patch name as following:
extcon-gpio: Add support for active-low presence detect pins
->
extcon: gpio: Add support for active-low presence detect pins

I prefer you could add patch description. Also, you should test
on extcon latest branch to protect merge conflict. This patch
has conflict issue on extcon-linus branch. I fix up and applied it.

And I think you might use tab size is 4 characters. you should change tab size
from 4 characters to 8 characters. You can check linux kernel coding sytle on
"/kernel/Documentation/CodingStyle - chapter 1: Indentation".

On 09/11/2013 11:25 AM, Guenter Roeck wrote:
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Document gpio_active_low variable in gpio_extcon_platform_data
>     Rewrite active-low logic to be easier to read.
> 
>  drivers/extcon/extcon-gpio.c       |    4 ++++
>  include/linux/extcon/extcon-gpio.h |    5 +++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 862743b..8491f86 100644
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
> @@ -49,6 +50,8 @@ static void gpio_extcon_work(struct work_struct *work)
>  			     work);
>  
>  	state = gpio_get_value(data->gpio);
> +	if (data->gpio_active_low)
> +		state = !state;
>  	extcon_set_state(&data->edev, state);
>  }
>  
> @@ -96,6 +99,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  
>  	extcon_data->edev.name = pdata->name;
>  	extcon_data->gpio = pdata->gpio;
> +	extcon_data->gpio_active_low = pdata->gpio_active_low;
>  	extcon_data->state_on = pdata->state_on;
>  	extcon_data->state_off = pdata->state_off;
>  	if (pdata->state_on && pdata->state_off)
> diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
> index 2d8307f..51ef15c 100644
> --- a/include/linux/extcon/extcon-gpio.h
> +++ b/include/linux/extcon/extcon-gpio.h
> @@ -27,6 +27,10 @@
>   * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
>   * @name	The name of this GPIO extcon device.
>   * @gpio	Corresponding GPIO.
> + * @gpio_active_low:
> + * 		Boolean describing whether gpio active state is 1 or 0
> + * 		If true, low state of gpio means active.
> + * 		If false, high state of gpio means active.

I think you may use tab size is 4 characters.

>   * @debounce	Debounce time for GPIO IRQ in ms.
>   * @irq_flags	IRQ Flags (e.g., IRQF_TRIGGER_LOW).
>   * @state_on	print_state is overriden with state_on if attached. If Null,
> @@ -41,6 +45,7 @@
>  struct gpio_extcon_platform_data {
>  	const char *name;
>  	unsigned gpio;
> +	bool gpio_active_low;
>  	unsigned long debounce;
>  	unsigned long irq_flags;
>  
> 

