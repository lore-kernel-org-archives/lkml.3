Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab3CYE3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:29:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21272 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab3CYE3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:29:11 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-83-514fd2951d2e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wei Yongjun'" <weiyj.lk@gmail.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, michael.hennerich@analog.com,
        rpurdie@rpsys.net, FlorianSchandinat@gmx.de,
        yongjun_wei@trendmicro.com.cn,
        device-drivers-devel@blackfin.uclinux.org, linux-fbdev@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <CAPgLHd-wxGVKjMpWPDeKqWM+Va6dLnu_spwyb=QUybxjOo=AWA@mail.gmail.com>
In-reply-to: <CAPgLHd-wxGVKjMpWPDeKqWM+Va6dLnu_spwyb=QUybxjOo=AWA@mail.gmail.com>
Subject: Re: [PATCH -next] backlight: adp8860: fix error return code in
 adp8860_led_probe()
Date: Mon, 25 Mar 2013 13:29:09 +0900
Message-id: <00c801ce2911$4b3db080$e1b91180$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4m8KTYOjPr8YgsQ5eqPMAZCr8v0ACIEMwA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zvu7US/6BBv3TdSzmrF/DZrG+5QWT
	RefMa4wWlxdeYrU40feB1eLyrjlsFhMOb2a32L3rKavFh0tHmS12rutkd+DyeHXV0WPldG+P
	nbPusnt8+BjncWLGbxaPPfN/sHr0bVnF6LH03lFGj8+b5AI4o7hsUlJzMstSi/TtErgyzm9a
	wVjwiqvi0OlDTA2M5zi6GDk5JARMJFpO7GGDsMUkLtxbD2RzcQgJLGOU6LvzggmmqHP6IxaI
	xCJGiU0d79khnF+MEke3rmYFqWITUJP48uUwO4gtAmQf/dvFClLELLCSSeLb5m3MIAkhgQCJ
	73e/g9mcAsESS+7dArOFBWIlzk65ygJiswioSnTP7AWzeQVsJZ78aWaHsAUlfky+BxZnFtCS
	WL/zOBOELS+xec1boDkcQKeqSzz6qwtxg5HEri9P2CBKRCT2vXjHCPHNTA6JG9MMIVYJSHyb
	fIgFolVWYtMBZogSSYmDK26wTGCUmIVk8Swki2chWTwLyYYFjCyrGEVTC5ILipPSi4z1ihNz
	i0vz0vWS83M3MULiv38H490D1ocYk4HWT2SWEk3OB6aPvJJ4Q2MzIwtTE1NjI3NLM9KElcR5
	1VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwNmgfl7ptINqzbbLsze0Jj1dflt77OEN5
	26QO1ab8VfwZ+6UZbt0UmVa6P/Jv+ctNix4+WuC6J0z0gOXC1+39QtVeR/+dfNZ5cu+Ze5b3
	nXfXR/+xXGnCdX/q7Q8Vu0KcFlgEvHx30K15w56ZQnxXI0XWuk/9vyFJ5nxM/wdnc8eKu/xe
	uZM+uCmxFGckGmoxFxUnAgDZMwagFQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jAd2pl/wDDW7+VbOYs34Nm8X6lhdM
	Fp0zrzFaXF54idXiRN8HVovLu+awWUw4vJndYveup6wWHy4dZbbYua6T3YHL49VVR4+V0709
	ds66y+7x4WOcx4kZv1k89sz/werRt2UVo8fSe0cZPT5vkgvgjGpgtMlITUxJLVJIzUvOT8nM
	S7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBulNJoSwxpxQoFJBYXKykb4dpQmiI
	m64FTGOErm9IEFyPkQEaSFjHmHF+0wrGgldcFYdOH2JqYDzH0cXIySEhYCLROf0RC4QtJnHh
	3nq2LkYuDiGBRYwSmzres0M4vxgljm5dzQpSxSagJvHly2F2EFsEyD76t4sVpIhZYCWTxLfN
	25hBEkICARLf734HszkFgiWW3LsFZgsLxEqcnXIVbB2LgKpE98xeMJtXwFbiyZ9mdghbUOLH
	5HtgcWYBLYn1O48zQdjyEpvXvAWawwF0qrrEo7+6EDcYSez68oQNokREYt+Ld4wTGIVmIZk0
	C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcHp5Jr2DcVWDxSFGAQ5G
	JR5egRr/QCHWxLLiytxDjBIczEoivCfXA4V4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5j6
	8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUa46ZLnF0d4y
	9UitiT8ZXyjZX1b+dSUu9omJupfu4/fzGZPSHPNuhPPrXT6meVGvk3XFKfaMSwveMFzlap6V
	1sr+205Oc8nMX5G3px0/ofLv4ZwCtWPt7pOWVXs9/93N/fwDy9/3OQZCAndnlx+t+u15QfhO
	4Gndm+sWe20s+/1iiqusQ6fHFSWW4oxEQy3mouJEAIYiMJVzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 8:30 PM, Wei Yongjun wrote:
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
>  drivers/video/backlight/adp8860_bl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
> index 6bb7f36..75b10f8 100644
> --- a/drivers/video/backlight/adp8860_bl.c
> +++ b/drivers/video/backlight/adp8860_bl.c
> @@ -249,12 +249,14 @@ static int adp8860_led_probe(struct i2c_client *client)
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

