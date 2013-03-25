Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab3CYEbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:31:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64122 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab3CYEbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:31:05 -0400
X-AuditID: cbfee68e-b7f946d000001e37-b0-514fd30743b8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wei Yongjun'" <weiyj.lk@gmail.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, yongjun_wei@trendmicro.com.cn,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <CAPgLHd_V1M9DaO-XfrVh5k7on7cYRiLONQiu+SGrQM81MT5+Qg@mail.gmail.com>
In-reply-to: <CAPgLHd_V1M9DaO-XfrVh5k7on7cYRiLONQiu+SGrQM81MT5+Qg@mail.gmail.com>
Subject: Re: [PATCH -next] backlight: adp8870: fix error return code in
 adp8870_led_probe()
Date: Mon, 25 Mar 2013 13:31:03 +0900
Message-id: <00c901ce2911$8f2320f0$ad6962d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4m8LdT2ROFWy6ISJOK5g1hAKeZmgCIJkxA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zQ132y/6BBgvnKlrMWb+GzaJz5jVG
	i8sLL7FanOj7wGpxedccNovdu56yWny4dJTZYue6TnYHDo+ds+6ye3z4GOdxYsZvFo8983+w
	evRtWcXosfTeUUaPz5vkAtijuGxSUnMyy1KL9O0SuDLWr1/GWPCKq+L/13tMDYznOLoYOTgk
	BEwkGn7ldDFyApliEhfurWfrYuTiEBJYxijx8O0CdpialY15EPHpjBKLpm1ih3B+MUr0THzB
	DtLNJqAm8eXLYTBbBMg++reLFcRmFrjHKHHuvwbIICGBAInPd5hBwpwCwRKH20+zgoSFBWIl
	tp7lBQmzCKhK3OibwAhi8wrYSvz9uIYNwhaU+DH5HgvERC2J9TuPM0HY8hKb17xlhjhTXeLR
	X12IA4wkVl1rYYcoEZHY9+IdI8jFEgJ/2SUWTrvDArFLQOLb5EMsEL2yEpsOMEOCQVLi4Iob
	LBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQmO7bwXjz
	gPUhxmSg9ROZpUST84EpIa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4
	otKc1OJDjEwcnFINjJ0uDh/Sv82UyJzE4vS8Z+ohLgdHrcl8ro0Gj7a0VzMdLet/Jfuhi/PF
	ni3NZXL7NZcyXpn8+N1xzWVRTzY/+5gicXfSumOf5jV2/sy6JcayeiGDzdw/K6RZD290KZYI
	uL8h1eSisfnx3me1q3647wxV3hCdJHD3zurir8lXr7pEMjW/YTIzNFBiKc5INNRiLipOBABX
	BvOi/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQV32y/6BBr1NMhZz1q9hs+iceY3R
	4vLCS6wWJ/o+sFpc3jWHzWL3rqesFh8uHWW22Lmuk92Bw2PnrLvsHh8+xnmcmPGbxWPP/B+s
	Hn1bVjF6LL13lNHj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ
	69cvYyx4xVXx/+s9pgbGcxxdjBwcEgImEisb87oYOYFMMYkL99azdTFycQgJTGeUWDRtEzuE
	84tRomfiC3aQKjYBNYkvXw6D2SJA9tG/XawgNrPAPUaJc/81QIYKCQRIfL7DDBLmFAiWONx+
	mhUkLCwQK7H1LC9ImEVAVeJG3wRGEJtXwFbi78c1bBC2oMSPyfdYICZqSazfeZwJwpaX2Lzm
	LTPEyeoSj/7qQhxgJLHqWgs7RImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILi
	pPRcQ73ixNzi0rx0veT83E2M4JTxTGoH48oGi0OMAhyMSjy8AjX+gUKsiWXFlbmHGCU4mJVE
	eE+uBwrxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjCd5ZXEGxqbmBlZGplZGJmYm5MmrCTO
	e6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY2fZJ/ksj88LZe3f38n9y/jH1IlRRP/qqfmHq5a/
	di5ZsfSRWvE/1RnTOuW1VjSsTY+66Mjy+vzXmsMb7nImMi/OOJ/Y+E75imdgrPrm3e63sphe
	N9wXOyT2WPvrvUOKp1NPnZZ0ddmsF3pEbr/y/1Nc3k4KtcYaSe1iOndf+Kha/vqWGVPJp8RS
	nJFoqMVcVJwIABqaCt9dAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 8:31 PM, Wei Yongjun wrote:
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

CC'ed Andrdew Morton, linux-kernel@vger.kernel.org


Acked-by: Jingoo Han <jg1.han@samsung.com>

> ---
>  drivers/video/backlight/adp8870_bl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
> index 302c800..759bf23 100644
> --- a/drivers/video/backlight/adp8870_bl.c
> +++ b/drivers/video/backlight/adp8870_bl.c
> @@ -274,12 +274,14 @@ static int adp8870_led_probe(struct i2c_client *client)
>  		if (led_dat->id > 7 || led_dat->id < 1) {
>  			dev_err(&client->dev, "Invalid LED ID %d\n",
>  				led_dat->id);
> +			ret = -EINVAL;
>  			goto err;
>  		}
> 
>  		if (pdata->bl_led_assign & (1 << (led_dat->id - 1))) {
>  			dev_err(&client->dev, "LED %d used by Backlight\n",
>  				led_dat->id);
> +			ret = -EBUSY;
>  			goto err;
>  		}
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

