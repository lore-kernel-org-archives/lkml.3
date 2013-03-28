Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3C1AEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:04:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24646 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3C1AEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:04:01 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-c5-515388efe837
Message-id: <515388F0.3060604@samsung.com>
Date: Thu, 28 Mar 2013 09:04:00 +0900
From: Donghwa Lee <dh09.lee@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Andrei Epure <epure.andrei@gmail.com>
Cc: inki.dae@samsung.com, kyungmin.park@samsung.com, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: exynos: remove useless safety check in list
 traversal
References: <1364419145-30375-1-git-send-email-epure.andrei@gmail.com>
In-reply-to: <1364419145-30375-1-git-send-email-epure.andrei@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zHd33HcGBBp9nq1uc+LmUzaJz5jVG
	i0n3J7BYnG16w25xou8Dq8XlXXPYHNg8ds66y+7x4WOcR9+WVYwenzfJBbBEcdmkpOZklqUW
	6dslcGUcWS9f0MNbceTaTKYGxoNcXYycHBICJhLnXuxhh7DFJC7cW8/WxcjFISSwjFHi0O0u
	NpiibY/msEMkpjNKvH7+CMp5ySjRuPkgcxcjBwevgJbErR1pICaLgKrE+V91IL1sAhoSp+/d
	B1sgKhAmsXL6FRYQm1dAUOLH5HtgtoiApsTE7V/BbGaBLkaJlqsWILawQLDE+t5prCC2kICb
	xK8tz8DmcAq4S/T+OM8GUW8tsXLSNkYIW15i85q3zCCnSQjsY5d49asDbCiLgIDEt8mHWEBu
	kxCQldh0gBniL0mJgytusExgFJuF5KRZSMbOQjJ2ASPzKkbR1ILkguKk9CJjveLE3OLSvHS9
	5PzcTYyQ6OrfwXj3gPUhxmSglROZpUST84HRmVcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxr2e8i9mOChtUOq4MF33X20mR9eK2ObZD+Zbv1P0
	n5sizrgv5mC1kVts1izzP9tS39Uuq5onEGR729k04scOnZ0GnT7iRgvC6urD/M7MXp3NrPp3
	d8XVP2fa59rFKIoEv05qSIx4HVXm/Y6TdemTF9MdlBf+kRVUnKyjct8kSfqC7OvkcK44JZbi
	jERDLeai4kQAab5x48QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xoO77juBAg2WfFC1O/FzKZtE58xqj
	xaT7E1gszja9Ybc40feB1eLyrjlsDmweO2fdZff48DHOo2/LKkaPz5vkAliiGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CWKymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzjqyXL+jhrThybSZTA+NBri5GTg4JAROJbY/m
	sEPYYhIX7q1n62Lk4hASmM4o8fr5I3YI5yWjROPmg8xdjBwcvAJaErd2pIGYLAKqEud/1YH0
	sgloSJy+dx9sjqhAmMTK6VdYQGxeAUGJH5PvgdkiApoSE7d/BbOZBboYJVquWoDYwgLBEut7
	p7GC2EICbhK/tjwDm8Mp4C7R++M8G0S9tcTKSdsYIWx5ic1r3jJPYBSYhWTFLCRls5CULWBk
	XsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHLvPpHYwrmywOMQowMGoxMNbIRAcKMSaWFZc
	mXuIUYKDWUmEd1YNUIg3JbGyKrUoP76oNCe1+BBjMjAAJjJLiSbnA9NKXkm8obGJmZGlkZmx
	ibmxMWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUw9vz6F/5DZmNz9XKRrGifSO2jBRMD
	laR7Hn7vnTZ/TsaEo0q/1U+U7Lq56v/hoKzVz79lxbzud0h8qrngwRP/mVkr9jyQaFzAkTxD
	6aEmz/f1V8NPJ5WeP6iTH/Qo4F/7fMnKaQyp+/sPzFw2/4TNnatfWdc5c7Afm9lfc3yptHVq
	8guLpkk5y5RYijMSDbWYi4oTAdEvX1ohAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

It looks good to me.

Acked-by: Donghwa Lee <dh09.lee@samsung.com>

Best regard,
Donghwa Lee

On Thu, Mar 28, 2013 at 06:19, Andrei Epure wrote:
> list_for_each_entry_safe() does not require safety check.
> Patch found using coccinelle.
>
> Signed-off-by: Andrei Epure<epure.andrei@gmail.com>
> ---
>   drivers/video/exynos/exynos_mipi_dsi.c |   16 ++++++----------
>   1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
> index dd5e5e9..fe84f08 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi.c
> +++ b/drivers/video/exynos/exynos_mipi_dsi.c
> @@ -214,8 +214,6 @@ static struct mipi_dsim_ddi *exynos_mipi_dsi_find_lcd_device(
>   	mutex_lock(&mipi_dsim_lock);
>   
>   	list_for_each_entry_safe(dsim_ddi, next, &dsim_ddi_list, list) {
> -		if (!dsim_ddi)
> -			goto out;
>   
>   		lcd_dev = dsim_ddi->dsim_lcd_dev;
>   		if (!lcd_dev)
> @@ -473,17 +471,15 @@ static int exynos_mipi_dsi_remove(struct platform_device *pdev)
>   	clk_disable(dsim->clock);
>   
>   	list_for_each_entry_safe(dsim_ddi, next, &dsim_ddi_list, list) {
> -		if (dsim_ddi) {
> -			if (dsim->id != dsim_ddi->bus_id)
> -				continue;
> +		if (dsim->id != dsim_ddi->bus_id)
> +			continue;
>   
> -			dsim_lcd_drv = dsim_ddi->dsim_lcd_drv;
> +		dsim_lcd_drv = dsim_ddi->dsim_lcd_drv;
>   
> -			if (dsim_lcd_drv->remove)
> -				dsim_lcd_drv->remove(dsim_ddi->dsim_lcd_dev);
> +		if (dsim_lcd_drv->remove)
> +			dsim_lcd_drv->remove(dsim_ddi->dsim_lcd_dev);
>   
> -			kfree(dsim_ddi);
> -		}
> +		kfree(dsim_ddi);
>   	}
>   
>   	return 0;

