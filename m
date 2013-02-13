Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377Ab3BMQfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:35:22 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61456 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934208Ab3BMQfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:35:20 -0500
X-Originating-IP: 108.223.40.66
Date: Wed, 13 Feb 2013 08:35:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wolfram Sang <wolfram@the-dreams.de>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] MAINTAINERS: Remove Mark M. Hoffman
Message-ID: <20130213163541.GA8700@roeck-us.net>
References: <20130213114629.21008391@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213114629.21008391@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 11:46:29AM +0100, Jean Delvare wrote:
> Mark M. Hoffman stopped working on the Linux kernel several years
> ago, so he should no longer be listed as a driver maintainer. I'm not
> even sure if his e-mail address still works.
> 
> I can take over 3 drivers he was responsible for, the 4th one will
> fall down to the subsystem maintainer.
> 
> Also give Mark credit for all the good work he did.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Wolfram Sang <wolfram@the-dreams.de>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
> Changes since v1:
> * Add a section to file CREDIT, as advised by Andrew Morton.
> 
>  CREDITS     |    8 ++++++++
>  MAINTAINERS |   17 ++---------------
>  2 files changed, 10 insertions(+), 15 deletions(-)
> 
> --- linux-3.8-rc6.orig/MAINTAINERS	2013-02-08 10:55:09.964064131 +0100
> +++ linux-3.8-rc6/MAINTAINERS	2013-02-08 17:08:20.062587939 +0100
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
> --- linux-3.8-rc6.orig/CREDITS	2012-12-15 14:52:44.923989249 +0100
> +++ linux-3.8-rc6/CREDITS	2013-02-13 11:42:05.124318745 +0100
> @@ -1510,6 +1510,14 @@ D: Natsemi ethernet
>  D: Cobalt Networks (x86) support
>  D: This-and-That
>  
> +N: Mark M. Hoffman
> +E: mhoffman@lightlink.com
> +D: asb100, lm93 and smsc47b397 hardware monitoring drivers
> +D: hwmon subsystem core
> +D: hwmon subsystem maintainer
> +D: i2c-sis96x and i2c-stub SMBus drivers
> +S: USA
> +
>  N: Dirk Hohndel
>  E: hohndel@suse.de
>  D: The XFree86[tm] Project
> 
> 
> -- 
> Jean Delvare
> 
