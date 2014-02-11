Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaBKMIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:08:43 -0500
Received: from smtp-out-081.synserver.de ([212.40.185.81]:1071 "EHLO
	smtp-out-003.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751312AbaBKMIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:08:42 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22866
Message-ID: <52FA12D1.4020408@metafoo.de>
Date: Tue, 11 Feb 2014 13:08:49 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 6/7] Input: pwm-beepe: remove HAVE_PWM dependencies
References: <003901cf25fc$73002790$590076b0$%han@samsung.com> <003f01cf25fd$b3e274b0$1ba75e10$%han@samsung.com>
In-Reply-To: <003f01cf25fd$b3e274b0$1ba75e10$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 02:16 AM, Jingoo Han wrote:
> The HAVE_PWM symbol is only for legacy platforms that provide
> the PWM API without using the generic framework. However, legacy
> PWM drivers were already moved to the generic PWM framework.
> Thus, HAVE_PWM should be removed, because HAVE_PWM is not
> required anymore.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>   drivers/input/misc/Kconfig |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index ae74df7..762e6d2 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -470,7 +470,7 @@ config INPUT_PCF8574
>
>   config INPUT_PWM_BEEPER
>   	tristate "PWM beeper support"
> -	depends on PWM && HAVE_PWM
> +	depends on PWM
>   	help
>   	  Say Y here to get support for PWM based beeper devices.
>
>

