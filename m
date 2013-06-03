Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3FCJsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:48:16 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.114]:35015 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423Ab3FCJsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:48:14 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-14.tower-194.messagelabs.com!1370252890!8331583!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 03 Jun 2013 11:48:10 +0200
Date: Mon, 3 Jun 2013 11:50:26 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Guenter Roeck <linux@roeck-us.net>
CC: <wim@iguana.be>, <guenter@roeck-us.net>, <linux-watchdog@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <johannes.thumshirn@men.de>
Subject: Re: [PATCH v6] watchdog: New watchdog driver for MEN A21 watchdogs
Message-ID: <20130603095026.GA21720@jtlinux>
References: <20130531103654.GB5619@roeck-us.net>
 <20130531110846.GA15707@jtlinux>
 <20130531114037.GA13533@roeck-us.net>
 <20130531125519.GB8983@jtlinux>
 <20130601041523.GB4081@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130601041523.GB4081@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 03 Jun 2013 09:48:10.0233 (UTC) FILETIME=[74FDF690:01CE603F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 09:15:23PM -0700, Guenter Roeck wrote:
> On Fri, May 31, 2013 at 02:55:19PM +0200, Johannes Thumshirn wrote:
> > Hi Guenther,
> > On Fri, May 31, 2013 at 04:40:37AM -0700, Guenter Roeck wrote:
> > > > +#define GPIO_WD_ENAB	169
> > > > +#define GPIO_WD_FAST	170
> > > > +#define GPIO_WD_TRIG	171
> > > > +
> > > > +#define GPIO_RST_CAUSE_BASE 166
> > > > +
> > >
> > > I think I asked that before ... as you are supporting devicetree, gpio pins
> > > should really be provided through devicetree properties and not be hardcoded.
> > >
> > Yes you did and I didn't come up with a solution to this problem yet. I understand
> > and agree to your concerns but I'm lacking example code/documentation for it, maybe
> > you can point me to an example on that and then I'll update my code accordingly.
> >
>
> Have a look at Documentation/devicetree/bindings/gpio/gpio-fan.txt and
> drivers/hwmon/gpio-fan.c.

Thanks a lot, this really helped me out. Updated patch is comming today
including the bindings document Arnd Bergmann requested. I only need to rebase
the sysfs patch on top of that changes.

Regards,
Johannes
