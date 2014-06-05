Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaFECzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 22:55:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaFECzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 22:55:02 -0400
Date: Wed, 4 Jun 2014 19:55:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] serial: samsung: fix typo in debug code
Message-ID: <20140605025500.GA27555@kroah.com>
References: <10455941.RzodM59Z3O@wuerfel>
 <1401931241.26329.16.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401931241.26329.16.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 06:20:41PM -0700, Joe Perches wrote:
> On Tue, 2014-06-03 at 11:53 +0200, Arnd Bergmann wrote:
> > commit e4ac92df2791 ("serial: samsung: Neaten dbg uses") introduced
> > a regression in the conversion from vsprintf to vsnprintf.
> > 
> > This fixes the build error by passing the correct variable name.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Joe Perches <joe@perches.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Doug Anderson <dianders@chromium.org>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > 
> > diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> > index 3293377..c1d3ebd 100644
> > --- a/drivers/tty/serial/samsung.c
> > +++ b/drivers/tty/serial/samsung.c
> > @@ -66,7 +66,7 @@ static void dbg(const char *fmt, ...)
> >  	char buff[256];
> >  
> >  	va_start(va, fmt);
> > -	vscnprintf(buff, sizeof(buf), fmt, va);
> > +	vscnprintf(buff, sizeof(buff), fmt, va);
> >  	va_end(va);
> >  
> >  	printascii(buff);
> 
> Greg?
> 
> The original has ended up in Linus' -next branch.
> 
> Can you please apply this sooner rather than later?

Let me work through these 3.4-stable patches first, so give me a day or
so, thanks.

greg k-h
