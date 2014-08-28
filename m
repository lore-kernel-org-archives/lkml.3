Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965771AbaH1LSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:18:08 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59467 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965685AbaH1LSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:18:03 -0400
Date: Thu, 28 Aug 2014 12:17:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        support.opensource@diasemi.com
Subject: Re: [PATCH v2 7/7] MAINTAINERS: Include DA9150 files in Dialog
 Semiconductor support list.
Message-ID: <20140828111741.GK24579@lee--X1>
References: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
 <09b13677b1e2d1cf02e4eb43e2777f8081ec9597.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09b13677b1e2d1cf02e4eb43e2777f8081ec9597.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Adam Thomson wrote:

> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> ---
>  MAINTAINERS | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index aefa948..6dc0aee 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2883,12 +2883,15 @@ S:	Supported
>  F:	Documentation/hwmon/da90??
>  F:	drivers/gpio/gpio-da90??.c
>  F:	drivers/hwmon/da90??-hwmon.c
> +F:	drivers/iio/adc/da91??-*.c
>  F:	drivers/input/misc/da90??_onkey.c
>  F:	drivers/input/touchscreen/da9052_tsi.c
>  F:	drivers/leds/leds-da90??.c
>  F:	drivers/mfd/da903x.c
>  F:	drivers/mfd/da90??-*.c
> +F:	drivers/mfd/da91??-*.c
>  F:	drivers/power/da9052-battery.c
> +F:	drivers/power/da91??-*.c
>  F:	drivers/regulator/da903x.c
>  F:	drivers/regulator/da9???-regulator.[ch]
>  F:	drivers/rtc/rtc-da90??.c
> @@ -2898,6 +2901,7 @@ F:	include/linux/mfd/da903x.h
>  F:	include/linux/mfd/da9052/
>  F:	include/linux/mfd/da9055/
>  F:	include/linux/mfd/da9063/
> +F:	include/linux/mfd/da9150/
>  F:	include/sound/da[79]*.h
>  F:	sound/soc/codecs/da[79]*.[ch]
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
