Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbaAJXJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 18:09:53 -0500
Received: from mail.active-venture.com ([67.228.131.205]:51610 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894AbaAJXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 18:09:49 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52D07DBD.9060700@roeck-us.net>
Date: Fri, 10 Jan 2014 15:09:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        lm-sensors@lm-sensors.org
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH] hwmon: (sht15) add include guard
References: <1389390286-6287-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1389390286-6287-2-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1389390286-6287-2-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 01:44 PM, Vivien Didelot wrote:
> Add include guard to include/linux/platform_data/sht15.h to prevent
> multiple inclusion.
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---

Applied to hwmon-next.

Thanks,
Guenter

>   include/linux/platform_data/sht15.h | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/include/linux/platform_data/sht15.h b/include/linux/platform_data/sht15.h
> index 33e0fd2..12289c1 100644
> --- a/include/linux/platform_data/sht15.h
> +++ b/include/linux/platform_data/sht15.h
> @@ -12,6 +12,9 @@
>    * For further information, see the Documentation/hwmon/sht15 file.
>    */
>
> +#ifndef _PDATA_SHT15_H
> +#define _PDATA_SHT15_H
> +
>   /**
>    * struct sht15_platform_data - sht15 connectivity info
>    * @gpio_data:		no. of gpio to which bidirectional data line is
> @@ -31,3 +34,5 @@ struct sht15_platform_data {
>   	bool no_otp_reload;
>   	bool low_resolution;
>   };
> +
> +#endif /* _PDATA_SHT15_H */
>

