Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaK0Ajh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:39:37 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45886 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaK0Ajf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:39:35 -0500
Date: Thu, 27 Nov 2014 00:39:19 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jarod <jarod@wilsonet.com>, "m.chehab" <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "mahfouz.saif.elyazal" <mahfouz.saif.elyazal@gmail.com>,
        "dan.carpenter" <dan.carpenter@oracle.com>,
        "tuomas.tynkkynen" <tuomas.tynkkynen@iki.fi>,
        "gulsah.1004" <gulsah.1004@gmail.com>,
        linux-media <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog.c: fix quoted strings
 split across lines
Message-ID: <20141127003919.GB3249@biggie>
References: <20141125201905.GA10900@biggie>
 <1416947244.8358.12.camel@perches.com>
 <20141125204056.GA12162@biggie>
 <1416949207.8358.14.camel@perches.com>
 <20141125211428.GA12346@biggie>
 <1416966580.8358.17.camel@perches.com>
 <CAPA4HGVJ_gJacLtgtQSJgSjgks9_7aGSuy2+aLOtkz01+Ng7CQ@mail.gmail.com>
 <1417017955.19695.3.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417017955.19695.3.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 08:05:55AM -0800, Joe Perches wrote:
> On Wed, 2014-11-26 at 15:42 +0000, Luis de Bethencourt wrote:
> > On 26 November 2014 at 01:49, Joe Perches <joe@perches.com> wrote:
> []
> > > There is a script I posted a while back that
> > > groups various checkpatch "types" together and
> > > makes it a bit easier to do cleanup style
> > > patches.
> > >
> > > https://lkml.org/lkml/2014/7/11/794
> > That is useful! I just run it on staging/octeon/ and it wrote two patches.
> > Will submit them in a minute.
> 
> Please make sure and write better commit messages
> than the script produces.
> 

Will do :)

> > > Using checkpatch to get familiar with kernel
> > > development is fine and all, but fixing actual
> > > defects and submitting new code is way more
> > > useful.
> []
> > I agree. I was just using checkpatch to learn about the development process.
> > How to create patches, submit patches, follow review, and such. Better to
> > do it
> > with small changes like this first.
> 
> That's a good way to start.
> 
> > Which makes me wonder. Is my patch accepted? Will it be merged? I can do the
> > proposed logging macro additions in a few days. Not sure yet how the final
> > step of the process when patches get accepted and merged works.
> 
> You will generally get an email from a maintainer
> when patches are accepted/rejected or you get
> feedback asking for various changes.
> 
> Greg KH does that for drivers/staging but not for
> drivers/staging/media.  Mauro Carvalho Chehab does.
> 
> These emails are not immediate.  It can take 2 or 3
> weeks for a response.  Sometimes longer, sometimes
> shorter, sometimes no response ever comes.
>

I understand. Busy people.
 
> After a month or so, if you get no response, maybe
> the maintainer never saw it.  You should maybe
> expand the cc: list for the email.
> 
> When the patch is more than a trivial style cleanup,
> Andrew Morton generally picks up orphan patches.
> 
> For some subsystems, there are "tracking" mechanisms
> like patchwork:
> 
> For instance, netdev (net/ and drivers/net/) uses:
> http://patchwork.ozlabs.org/project/netdev/list/
> and David Miller, the primary networking maintainer
> is very prompt about updating it.
> 
> There's this list of patchwork entries, but maintainer
> activity of these lists vary:
> 
> https://patchwork.kernel.org/
> 

Very interesting.

I will follow the process through and learn on the way.

Thanks Joe!
