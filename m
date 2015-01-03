Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbbACBFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 20:05:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36818 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbbACBFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 20:05:14 -0500
X-AuditID: cbfee68d-f79296d000004278-47-54a7404981e4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Aaron Lu'" <aaron.lu@intel.com>
Cc: "'Lee Jones'" <lee.jones@linaro.org>, "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1419997818-19528-1-git-send-email-aaron.lu@intel.com>
 <1419997818-19528-3-git-send-email-aaron.lu@intel.com>
In-reply-to: <1419997818-19528-3-git-send-email-aaron.lu@intel.com>
Subject: Re: [PATCH 2/3] video / backlight: remove the
 backlight_device_registered API
Date: Sat, 03 Jan 2015 10:05:48 +0900
Message-id: <000c01d026f1$690a7050$3b1f50f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAkrPGYAZgn4UcyRxeoz3G7FFVafACRGN0A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zY11Ph+UhBh92Slhs6vvNZnF54SVW
	i/tfjzJaLN/Xz2hxedccNovPvUcYLc6cBko8edjH5sDhsXjPSyaPO9f2sHlsudrO4tG3ZRWj
	x+dNcgGsUVw2Kak5mWWpRfp2CVwZO299YS7YIlKx4uxjlgbGmYJdjJwcEgImEvMnt7ND2GIS
	F+6tZ+ti5OIQEljGKPH7dDsTTNHlxgdMEInpjBKX7u1khXB+MUqsX9XBBlLFJqAm8eXLYbBR
	IgLKEptfXQPrYBb4xChx4fwZZpCEkEC1xMmVHWBjOQWcJf6/vg/WICwQIbH76lSwQSwCqhI/
	dvxhBLF5BWwlmpo3sEPYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvMWaD4H0KnqEo/+6kLcYCRx
	6tNkRogSEYl9L94xQnzzk12i9zsHxCoBiW+TD7FAtMpKbDrADFEiKXFwxQ2WCYwSs5AsnoVk
	8Swki2ch2bCAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkgk9+5gvH3A+hCjAAejEg8v
	h8XyECHWxLLiytxDjKZAF01klhJNzgemi7ySeENjMyMLUxNTYyNzSzMlcV5FqZ/BQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhjP2dquyO9i6eiZk3nYMXj3tit7OCyPrJXa7pjx8vu2RQXJ
	B58L31a2rbZzTDexaK/I6t/GXddxNJGhslbZZr3y7pDdP5d4rNR4l1Xn4DB7cUFkidIlZs13
	5861LmF7xs3xRGPJ43kTTUrrt1ny7W5yFTKRPPH8kprDs7OXT/+xXrT4wSlmcUYlluKMREMt
	5qLiRAARnZeI3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQV1Ph+UhBrMeCFts6vvNZnF54SVW
	i/tfjzJaLN/Xz2hxedccNovPvUcYLc6cBko8edjH5sDhsXjPSyaPO9f2sHlsudrO4tG3ZRWj
	x+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlAxygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM3be+sJcsEWkYsXZ
	xywNjDMFuxg5OSQETCQuNz5ggrDFJC7cW8/WxcjFISQwnVHi0r2drBDOL0aJ9as62ECq2ATU
	JL58OcwOYosIKEtsfnWNCaSIWeATo8SF82eYQRJCAtUSJ1d2gI3lFHCW+P/6PliDsECExO6r
	U8EGsQioSvzY8YcRxOYVsJVoat7ADmELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVug+RxAp6pL
	PPqrC3GDkcSpT5MZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBCeKZ1I7GFc2WBxiFOBgVOLh5bBYHiLEmlhWXJl7iFGCg1lJhJdl77IQ
	Id6UxMqq1KL8+KLSnNTiQ4ymQI9OZJYSTc4HJrG8knhDYxMzI0sjMwsjE3NzJXFeJfu2ECGB
	9MSS1OzU1ILUIpg+Jg5OqQZG1xiN9Ma4S123yraemfjV8E6/pvubHasLdpiYFJ9dfXPK30+l
	ZgFOOxo3XYx+911lWeuPN7Ulbsk8Qj3bBQvOSntdmbdFe8euVU0bIpn6d+tv/31++c2INf1r
	nl941Pdsukn56yu/6y5NlQ+403B83hHdxR3tPY/X7X0g9YjrzuqFb5u+tx/aVK3EUpyRaKjF
	XFScCAAe8s1RKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 31, 2014 12:50 PM, Aaron Lu wrote:
> 
> Since we will need the backlight_device_get_by_type API, we can use it
> instead of the backlight_device_registered API whenever necessary so
> remove the backlight_device_registered API.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/acpi/video.c                | 2 +-
>  drivers/video/backlight/backlight.c | 6 ------
>  include/linux/backlight.h           | 1 -
>  3 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 1eaadff2e198..98d3f0de811e 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -246,7 +246,7 @@ static bool acpi_video_use_native_backlight(void)
>  bool acpi_video_verify_backlight_support(void)
>  {
>  	if (acpi_osi_is_win8() && acpi_video_use_native_backlight() &&
> -	    backlight_device_registered(BACKLIGHT_RAW))
> +	    backlight_device_get_by_type(BACKLIGHT_RAW))
>  		return false;
>  	return acpi_video_backlight_support();
>  }
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index bea749329236..aec173d9e1ee 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -406,12 +406,6 @@ struct backlight_device *backlight_device_get_by_type(enum backlight_type type)
>  }
>  EXPORT_SYMBOL(backlight_device_get_by_type);
> 
> -bool backlight_device_registered(enum backlight_type type)
> -{
> -	return backlight_device_get_by_type(type) ? true : false;
> -}
> -EXPORT_SYMBOL(backlight_device_registered);
> -
>  /**
>   * backlight_device_unregister - unregisters a backlight device object.
>   * @bd: the backlight device object to be unregistered and freed.
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index c59a020df3f8..287a4460054c 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -137,7 +137,6 @@ extern void devm_backlight_device_unregister(struct device *dev,
>  					struct backlight_device *bd);
>  extern void backlight_force_update(struct backlight_device *bd,
>  				   enum backlight_update_reason reason);
> -extern bool backlight_device_registered(enum backlight_type type);
>  extern int backlight_register_notifier(struct notifier_block *nb);
>  extern int backlight_unregister_notifier(struct notifier_block *nb);
>  extern struct backlight_device *backlight_device_get_by_type(enum backlight_type type);
> --
> 2.1.0

