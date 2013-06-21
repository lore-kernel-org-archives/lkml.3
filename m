Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738Ab3FUCup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 22:50:45 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:45316 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965652Ab3FUCun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 22:50:43 -0400
Date: Fri, 21 Jun 2013 04:50:31 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Joe Perches <joe@perches.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <monstr@monstr.eu>, "Hans J. Koch" <hjk@hansjkoch.de>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] MAINTAINERS: Remove Hans J. Koch entries
Message-ID: <20130621025031.GG4775@local>
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

I wasn't able to take part in kernel development because I was heavily
involved in hardware development project. I always thought it would be just
a few more days, but then it became half a year. I know I should have given
an explanation and didn't. Sorry for that.

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

ACK to that one. It was never my idea to have a MAINTAINERS entry for that.
Jean Delvare suggested it, so it came in. The MAX6650 was in a project I was
working on 6 years ago, and I wrote the driver at that time. Meanwhile, I
don't even have hardware with a MAX6650 anymore.

Does each little driver really need a MAINTAINERS entry? In my opinion, it
should only be there if it is clear that it's not just a short project work.

>  
> @@ -8795,7 +8794,6 @@ F:	fs/hostfs/
>  F:	fs/hppfs/
>  
>  USERSPACE I/O (UIO)
> -M:	"Hans J. Koch" <hjk@hansjkoch.de>
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  S:	Maintained
>  F:	Documentation/DocBook/uio-howto.tmpl

Well, you can do that if you want. But I still feel associated with UIO
and sincerely hope I'm back again to fulfill my duties as a maintainer.

Thanks,
Hans
