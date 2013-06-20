Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606Ab3FTQaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:30:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49588 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965396Ab3FTQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:30:45 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 20 Jun 2013 09:30:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Joe Perches <joe@perches.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <monstr@monstr.eu>, "Hans J. Koch" <hjk@hansjkoch.de>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] MAINTAINERS: Remove Hans J. Koch entries
Message-ID: <20130620163049.GB26936@roeck-us.net>
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
 <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com>
 <51A5E644.1040901@monstr.eu>
 <51AC8D43.100@monstr.eu>
 <20130603210513.GA22606@kroah.com>
 <20130620160126.GB22115@amd.pavel.ucw.cz>
 <1371745227.2146.13.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371745227.2146.13.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 09:20:27AM -0700, Joe Perches wrote:
> On Thu, 2013-06-20 at 18:01 +0200, Pavel Machek wrote:
> > Anyway, Hans disappeared, so Greg takes patches, again.
> 
> Maybe this is appropriate then.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 69fea4f..dc9d04a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5253,9 +5253,8 @@ F:	Documentation/hwmon/max16065
>  F:	drivers/hwmon/max16065.c
>  
>  MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
> -M:	"Hans J. Koch" <hjk@hansjkoch.de>
>  L:	lm-sensors@lm-sensors.org
> -S:	Maintained
> +S:	Orphan
>  F:	Documentation/hwmon/max6650
>  F:	drivers/hwmon/max6650.c
>  
Please just drop that entry entirely, causing it to default to hwmon.

Thanks,
Guenter

> @@ -8795,7 +8794,6 @@ F:	fs/hostfs/
>  F:	fs/hppfs/
>  
>  USERSPACE I/O (UIO)
> -M:	"Hans J. Koch" <hjk@hansjkoch.de>
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  S:	Maintained
>  F:	Documentation/DocBook/uio-howto.tmpl
> 
> 
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> 
