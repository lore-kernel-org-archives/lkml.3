Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbaHFTOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:14:36 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55399 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbaHFTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:14:34 -0400
Date: Wed, 6 Aug 2014 12:14:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <greg@kroah.com>
Cc: Nick Krause <xerofoiffy@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] spi: Remove unused definitions
Message-ID: <20140806191430.GA5711@roeck-us.net>
References: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
 <20140806183319.GA15654@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806183319.GA15654@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 11:33:19AM -0700, Greg KH wrote:
> On Wed, Aug 06, 2014 at 01:53:17PM -0400, Nick Krause wrote:
> > Remove unused definition which cause the following warnings
> > 
> > drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
> > include/linux/fs.h:193:0: note: this is the location of the previous definition
> > drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
> > include/linux/fs.h:192:0: note: this is the location of the previous definition
> > 
> > Signed-off-by: Nick Krause <xerofoiffy@gmail.com>
> > ---
> >  drivers/spi/spi-omap-100k.c | 4 ----
> >  1 file changed, 4 deletions(-)
> 
> Nick, you were warned about this numerous times in the past.
> 
> By changing email addresses you have now ensured that we will never
> listen to you, as you obviously are not listening to us.
> 
He does manage to get our attention, though. Also, it is not that simple -
for my part I keep looking out for the patches just to make sure that
we don't get any more less than well researched "fixes" into the kernel.
I figure it pays to spend some time now instead of having to clean up
the resulting mess if something slips by.

Guenter
