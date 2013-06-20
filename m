Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724Ab3FTRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:09:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55015 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965397Ab3FTRJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:09:57 -0400
Message-ID: <1371748196.2146.17.camel@joe-AO722>
Subject: Re: [lm-sensors] [PATCH] MAINTAINERS: Remove Hans J. Koch entries
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <monstr@monstr.eu>, "Hans J. Koch" <hjk@hansjkoch.de>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Date: Thu, 20 Jun 2013 10:09:56 -0700
In-Reply-To: <20130620163049.GB26936@roeck-us.net>
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
	 <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com>
	 <51A5E644.1040901@monstr.eu> <51AC8D43.100@monstr.eu>
	 <20130603210513.GA22606@kroah.com>
	 <20130620160126.GB22115@amd.pavel.ucw.cz>
	 <1371745227.2146.13.camel@joe-AO722> <20130620163049.GB26936@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 09:30 -0700, Guenter Roeck wrote:
> On Thu, Jun 20, 2013 at 09:20:27AM -0700, Joe Perches wrote:
> > On Thu, 2013-06-20 at 18:01 +0200, Pavel Machek wrote:
> > > Anyway, Hans disappeared, so Greg takes patches, again.
[]
> >  MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
> > -M:	"Hans J. Koch" <hjk@hansjkoch.de>
> >  L:	lm-sensors@lm-sensors.org
> > -S:	Maintained
> > +S:	Orphan
> >  F:	Documentation/hwmon/max6650
> >  F:	drivers/hwmon/max6650.c
> >  
> Please just drop that entry entirely, causing it to default to hwmon.

It was mostly a nudge for Hans.

Maybe in a few weeks if Hans doesn't reply that'd
make sense.

I don't have any issue with marking specific files
as orphan though.  Orphan can help others identify
files that might need care.

I just looked for the first time at max6650.c too.
It's got a spirentcom copyright which amuses me.


