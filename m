Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3IKBQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:16:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13607 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3IKBQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:16:25 -0400
X-AuditID: cbfee68e-b7f756d000004512-6f-522fc4680947
Message-id: <522FC468.3010005@samsung.com>
Date: Wed, 11 Sep 2013 10:16:24 +0900
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
Subject: Re: [PATCH 1/6] extcon-gpio: Do not unnecessarily initialize variables
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-2-git-send-email-linux@roeck-us.net>
In-reply-to: <1377836978-24082-2-git-send-email-linux@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWyRsSkRDfjiH6QwZsFghbzj5xjtTjwZwej
	xZveDhaLy7vmsFk8WXiGyWLp9YtMFrcbV7BZTJi+lsXi8IoDTBavDraxOHB5rJm3htFjwecr
	7B6vJ09g9LhzbQ+bx87vDewefVtWMXp83iTnsXFuaABHFJdNSmpOZllqkb5dAlfG+VmSBbdZ
	K7b9PcfYwHiJpYuRk0NCwETi1KcHTBC2mMSFe+vZuhi5OIQEljJKzFo0lRWm6Nf2ZqjEIkaJ
	L7PmMkE4rxgl5t7ZwAhSxSugJXH261+wDhYBVYmLF2Yxg9hsQPH9L26wgdiiAmESK6dfYYGo
	F5T4MfkemC0ioCbRfKoFbAOzwCUmidZPa8ESwgL+Eu1fd4ANFRKolpi+dibYrZwCzhJPus+B
	xZkFdCT2t05jg7DlJTavecsMMkhC4Ce7xLY1vcwQFwlIfJt8CGgoB1BCVmLTAWaI1yQlDq64
	wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECY/b0v2d9Oxhv
	HrA+xJgMtHIis5Rocj4w5vNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwFgxX+UP89OAmuAzDof9k7L+swav7ktNebBrt+eUINNNZZvETkQlXN1x
	h2FufHBRREBQksLhM/V250/1RC3jjJlZvj1y8YTo9IVb47yXsfjz/J260yphR7/bOruekMvP
	ZD336QbW33a/dXvRk/QYnrqHFQuOHvrB1SpiPWPT1y8HkxKU+BdfPajEUpyRaKjFXFScCABB
	/QDz7wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd2MI/pBBs9nc1rMP3KO1eLAnx2M
	Fm96O1gsLu+aw2bxZOEZJoul1y8yWdxuXMFmMWH6WhaLwysOMFm8OtjG4sDlsWbeGkaPBZ+v
	sHu8njyB0ePOtT1sHju/N7B79G1ZxejxeZOcx8a5oQEcUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCWsYM87Pkiy4zVqx7e85xgbGSyxdjJwcEgImEr+2N7NB2GISF+6tB7K5
	OIQEFjFKfJk1lwnCecUoMffOBkaQKl4BLYmzX/+ygtgsAqoSFy/MYgax2YDi+1/cAJskKhAm
	sXL6FRaIekGJH5PvgdkiAmoSzadawDYwC1xikmj9tBYsISzgL9H+dQfYUCGBaonpa2cygdic
	As4ST7rPgcWZBXQk9rdOY4Ow5SU2r3nLPIFRYBaSHbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFe
	cWJucWleul5yfu4mRnBCeCa9g3FVg8UhRgEORiUe3hty+kFCrIllxZW5hxglOJiVRHinOgGF
	eFMSK6tSi/Lji0pzUosPMSYDg2Ais5Rocj4wWeWVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQ
	SCA9sSQ1OzW1ILUIZgsTB6dUA2NP4HXW9tf54kt5HS9f3m2fOinpyIMPUh+1VQIWNmml+dUo
	fgmPsNvPuU1dkOFsXsTVtx8uPb2gP8Ot55L14S0z/y44naPdvuHtsr/vyqNSnHZ9CRX5e6py
	5unyp1GPROI5/t+cc6Pee/K7o096J+0v+Lfc0SnUWHNuKktfotTVJXwv713z3V2qxFKckWio
	xVxUnAgAKgP96UwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 01:29 PM, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/extcon/extcon-gpio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 02bec32..77d35a7 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -80,7 +80,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  {
>  	struct gpio_extcon_platform_data *pdata = pdev->dev.platform_data;
>  	struct gpio_extcon_data *extcon_data;
> -	int ret = 0;
> +	int ret;
>  
>  	if (!pdata)
>  		return -EBUSY;
> 

Applied it on extcon-linus branch.

Thanks.
Chanwoo Choi
