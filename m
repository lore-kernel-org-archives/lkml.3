Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaFBHQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:16:39 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:47475 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaFBHQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:16:37 -0400
Date: Mon, 2 Jun 2014 09:16:07 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oliver@neukum.org>,
        Matthias Urlichs <smurf@smurf.noris.de>
Cc: Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: drop two usb-serial subdriver entries
Message-ID: <20140602071607.GD14935@localhost>
References: <1401615137-11862-1-git-send-email-jhovold@gmail.com>
 <20140601174559.GB1281@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140601174559.GB1281@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 10:45:59AM -0700, Greg Kroah-Hartman wrote:
> On Sun, Jun 01, 2014 at 11:32:17AM +0200, Johan Hovold wrote:
> > Remove the remaining two obsolete usb-serial subdriver entries from
> > MAINTAINERS, which were missed in the recent purge by commit
> > f896b7968b62 ("USB: Maintainers change for usb serial drivers").
> > 
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > ---
> >  MAINTAINERS | 12 ------------
> >  1 file changed, 12 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 51ebb779c5f3..68599b26f514 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9298,12 +9298,6 @@ S:	Maintained
> >  F:	drivers/usb/host/isp116x*
> >  F:	include/linux/usb/isp116x.h
> >  
> > -USB KAWASAKI LSI DRIVER
> > -M:	Oliver Neukum <oliver@neukum.org>
> > -L:	linux-usb@vger.kernel.org
> > -S:	Maintained
> > -F:	drivers/usb/serial/kl5kusb105.*
> > -
> >  USB MASS STORAGE DRIVER
> >  M:	Matthew Dharm <mdharm-usb@one-eyed-alien.net>
> >  L:	linux-usb@vger.kernel.org
> > @@ -9331,12 +9325,6 @@ S:	Maintained
> >  F:	Documentation/usb/ohci.txt
> >  F:	drivers/usb/host/ohci*
> >  
> > -USB OPTION-CARD DRIVER
> > -M:	Matthias Urlichs <smurf@smurf.noris.de>
> > -L:	linux-usb@vger.kernel.org
> > -S:	Maintained
> > -F:	drivers/usb/serial/option.c
> 
> Why are we taking away the maintainership of these individual drivers
> from these developers?  I had no problem giving you the drivers I was
> supposed to be in charge of, but I need a signed-off-by from Matthias
> and Oliver for these if they want to do the same.

I honestly thought you had just missed these entries when you removed
individual maintainership for the other usb-serial drivers with the
motivation that the developers were not around and that maintainership
for individual drivers did not make much sense anymore (as consolidation
proceeds, I read). (These two entries were also not grouped with the
others.)

Oliver and perhaps also Mathias are still around, but the option driver
is now down to about 200 LOC (including boilerplate) when not counting
the id table, while the kl5kusb105 is currently at about 400 LOC
(including boilerplate) since I converted it to use the generic
implementation a few years ago.

Oliver and Mathias, what do you think of this? Would you be willing to
sign off on this patch?

Thanks,
Johan
