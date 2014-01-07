Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaAGBm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:42:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12634 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaAGBm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:42:26 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-d9-52cb5b745a40
From: Jingoo Han <jg1.han@samsung.com>
To: "'Levente Kurusa'" <levex@linux.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <1386959996-7958-1-git-send-email-levex@linux.com>
 <1386959996-7958-4-git-send-email-levex@linux.com>
In-reply-to: <1386959996-7958-4-git-send-email-levex@linux.com>
Subject: Re: [PATCH 3/4] backlight: lcd: call put_device if device_register
 fails
Date: Tue, 07 Jan 2014 10:42:11 +0900
Message-id: <000001cf0b49$af5ab7f0$0e1027d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac74NRY3NiDn4atoQRqaMVlhgTIpMwTE+USg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY92S6NNBBive8lrMWb+GzeLywkus
	Fks73rJbnOj7wGpxedccNot1D18wWayff4vNgd3j1YU7LB4nZvxm8XhyZTqTR9+WVYwex29s
	Z/L4vEkugC2KyyYlNSezLLVI3y6BK2PDjRVMBZ+4Kp69aGNvYNzJ0cXIySEhYCKx48ZHNghb
	TOLCvfVANheHkMAyRom3D/+ywBTN2POBFSKxiFFi+sNnLBDOL0aJo9PvsYJUsQmoSXz5cpi9
	i5GDQwTI3r8uGqSGWaCZSeLtmtdgk4QEiiX2fX/NDGJzCthLzGmewAhiCwsES9xYugPMZhFQ
	lTh1/QTYSbwCthJfvz1khLAFJX5Mvgc2h1lAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYR
	MJLY+fcQM0SJiMS+F+8YQe6REPjJLnH79DEWiF0CEt8mH2KB6JWV2HSAGeJhSYmDK26wTGCU
	mIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUIieeIOxvsHrA8x
	JgOtn8gsJZqcD0wEeSXxhsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXAuNDtyhMGjTtBqtaRVk+zHHlP5L1xZj+b6N4g8XFx2ZqfRhePXjk9+3Sl53Mv
	nqac3RMenpq/KjLhQlYkj/bzKyba5ye96+E96Lci1DawMvzz8S2B++YI7D1ZtVRUZuZyV69f
	Nr8vuJxT0eIwL/au8apM3NC1/r/P7ut+pfXikxZvTnmg0GzwVYmlOCPRUIu5qDgRALehRZr6	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd2S6NNBBpfPcVrMWb+GzeLywkus
	Fks73rJbnOj7wGpxedccNot1D18wWayff4vNgd3j1YU7LB4nZvxm8XhyZTqTR9+WVYwex29s
	Z/L4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA
	1y0zB+gYJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGhhsrmAo+cVU8
	e9HG3sC4k6OLkZNDQsBEYsaeD6wQtpjEhXvr2boYuTiEBBYxSkx/+IwFwvnFKHF0+j2wKjYB
	NYkvXw6zdzFycIgA2fvXRYPUMAs0M0m8XfOaBaRGSKBYYt/318wgNqeAvcSc5gmMILawQLDE
	jaU7wGwWAVWJU9dPsIHYvAK2El+/PWSEsAUlfky+BzaHWUBLYv3O40wQtrzE5jVvmUH2Sgio
	Szz6qwsSFhEwktj59xAzRImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4DTxTHoH46oGi0OMAhyMSjy8L/aeChJiTSwrrsw9xCjBwawkwiui
	dDpIiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBKSyvJN7Q2MTMyNLIzMLIxNycNGElcd6D
	rdaBQgLpiSWp2ampBalFMFuYODilGhg57Z2MVJg9pmfafwrsufnvYXj0zR93YqZ+7u9x03t7
	tdrC59Q5RoXp2Tczy2b87OUwN8k5soonJ6uh4dEr26YcreOM0flBgS3HD79iLJu7u3/yYUOD
	wzeiVfWYi9OV1sYb1N8p179l3N66d4Lt3Zy4Otelunf17/XJP92odLO7hH2VzMS1skosxRmJ
	hlrMRcWJALBZBslXAwAA
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

(+cc Andrew Morton)

Hi Levente Kurusa,

Would you fix the same thing for 'backlight.c' file?

./drivers/video/backlight/backlight.c
struct backlight_device *backlight_device_register(const char *name,
    .....
    rc = device_register(&new_bd->dev);
            if (rc) {
                    kfree(new_bd);
                    return ERR_PTR(rc);
            }

Best regards,
Jingoo Han

