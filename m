Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272Ab3FSWOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:14:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab3FSWOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:14:43 -0400
Date: Wed, 19 Jun 2013 15:15:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Fabio Estevam <festevam@gmail.com>, linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Nightly stable builds [Was: fec: Fix build for MCF5272]
Message-ID: <20130619221519.GB9518@kroah.com>
References: <1371575099-2962-1-git-send-email-linux@roeck-us.net>
 <CAOMZO5CU57Jqtzt2ZX=TYiemn5okASo4GU_zer+j736J8yj0OQ@mail.gmail.com>
 <20130619204348.GA7314@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619204348.GA7314@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 01:43:48PM -0700, Guenter Roeck wrote:
> On Wed, Jun 19, 2013 at 10:42:36AM -0300, Fabio Estevam wrote:
> > Hi Guenter,
> > 
> > FYI
> > 
> > I asked Stephen to include m5272c3_defconfig as part of his daily
> > build and now it is available:
> > http://kisskb.ellerman.id.au/kisskb/buildresult/8991795/
> > 
> Nice front-end.
> 
> Greg, would it be useful to set up something similar for pending stable builds ?
> I have back-end code doing that running on one of my servers at home, but no
> web front-end.
> 
> Any idea whom to talk to to set this up ? Stephen ? Michael ?

I have no idea.  I publish the stable build patches all publically, so a
build-bot could easily be built using it, which would be great to have.

thanks

greg k-h
