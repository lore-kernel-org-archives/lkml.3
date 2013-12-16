Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3LPEwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:52:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26527 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3LPEwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:52:18 -0500
X-AuditID: cbfee68f-b7fe36d0000016f8-cc-52ae87004874
From: Jingoo Han <jg1.han@samsung.com>
To: "'Levente Kurusa'" <levex@linux.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1386959996-7958-1-git-send-email-levex@linux.com>
 <1386959996-7958-4-git-send-email-levex@linux.com>
In-reply-to: <1386959996-7958-4-git-send-email-levex@linux.com>
Subject: Re: [PATCH 3/4] backlight: lcd: call put_device if device_register
 fails
Date: Mon, 16 Dec 2013 13:52:16 +0900
Message-id: <006f01cefa1a$97ea4710$c7bed530$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac74NRY3NiDn4atoQRqaMVlhgTIpMwB5IayA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zA12G9nVBBjcO6VrMWb+GzeLywkus
	Fks73rJbnOj7wGpxedccNot1D18wWayff4vNgd3j1YU7LB4nZvxm8XhyZTqTR9+WVYwex29s
	Z/L4vEkugC2KyyYlNSezLLVI3y6BK+PSts3sBft5K8413WZsYHzF1cXIySEhYCKxZu9sVghb
	TOLCvfVsXYxcHEICyxgl+vcdYO5i5AAr2rszFKRGSGA6o8Tx8zwQNb8YJQ7ceMYCkmATUJP4
	8uUwO4gtIhAqcbl/GQtIEbPANUaJKWtnsEJ0F0vs+/6aGcTmFLCXmNM8gRHEFhYIlrixdAeY
	zSKgKvHt4D+wobwCthJt5zcyQtiCEj8m3wOLMwtoSazfeZwJwpaX2LzmLdSh6hKP/upC3GAk
	8W7zJXaIEhGJfS/eMYLcIyHwlV3i7tpP7BC7BCS+TT7EAtErK7HpADMkICQlDq64wTKBUWIW
	ks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIieP+HYx3D1gfYkwG
	Wj+RWUo0OR+YBvJK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA6PHRrn8hkLltKs6oqe6Q3TzbJfOTdnV/crkZ/EVF/ZbBw4VtKjwfcl6bNr/rtba
	7JgY272f/XZTN3zY9CzmaLHIkYKO/wGn2JIzvSZt3OvEIy5susu+dcfVJ5F/Z/iJ/mLcI/Qj
	7tLdmorr1cuYLDQr1mqvOx/tE6teOGHxZt4NpXsM76t88FZiKc5INNRiLipOBADWM/42+QIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jQV2G9nVBBsdWa1rMWb+GzeLywkus
	Fks73rJbnOj7wGpxedccNot1D18wWayff4vNgd3j1YU7LB4nZvxm8XhyZTqTR9+WVYwex29s
	Z/L4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA
	1y0zB+gYJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGpW2b2Qv281ac
	a7rN2MD4iquLkYNDQsBEYu/O0C5GTiBTTOLCvfVsILaQwHRGiePneboYuYDsX4wSB248YwFJ
	sAmoSXz5cpgdxBYRCJW43L+MBaSIWeAao8SUtTNYIbqLJfZ9f80MYnMK2EvMaZ7ACGILCwRL
	3Fi6A8xmEVCV+HbwH9hQXgFbibbzGxkhbEGJH5PvgcWZBbQk1u88zgRhy0tsXvOWGeJodYlH
	f3UhbjCSeLf5EjtEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgJPFMegfjqgaLQ4wCHIxKPLwKluuChFgTy4orcw8xSnAwK4nwxlxdGyTE
	m5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cAEllcSb2hsYmZkaWRmYWRibk6asJI478FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjJqaXIni1zZvnGxbmOcc1fZhiaD3xsWVPxkt1HeeCtdtX7ZC
	MFKsccns/3e3Ho84pynWdn3ZPrst6X4W88N0cqIeZDo/YX4zu3ElV/0NbkvhLs2IWY9Lq68r
	fZ9kz2Lk4n1YWrg5Lj3kMJeo6a/Hq1RLFzOF7tJ816OvK/dO4UfWFeuPyp2eSizFGYmGWsxF
	xYkACpyhL1YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 14, 2013 3:40 AM, Levente Kurusa wrote:
> 
> Currently we kfree the container of the device which failed to register.
> This is wrong as the last reference is not given up with a put_device
> call. Also, now that we have put_device() callen, we no longer need
> the kfree as the new_ld->dev.release function will take care of kfreeing
> the associated memory.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>

(+cc Andrew Morton)

Acked-by: Jingoo Han <jg1.han@samsung.com>

It looks good.
According to the comment of device_register, put_device()
should be used, instead of directly freeing.

./drivers/base/core.c

 * NOTE: _Never_ directly free @dev after calling this function, even
 * if it returned an error! Always use put_device() to give up the
 * reference initialized in this function instead.
 */
int device_register(struct device *dev)
{
        device_initialize(dev);
        return device_add(dev);
}
EXPORT_SYMBOL_GPL(device_register);

Levente Kurusa,
By the way, don't send the same mails three times, without any
reason. It is the waste of traffic. :-(

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/lcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
> index 93cf15e..7de847d 100644
> --- a/drivers/video/backlight/lcd.c
> +++ b/drivers/video/backlight/lcd.c
> @@ -228,7 +228,7 @@ struct lcd_device *lcd_device_register(const char *name, struct device *parent,
> 
>  	rc = device_register(&new_ld->dev);
>  	if (rc) {
> -		kfree(new_ld);
> +		put_device(&new_ld->dev);
>  		return ERR_PTR(rc);
>  	}
> 
> --
> 1.8.3.1

