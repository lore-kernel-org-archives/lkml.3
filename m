Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3KYCh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 21:37:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21175 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3KYChP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 21:37:15 -0500
X-AuditID: cbfee68f-b7f336d00000481b-71-5292b7d91e2f
Date: Mon, 25 Nov 2013 02:37:13 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: gpio: Request gpio pin before modifying its state
To: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20131125023425676@myungjoo.ham
Msgkey: 20131125023425676@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131125023425676@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6748233.22261385347032615.JavaMail.weblogic@epv6ml03>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSpHtz+6Qgg5NrxC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG3/YpLAWTRCpeLNjI1sB4RriLkZNDSEBdYtGSk2wgtoSAicS1
	vZeYIWwxiQv31gPFuYBqljJKbN2xC67o1fGpjBCJ+YwSx08eZwVJsAioSpy+OYeli5GDg01A
	T2Lm52SQsLCAn0TXv39gJSICmRKr18xmB7GZBWwljl1byg5xhJLEmn2vWEBsXgFBiZMzn7BA
	7FKVeLrzCNhIXgE1iS+HYiHCEhKzpl9ghbB5JWa0P4Uql5OY9nUN1P3SEudnbWCE+WXx98dQ
	cX6JY7d3MIGMBOl9cj8YZszuzV+gPhSQmHrmIFSrlsSae/+hbD6JNQvfssCM2XVqOTNM7/0t
	c5kgvlKUmNL9EOpDLYkvP/axofuKV8BJ4uafWewTGJVnIUnNQtI+C0k7spoFjCyrGEVTC5IL
	ipPSi4z1ihNzi0vz0vWS83M3MQKTwul/z/p3MN49YH2IMRkYIROZpUST84FJJa8k3tDYzMjC
	1MTU2Mjc0ow0YSVx3vsPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1ME6b9XL/tR3pMyql
	bjOYds2UuxErb3NZ94SP1NxPLg3qc9+LWqbOrn5c9TNVW5tP9NuW8tyNL/OO/jcVvyjh4hQ7
	aZ5Gpop49cO5twomTzrjJrEx2z3gZXvwgVsJrjdOTLoUxjO/vHXRufevGXbWLtG5dfelXVeK
	vsxP6cBPvhd33Mq/66sg1KbEUpyRaKjFXFScCAAmGxwZIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tGbo3t08KMmg7KWBxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jL6
	tk9hKZgkUvFiwUa2BsYzwl2MnBxCAuoSi5acZAOxJQRMJF4dn8oIYYtJXLi3HijOBVQzn1Hi
	+MnjrCAJFgFVidM357B0MXJwsAnoScz8nAwSFhbwk+j69w+sREQgU2L1mtnsIDazgK3EsWtL
	2SF2KUms2feKBcTmFRCUODnzCQvELlWJpzuPgI3kFVCT+HIoFiIsITFr+gVWCJtXYkb7U6hy
	OYlpX9cwQ9jSEudnbYA7efH3x1Bxfoljt3cwgYwE6X1yPxhmzO7NX6C+FZCYeuYgVKuWxJp7
	/6FsPok1C9+ywIzZdWo5M0zv/S1zmSC+UpSY0v0Q6kMtiS8/9rGh+4pXwEni5p9Z7BMY5WYh
	Sc1C0j4LSTuymgWMLKsYRVMLkguKk9IrDPWKE3OLS/PS9ZLzczcxglPTs4U7GL+ctz7EKMDB
	qMTDa1E5KUiINbGsuDL3EKMEB7OSCO+eOqAQb0piZVVqUX58UWlOavEhxmRg9E1klhJNzgem
	zbySeENjYxMzE1NLEwsDU3PShJXEee/eTAoSEkhPLEnNTk0tSC2C2cLEwSnVwBho/OaaolPs
	+9tTCyYKWz978WiiZOrqzZZ+bcXTDU6knFSeyDZl4mb3O96X3Lf/VohIiNN4XCTuUhv8/snk
	CfPWRbDpCJ5omNf1Y72M9aJQzYPXV3lzul0L9rsc3KljJJJ6KTjdZsOcvORLpcrimWVpDJMv
	H3R5VcGy8p1Er962lZ9TgwrlfymxFGckGmoxFxUnAgDuGJVfkQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAP2bbgI032345

> Commit 338de0ca (extcon: gpio: Use gpio driver/chip debounce if supported)
> introduced a call to gpio_set_debounce() before actually requesting the
> respective gpio pin from the gpio subsystem.
> 
> The gpio subsystem expects that a gpio pin was requested before modifying its
> state. Not doing so results in a warning from gpiolib, and the gpio pin is
> auto-requested. This in turn causes the subsequent devm_gpio_request_one()
> to fail. So devm_gpio_request_one() must be called prior to calling
> gpio_set_debounce().
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Thank you.


Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/extcon/extcon-gpio.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 7e0dff5..4736a9c 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -105,6 +105,12 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  	extcon_data->state_off = pdata->state_off;
>  	if (pdata->state_on && pdata->state_off)
>  		extcon_data->edev.print_state = extcon_gpio_print_state;
> +
> +	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
> +				    pdev->name);
> +	if (ret < 0)
> +		return ret;
> +
>  	if (pdata->debounce) {
>  		ret = gpio_set_debounce(extcon_data->gpio,
>  					pdata->debounce * 1000);
> @@ -117,11 +123,6 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
> -				    pdev->name);
> -	if (ret < 0)
> -		goto err;
> -
>  	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
>  
>  	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
> -- 
> 1.7.9.7
> 
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
