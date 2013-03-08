Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410Ab3CHQY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:24:58 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:12941 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab3CHQY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:24:57 -0500
Date: Fri, 8 Mar 2013 17:24:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add maintainer for MAX6697, INA209, and
 INA2XX drivers
Message-ID: <20130308172444.5df9b8d8@endymion.delvare>
In-Reply-To: <1362759722-8252-1-git-send-email-linux@roeck-us.net>
References: <1362759722-8252-1-git-send-email-linux@roeck-us.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Mar 2013 08:22:02 -0800, Guenter Roeck wrote:
> I actively maintain those drivers and have hardware available
> to test changes, so add me as explicit maintainer.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  MAINTAINERS |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9561658..1a5aca7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4005,6 +4005,22 @@ M:	Stanislaw Gruszka <stf_xl@wp.pl>
>  S:	Maintained
>  F:	drivers/usb/atm/ueagle-atm.c
>  
> +INA209 HARDWARE MONITOR DRIVER
> +M:	Guenter Roeck <linux@roeck-us.net>
> +L:	lm-sensors@lm-sensors.org
> +S:	Maintained
> +F:	Documentation/hwmon/ina209
> +F:	Documentation/devicetree/bindings/i2c/ina209.txt
> +F:	drivers/hwmon/ina209.c
> +
> +INA2XX HARDWARE MONITOR DRIVER
> +M:	Guenter Roeck <linux@roeck-us.net>
> +L:	lm-sensors@lm-sensors.org
> +S:	Maintained
> +F:	Documentation/hwmon/ina2xx
> +F:	drivers/hwmon/ina2xx.c
> +F:	include/linux/platform_data/ina2xx.h
> +
>  INDUSTRY PACK SUBSYSTEM (IPACK)
>  M:	Samuel Iglesias Gonsalvez <siglesias@igalia.com>
>  M:	Jens Taprogge <jens.taprogge@taprogge.org>
> @@ -5098,6 +5114,15 @@ S:	Maintained
>  F:	Documentation/hwmon/max6650
>  F:	drivers/hwmon/max6650.c
>  
> +MAX6697 HARDWARE MONITOR DRIVER
> +M:	Guenter Roeck <linux@roeck-us.net>
> +L:	lm-sensors@lm-sensors.org
> +S:	Maintained
> +F:	Documentation/hwmon/max6697
> +F:	Documentation/devicetree/bindings/i2c/max6697.txt
> +F:	drivers/hwmon/max6697.c
> +F:	include/linux/platform_data/max6697.h
> +
>  MAXIRADIO FM RADIO RECEIVER DRIVER
>  M:	Hans Verkuil <hverkuil@xs4all.nl>
>  L:	linux-media@vger.kernel.org

Acked-by: Jean Delvare <khali@linux-fr.org>

And thanks for volunteering to maintain these drivers.

-- 
Jean Delvare
