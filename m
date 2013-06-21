Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423019Ab3FUBVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:21:08 -0400
Received: from ozlabs.org ([203.10.76.45]:60889 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161101Ab3FUBVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:21:06 -0400
Message-ID: <1371777661.5490.2.camel@concordia>
Subject: Re: Nightly stable builds [Was: fec: Fix build for MCF5272]
From: Michael Ellerman <michael@ellerman.id.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <festevam@gmail.com>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 21 Jun 2013 11:21:01 +1000
In-Reply-To: <20130619232415.GA27990@roeck-us.net>
References: <1371575099-2962-1-git-send-email-linux@roeck-us.net>
	 <CAOMZO5CU57Jqtzt2ZX=TYiemn5okASo4GU_zer+j736J8yj0OQ@mail.gmail.com>
	 <20130619204348.GA7314@roeck-us.net> <20130619221519.GB9518@kroah.com>
	 <20130619232415.GA27990@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2013-06-19 at 16:24 -0700, Guenter Roeck wrote:
> On Wed, Jun 19, 2013 at 03:15:19PM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Jun 19, 2013 at 01:43:48PM -0700, Guenter Roeck wrote:
> > > On Wed, Jun 19, 2013 at 10:42:36AM -0300, Fabio Estevam wrote:
> > > > Hi Guenter,
> > > > 
> > > > FYI
> > > > 
> > > > I asked Stephen to include m5272c3_defconfig as part of his daily
> > > > build and now it is available:
> > > > http://kisskb.ellerman.id.au/kisskb/buildresult/8991795/
> > > > 
> > > Nice front-end.
> > > 
> > > Greg, would it be useful to set up something similar for pending stable builds ?
> > > I have back-end code doing that running on one of my servers at home, but no
> > > web front-end.
> > > 
> > > Any idea whom to talk to to set this up ? Stephen ? Michael ?
> > 
> > I have no idea.  I publish the stable build patches all publically, so a
> > build-bot could easily be built using it, which would be great to have.
> > 
> The build-bot isn't the problem; as I mentioned above, I already have one
> running. I was referring to a web front-end for it.

Hi Guenter,

Actually I hate the web front end, but that's because I wrote it :)

It's pretty, but it doesn't scale very well, "one of these days" I'll
rewrite it. My plan is to actually just make it a frontend for buildbot
- but I never have time :)

We already build the published stable branches, see:
  http://kisskb.ellerman.id.au/kisskb/branch/

But I think you're talking about building the patch queues before they
go into git? If so the only hurdle would be someone publishing a git
tree of them - kisskb only knows how to build git trees.

cheers


