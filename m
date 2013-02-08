Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188Ab3BHO43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:56:29 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52830 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab3BHO41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:27 -0500
X-Originating-IP: 108.223.40.66
Date: Fri, 8 Feb 2013 06:56:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MAINTAINERS: Remove Mark M. Hoffman
Message-ID: <20130208145641.GA24787@roeck-us.net>
References: <20130208105437.347ea5b4@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208105437.347ea5b4@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 10:54:37AM +0100, Jean Delvare wrote:
> Mark M. Hoffman stopped working on the Linux kernel several years
> ago, so he should no longer be listed as a driver maintainer. I'm not
> even sure if his e-mail address still works.
> 
> I can take over 3 drivers he was responsible for, the 4th one will

Hi Jean,

	... 2 drivers, the other two ...

as far as I can see from the patch.

Thanks,
Guenter

> fall down to the subsystem maintainer.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> ---
> Mark, if you have any objection, it's now or never.
> 
>  MAINTAINERS |   17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
> 
> --- linux-3.8-rc6.orig/MAINTAINERS	2013-02-02 13:17:46.160665445 +0100
> +++ linux-3.8-rc6/MAINTAINERS	2013-02-08 10:47:01.933759899 +0100
> @@ -1286,12 +1286,6 @@ S:	Maintained
>  F:	drivers/platform/x86/asus*.c
>  F:	drivers/platform/x86/eeepc*.c
>  
> -ASUS ASB100 HARDWARE MONITOR DRIVER
> -M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
> -L:	lm-sensors@lm-sensors.org
> -S:	Maintained
> -F:	drivers/hwmon/asb100.c
> -
>  ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
>  M:	Dan Williams <djbw@fb.com>
>  W:	http://sourceforge.net/projects/xscaleiop
> @@ -3751,7 +3745,7 @@ F:	drivers/i2c/busses/i2c-via.c
>  F:	drivers/i2c/busses/i2c-viapro.c
>  
>  I2C/SMBUS STUB DRIVER
> -M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
> +M:	Jean Delvare <khali@linux-fr.org>
>  L:	linux-i2c@vger.kernel.org
>  S:	Maintained
>  F:	drivers/i2c/i2c-stub.c
> @@ -6906,13 +6900,6 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/ethernet/sis/sis900.*
>  
> -SIS 96X I2C/SMBUS DRIVER
> -M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
> -L:	linux-i2c@vger.kernel.org
> -S:	Maintained
> -F:	Documentation/i2c/busses/i2c-sis96x
> -F:	drivers/i2c/busses/i2c-sis96x.c
> -
>  SIS FRAMEBUFFER DRIVER
>  M:	Thomas Winischhofer <thomas@winischhofer.net>
>  W:	http://www.winischhofer.net/linuxsisvga.shtml
> @@ -6990,7 +6977,7 @@ F:	Documentation/hwmon/sch5627
>  F:	drivers/hwmon/sch5627.c
>  
>  SMSC47B397 HARDWARE MONITOR DRIVER
> -M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
> +M:	Jean Delvare <khali@linux-fr.org>
>  L:	lm-sensors@lm-sensors.org
>  S:	Maintained
>  F:	Documentation/hwmon/smsc47b397
> 
> 
> -- 
> Jean Delvare
> 
