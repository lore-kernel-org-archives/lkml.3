Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbaAJXJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 18:09:36 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61266 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaAJXJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 18:09:34 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52D07DAD.30105@roeck-us.net>
Date: Fri, 10 Jan 2014 15:09:33 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        lm-sensors@lm-sensors.org
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH] hwmon: (max197) add include guard
References: <1389390286-6287-1-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1389390286-6287-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 01:44 PM, Vivien Didelot wrote:
> Add include guard to include/linux/platform_data/max197.h to prevent
> multiple inclusion.
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---

Applied to hwmon-next.

Thanks,
Guenter

>   include/linux/platform_data/max197.h | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/include/linux/platform_data/max197.h b/include/linux/platform_data/max197.h
> index e2a41dd..8da8f94 100644
> --- a/include/linux/platform_data/max197.h
> +++ b/include/linux/platform_data/max197.h
> @@ -11,6 +11,9 @@
>    * For further information, see the Documentation/hwmon/max197 file.
>    */
>
> +#ifndef _PDATA_MAX197_H
> +#define _PDATA_MAX197_H
> +
>   /**
>    * struct max197_platform_data - MAX197 connectivity info
>    * @convert:	Function used to start a conversion with control byte ctrl.
> @@ -19,3 +22,5 @@
>   struct max197_platform_data {
>   	int (*convert)(u8 ctrl);
>   };
> +
> +#endif /* _PDATA_MAX197_H */
>

