Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaIPHad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:30:33 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.145]:55488 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbaIPHaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:30:30 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-11.tower-180.messagelabs.com!1410852627!35182082!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 16 Sep 2014 09:30:28 +0200
Date: Tue, 16 Sep 2014 10:22:01 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Lee Jones <lee.jones@linaro.org>
CC: Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Adds Andreas Werner to maintainers list for
 MEN F21BMC
Message-ID: <20140916082200.GA499@awelinux>
References: <cover.1409161615.git.andreas.werner@men.de>
 <20140915073625.GA515@awelinux>
 <20140915224219.GE25162@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140915224219.GE25162@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:42:19PM +0100, Lee Jones wrote:
> On Mon, 15 Sep 2014, Andreas Werner wrote:
> 
> > Added maintainer for the following MEN F21BMC drivers:
> > 	- menf21bmc (MFD)
> > 	- menf21bmc_wdt (Watchdog)
> > 	- menf21bmc_hwmon (HWMON)
> > 	- leds-menf21bmc (LED)
> > 
> > Signed-off-by: Andreas Werner <andreas.werner@men.de>
> > ---
> >  MAINTAINERS | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 

Thanks.
I think we are almost complete.
Just the Watchdog needs to be Acked if everything is ok.

Regards
Andy

> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 65cc66d..c4a188c 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5938,6 +5938,15 @@ S:	Supported
> >  F:	drivers/mcb/
> >  F:	include/linux/mcb.h
> >  
> > +MEN F21BMC (Board Management Controller)
> > +M:	Andreas Werner <andreas.werner@men.de>
> > +S:	Supported
> > +F:	drivers/mfd/menf21bmc.c
> > +F:	drivers/watchdog/menf21bmc_wdt.c
> > +F:	drivers/leds/leds-menf21bmc.c
> > +F:	drivers/hwmon/menf21bmc_hwmon.c
> > +F:	Documentation/hwmon/menf21bmc
> > +
> >  METAG ARCHITECTURE
> >  M:	James Hogan <james.hogan@imgtec.com>
> >  L:	linux-metag@vger.kernel.org
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
