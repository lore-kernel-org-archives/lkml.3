Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaBOLlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 06:41:08 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44438 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaBOLlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 06:41:05 -0500
Message-ID: <52FF5274.5060408@kernel.org>
Date: Sat, 15 Feb 2014 11:41:40 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Porter <mporter@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Linux IIO List <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/6] iio: enable selection and build of pulse drivers
References: <1391626901-31684-1-git-send-email-mporter@linaro.org> <1391626901-31684-4-git-send-email-mporter@linaro.org>
In-Reply-To: <1391626901-31684-4-git-send-email-mporter@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 19:01, Matt Porter wrote:
> Add the pulse driver subdirectory when configuring and building
> IIO.
>
> Signed-off-by: Matt Porter <mporter@linaro.org>
Hi Matt,

This wants rolling into the driver patch before it.  No point it giving it
it's own patch.  This will just lead to confusion on git bisections etc.


Jonathan
> ---
>   drivers/iio/Kconfig  | 1 +
>   drivers/iio/Makefile | 1 +
>   2 files changed, 2 insertions(+)
>
> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
> index 5dd0e12..286acc3 100644
> --- a/drivers/iio/Kconfig
> +++ b/drivers/iio/Kconfig
> @@ -74,6 +74,7 @@ if IIO_TRIGGER
>      source "drivers/iio/trigger/Kconfig"
>   endif #IIO_TRIGGER
>   source "drivers/iio/pressure/Kconfig"
> +source "drivers/iio/pulse/Kconfig"
>   source "drivers/iio/temperature/Kconfig"
>
>   endif # IIO
> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
> index 887d390..9a953c9 100644
> --- a/drivers/iio/Makefile
> +++ b/drivers/iio/Makefile
> @@ -24,5 +24,6 @@ obj-y += light/
>   obj-y += magnetometer/
>   obj-y += orientation/
>   obj-y += pressure/
> +obj-y += pulse/
>   obj-y += temperature/
>   obj-y += trigger/
>

