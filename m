Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3FZLI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:08:28 -0400
Received: from csmtp3.one.com ([91.198.169.23]:40675 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab3FZLI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:08:27 -0400
Date: Wed, 26 Jun 2013 13:08:23 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc/bmp085: Enable building as a module
Message-ID: <20130626110823.GA25070@scully.xfiles.lan>
References: <1372083021.21189.19.camel@deadeye.wl.decadent.org.uk>
 <20130625072728.GB24258@scully.xfiles.lan>
 <1372162617.4006.0.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372162617.4006.0.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:16 Tue 25 Jun     , Ben Hutchings wrote:
> On Tue, 2013-06-25 at 09:27 +0200, Eric Andersson wrote:
> > On 15:10 Mon 24 Jun     , Ben Hutchings wrote:
> > > Commit 985087dbcb02 'misc: add support for bmp18x chips to the bmp085
> > > driver' changed the BMP085 config symbol to a boolean.  I see no
> > > reason why the shared code cannot be built as a module, so change it
> > > back to tristate.
> > > 
> > > Cc: Eric Andersson <eric.andersson@unixphere.com>
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > ---
> > >  drivers/misc/Kconfig |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > > index c002d86..7a68184 100644
> > > --- a/drivers/misc/Kconfig
> > > +++ b/drivers/misc/Kconfig
> > > @@ -451,7 +451,7 @@ config ARM_CHARLCD
> > >  	  still useful.
> > >  
> > >  config BMP085
> > > -	bool
> > > +	tristate
> > >  	depends on SYSFS
> > >  
> > >  config BMP085_I2C
> > > 
> > 
> > There is no reason for building the common code stand-alone. The BMP085
> > config option is only selectable via the BMP085_I2C/_SPI options.
> 
> Yes, but it is then always built-in.

Good point. This change is fine by me.

-- 
Best regards,
 Eric

 http://www.unixphere.com
