Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3IKC3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:29:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50245 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3IKC3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:29:31 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-cb-522fd58aa92b
Message-id: <522FD58A.6070407@samsung.com>
Date: Wed, 11 Sep 2013 11:29:30 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2 2/6] extcon-gpio: Use gpio driver/chip debounce if
 supported
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-3-git-send-email-linux@roeck-us.net>
 <20130911021618.GA2657@roeck-us.net>
In-reply-to: <20130911021618.GA2657@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWyRsSkULfrqn6QwZXzEhaXd81hs3iy8AyT
	xe3GFWwOzB47vzewe/RtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG7Rn/mApu8FYcf36ctYFx
	FncXIyeHhICJxLM315kgbDGJC/fWs3UxcnEICSxllLh1/x0jTFH3n8/MEInpjBL7l2yCqnrF
	KNHS1czaxcjBwSugJXF/pilIA4uAqsSDLStZQGw2oPD+FzfYQGxRgTCJldOvgMV5BQQlfky+
	B2aLCKhJNJ9qAathFvCUOH2rixnEFhYIlbjRc4UdYtcioMWTToHt4hQwlPixRQCiXkdif+s0
	qF55ic1r3oIdKiEwj11i9dqXjBAHCUh8m3yIBaRXQkBWYtMBZojHJCUOrrjBMoFRbBaSk2Yh
	GTsLydgFjMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQJj5/S/ZxN3MN4/YH2IMRlo5URm
	KdHkfGDs5ZXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qB8fCDkz7G5p/kjqw+uYX5no3tfJtb60vu5W89K9+fM6FVIF746o9VMvz9sxkvz+646vEx
	7+pCj3j2HYkrV7HcVtz4/d0Jh8I7X37wzP+U5qH+8n+/nsHyg61/PJl0dhxLbNh8Wk11S3ny
	UWe30p27Dv3hEVF6/6Ow0H/yoXkBVktDOYTZ3y0pSVZiKc5INNRiLipOBACI7pswswIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd2uq/pBBl1vBC0u75rDZvFk4Rkm
	i9uNK9gcmD12fm9g9+jbsorR4/MmuQDmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwhrGjNsz/jEV3OCtOP78OGsD4yzuLkZODgkBE4nuP5+ZIWwxiQv31rN1MXJxCAlMZ5TY
	v2QTlPOKUaKlq5m1i5GDg1dAS+L+TFOQBhYBVYkHW1aygNhsQOH9L26wgdiiAmESK6dfAYvz
	CghK/Jh8D8wWEVCTaD7VAlbDLOApcfpWF9hiYYFQiRs9V9ghdi0CWjzpFNguTgFDiR9bBCDq
	dST2t06D6pWX2LzmLfMERoFZSFbMQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5
	mxjBkflMegfjqgaLQ4wCHIxKPLw35PSDhFgTy4orcw8xSnAwK4nwTnUCCvGmJFZWpRblxxeV
	5qQWH2JMBobARGYp0eR8YNLIK4k3NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFq
	EcwWJg5OqQbGMgaLdhb3uRpyWxlW3Xdhm3b3PnfgkdVmLUuXnwgS2iz+4cH2W16Kd5I+9vx+
	GLTvRqDDwX33E7w3eYtb9BvWXpHeOOGokpHZH4dkf9lUG3kFDZa2hqgDk39EZLjw3p0u9JR7
	2op6+ew4sSd2s5f99Zsw9c7Wm5v6Zm+yP3o+Lqowonya7omXSizFGYmGWsxFxYkAxDbAlRAD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 11:16 AM, Guenter Roeck wrote:
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: rephrase patch subject
>     call gpio_set_debounce before registering extcon device,
>     and set debounce_jiffies only if the call was not successful
> 
>  drivers/extcon/extcon-gpio.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 77d35a7..e5a4405 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -100,7 +100,13 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  	extcon_data->state_off = pdata->state_off;
>  	if (pdata->state_on && pdata->state_off)
>  		extcon_data->edev.print_state = extcon_gpio_print_state;
> -	extcon_data->debounce_jiffies = msecs_to_jiffies(pdata->debounce);
> +	if (pdata->debounce) {
> +		ret = gpio_set_debounce(extcon_data->gpio,
> +					pdata->debounce * 1000);
> +		if (ret < 0)
> +			extcon_data->debounce_jiffies =
> +				msecs_to_jiffies(pdata->debounce);
> +	}
>  
>  	ret = extcon_dev_register(&extcon_data->edev, &pdev->dev);
>  	if (ret < 0)
> 

I'd like you to add patch description for patch feature.
So I add a little description about using gpio_set_debounce()

I modify patch name as following to maintain patch naming style of extcon.
Before
	extcon-gpio: Do not unnecessarily initialize variables
	extcon-gpio: Use gpio driver/chip debounce if supported
After
	extcon: gpio: Do not unnecessarily initialize variables
	extcon: gpio: Use gpio driver/chip debounce if supported

Applied it on extcon-linus.
You can check it on extcon-linus branch in a few minutes.

Thanks,
Chanwoo Choi

