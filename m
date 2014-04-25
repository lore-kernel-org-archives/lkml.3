Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaDYUcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:32:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbaDYUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:32:34 -0400
Date: Fri, 25 Apr 2014 13:35:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jon Ringle <jringle@gridpoint.com>, jon@ringle.org
Subject: Re: [PATCH 1/2] serial: sc16is7xx: depend on I2C
Message-ID: <20140425203528.GA15154@kroah.com>
References: <1398455590-4374-1-git-send-email-jon@ringle.org>
 <20140425202315.GA8821@kroah.com>
 <1398457576.792048107@f368.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398457576.792048107@f368.i.mail.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 12:26:16AM +0400, Alexander Shiyan wrote:
> Fri, 25 Apr 2014 13:23:15 -0700 от Greg KH <gregkh@linuxfoundation.org>:
> > On Fri, Apr 25, 2014 at 03:53:09PM -0400, jon@ringle.org wrote:
> > > From: Jon Ringle <jringle@gridpoint.com>
> > > 
> > > Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> > > ---
> > >  drivers/tty/serial/Kconfig | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> > > index c3e2b32..64c5659 100644
> > > --- a/drivers/tty/serial/Kconfig
> > > +++ b/drivers/tty/serial/Kconfig
> > > @@ -1180,6 +1180,7 @@ config SERIAL_SCCNXP_CONSOLE
> > >  
> > >  config SERIAL_SC16IS7XX
> > >  	tristate "SC16IS7xx serial support"
> > > +	depends on I2C
> > >  	select SERIAL_CORE
> > >  	select REGMAP_I2C if I2C
> > >  	help
> > > -- 
> > > 1.8.5.4
> > 
> > Better, but I still have the build warnings :(
> 
> I hope not same as before?

Exactly the same.
