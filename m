Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaHKCPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 22:15:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41076 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaHKCPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 22:15:07 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-c6-53e827289a88
From: Jingoo Han <jg1.han@samsung.com>
To: "'Himangi Saraogi'" <himangi774@gmail.com>,
        "'Felipe Balbi'" <balbi@ti.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Julia Lawall'" <julia.lawall@lip6.fr>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20140810195937.GA3923@himangi-Dell>
In-reply-to: <20140810195937.GA3923@himangi-Dell>
Subject: Re: [PATCH] usb: phy: drop kfree of devm_kzalloc's data
Date: Mon, 11 Aug 2014 11:15:04 +0900
Message-id: <005301cfb50a$1054b140$30fe13c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+01aqVJ3M06JWJTuSyqVwH2ZKvrwANAQqw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zI10N9RfBBsc/m1kcvF9v0bx4PZvF
	vdUL2SwuL7zEarHswWlGi8u75rBZLFrWyuzA7rFz1l12j/1z17B77N2S5dG3ZRWjx/Eb25k8
	Pm+SC2CL4rJJSc3JLEst0rdL4Mr49yeh4AZnxfT5r5gaGF+zdzFyckgImEh8vzGfFcIWk7hw
	bz1bFyMXh5DAMkaJ5VPmwRXt2j+NHSIxnVFiZu8rZgjnN6PEnSX3GUGq2ATUJL58OQzWISLg
	LXFmz3awDmaBvYwSG05tBysSEjCQ+Nl+HMzmFDCUOHzuGEsXIweHsICDREt7EIjJIqAq8fBb
	BUgFr4CtxNxzL1ghbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywzSKiGgLvHory7EBUYSfatm
	sUKUiEjse/GOEeQaCYGP7BKPGyaDXcAiICDxbfIhFoheWYlNB5gh/pWUOLjiBssERolZSDbP
	QrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJIJ7dzDePmB9iDEZaP1E
	ZinR5HxgAsgriTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBkaNjYekLzAeVowOjvV0urGkN9dg1RapxRsUtJh+fgp5/m7bpvTrj0/nlGyrWHVd8H/i
	jWdvX0T9jd1wS4/R8sajzHO/Nm4svdcnxsz0urYgP6tPap3JwpybMnu+t9ol+//fVfz55fl9
	8qmuUgnTqh4G2IQ+rztt+IDzor3uwq0fkgKC33JMzPylxFKckWioxVxUnAgAwXSZ6/YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQV0N9RfBBit+GlkcvF9v0bx4PZvF
	vdUL2SwuL7zEarHswWlGi8u75rBZLFrWyuzA7rFz1l12j/1z17B77N2S5dG3ZRWjx/Eb25k8
	Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8e9PQsENzorp818x
	NTC+Zu9i5OSQEDCR2LV/GpQtJnHh3nq2LkYuDiGB6YwSM3tfMUM4vxkl7iy5zwhSxSagJvHl
	y2GwDhEBb4kze7azgxQxC+xllNhwajtYkZCAgcTP9uNgNqeAocThc8dYuhg5OIQFHCRa2oNA
	TBYBVYmH3ypAKngFbCXmnnvBCmELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkFYJAXWJR391
	IS4wkuhbNYsVokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcHp4JrWDcWWDxSFGAQ5GJR7eg1+eBwuxJpYVV+YeYpTgYFYS4fV8ChTiTUms
	rEotyo8vKs1JLT7EaAr050RmKdHkfGDqyiuJNzQ2MTOyNDKzMDIxN1cS5z3Qah0oJJCeWJKa
	nZpakFoE08fEwSnVwGjsfuDg5uDd9ffX5sx5P/vu/IjkpGsR27tEjL1ZpnydbWnrePXGPql3
	HF/O+s0s6Hv7Yx9n1zNZ79+9j5ebh6oefrYi7Xh3rPvrwL63WZEGH10mMelmGQUkFp0WrN2v
	uzl2WsnBU995XD1yD99adHZh95KJMd+mhy8+s9+l9NZVDy3Ox+eFv5YqsRRnJBpqMRcVJwIA
	BRLMGiUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 11, 2014 5:00 AM, Himangi Saraogi wrote:
> 
> Using kfree to free data allocated with devm_kzalloc causes double frees.
> 
> The Coccinelle semantic patch that fixes this problem is as follows:
> 
> // <smpl>
> @@
> expression x;
> @@
> 
> x = devm_kzalloc(...)
> ...
> ?-kfree(x);
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/usb/phy/phy-gpio-vbus-usb.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio-vbus-usb.c
> index ea9e705..f4b14bd 100644
> --- a/drivers/usb/phy/phy-gpio-vbus-usb.c
> +++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
> @@ -260,10 +260,8 @@ static int gpio_vbus_probe(struct platform_device *pdev)
> 
>  	gpio_vbus->phy.otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
>  					  GFP_KERNEL);
> -	if (!gpio_vbus->phy.otg) {
> -		kfree(gpio_vbus);
> +	if (!gpio_vbus->phy.otg)
>  		return -ENOMEM;
> -	}
> 
>  	platform_set_drvdata(pdev, gpio_vbus);
>  	gpio_vbus->dev = &pdev->dev;
> --
> 1.9.1

