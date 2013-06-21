Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161383Ab3FUHr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:47:56 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:11436 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161096Ab3FUHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:47:55 -0400
Date: Fri, 21 Jun 2013 09:47:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Joe Perches <joe@perches.com>, Michal Simek <monstr@monstr.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [lm-sensors] [PATCH] MAINTAINERS: Remove Hans J. Koch entries
Message-ID: <20130621094738.7216c29d@endymion.delvare>
In-Reply-To: <20130621025031.GG4775@local>
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
	<71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com>
	<51A5E644.1040901@monstr.eu>
	<51AC8D43.100@monstr.eu>
	<20130603210513.GA22606@kroah.com>
	<20130620160126.GB22115@amd.pavel.ucw.cz>
	<1371745227.2146.13.camel@joe-AO722>
	<20130621025031.GG4775@local>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans and all,

On Fri, 21 Jun 2013 04:50:31 +0200, Hans J. Koch wrote:
> On Thu, Jun 20, 2013 at 09:20:27AM -0700, Joe Perches wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 69fea4f..dc9d04a 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5253,9 +5253,8 @@ F:	Documentation/hwmon/max16065
> >  F:	drivers/hwmon/max16065.c
> >  
> >  MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
> > -M:	"Hans J. Koch" <hjk@hansjkoch.de>
> >  L:	lm-sensors@lm-sensors.org
> > -S:	Maintained
> > +S:	Orphan
> >  F:	Documentation/hwmon/max6650
> >  F:	drivers/hwmon/max6650.c
> 
> ACK to that one. It was never my idea to have a MAINTAINERS entry for that.
> Jean Delvare suggested it, so it came in. The MAX6650 was in a project I was
> working on 6 years ago, and I wrote the driver at that time. Meanwhile, I
> don't even have hardware with a MAX6650 anymore.

Back then I was maintaining the hwmon subsystem all by myself and had
way more than I could handle on my plate. Contributors kept complaining
that I was too slow reviewing new drivers and having them add
themselves to MAINTAINERS was my way to help them understand that Linux
wasn't only about adding new driver, and that every piece of code added
to the kernel had to be maintained by someone for the years to come.
And that someone was rather them than me.

That being said, I agree it only makes sense for as long as the
original contributor (or anyone else wanting to step in) has the
hardware, interest and knowledge for the driver in question. After
several years it makes sense to drop these individual driver entries if
these conditions are no longer met.

> Does each little driver really need a MAINTAINERS entry? In my opinion, it
> should only be there if it is clear that it's not just a short project work.

The number of drivers in all kernel subsystems keeps growing, and hwmon
is no exception. The number of subsystem maintainers, OTOH, is not
growing, it's typically one or two persons doing all the work. This is
why I value individual driver maintainers, as they help make it all
scale. If existing drivers each have their own maintainer, subsystem
maintainers can focus on subsystem-wide cleanups and reviewing new
drivers.

But of course MAINTAINERS must reflect the reality and not my own
fantasy world where every single driver would have a dedicated
maintainer. If anyone listed as a driver maintainer in MAINTAINERS is
not actually going to do the job for whatever reason, then the entry
should be removed.

-- 
Jean Delvare
