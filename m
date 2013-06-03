Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3FCTIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:08:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3FCTIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:08:16 -0400
Date: Mon, 3 Jun 2013 12:08:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Chan <benchan@chromium.org>
Cc: devel@driverdev.osuosl.org, Sage Ahn <syahn@gctsemi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: WIMAX_GDM72XX should depend on either
 USB or MMC
Message-ID: <20130603190815.GB1820@kroah.com>
References: <1370280225-27479-1-git-send-email-benchan@chromium.org>
 <20130603183044.GA10608@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603183044.GA10608@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 11:30:45AM -0700, Greg Kroah-Hartman wrote:
> On Mon, Jun 03, 2013 at 10:23:45AM -0700, Ben Chan wrote:
> > The gdm72xx driver needs to have either the USB or SDIO implementation
> > enabled to provide useful functionalities, so the driver should depend
> > on either USB or MMC.
> > 
> > Signed-off-by: Ben Chan <benchan@chromium.org>
> > Cc: Sage Ahn <syahn@gctsemi.com>
> > ---
> >  drivers/staging/gdm72xx/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/gdm72xx/Kconfig b/drivers/staging/gdm72xx/Kconfig
> > index 6905913..8af0dd4 100644
> > --- a/drivers/staging/gdm72xx/Kconfig
> > +++ b/drivers/staging/gdm72xx/Kconfig
> > @@ -4,7 +4,7 @@
> >  
> >  menuconfig WIMAX_GDM72XX
> >  	tristate "GCT GDM72xx WiMAX support"
> > -	depends on NET
> > +	depends on NET && (USB || MMC)
> 
> Really?  Again?
> 
> Are you trying to just get me to ignore your patches?
> 
> If so, you just did a good job, please take a day or two to relax and
> get it right.

Crap, slow mailing list, just decided to spit out the second copy of
this to me, sorry for the rant, I need more coffee.

Or maybe less...

My apologies.

greg k-h
