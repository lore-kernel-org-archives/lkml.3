Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393Ab3FSXYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:24:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56465 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3FSXYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:24:14 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 19 Jun 2013 16:24:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fabio Estevam <festevam@gmail.com>, linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Nightly stable builds [Was: fec: Fix build for MCF5272]
Message-ID: <20130619232415.GA27990@roeck-us.net>
References: <1371575099-2962-1-git-send-email-linux@roeck-us.net>
 <CAOMZO5CU57Jqtzt2ZX=TYiemn5okASo4GU_zer+j736J8yj0OQ@mail.gmail.com>
 <20130619204348.GA7314@roeck-us.net>
 <20130619221519.GB9518@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619221519.GB9518@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 03:15:19PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Jun 19, 2013 at 01:43:48PM -0700, Guenter Roeck wrote:
> > On Wed, Jun 19, 2013 at 10:42:36AM -0300, Fabio Estevam wrote:
> > > Hi Guenter,
> > > 
> > > FYI
> > > 
> > > I asked Stephen to include m5272c3_defconfig as part of his daily
> > > build and now it is available:
> > > http://kisskb.ellerman.id.au/kisskb/buildresult/8991795/
> > > 
> > Nice front-end.
> > 
> > Greg, would it be useful to set up something similar for pending stable builds ?
> > I have back-end code doing that running on one of my servers at home, but no
> > web front-end.
> > 
> > Any idea whom to talk to to set this up ? Stephen ? Michael ?
> 
> I have no idea.  I publish the stable build patches all publically, so a
> build-bot could easily be built using it, which would be great to have.
> 
The build-bot isn't the problem; as I mentioned above, I already have one
running. I was referring to a web front-end for it.

Thanks,
Guenter
