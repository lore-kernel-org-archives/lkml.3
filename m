Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3GDA2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 20:28:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60813 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432Ab3GDA2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 20:28:04 -0400
X-Sasl-enc: GenNBP+3QM5jmItJdTrtjW3hu9eqVnWhiwzXDxhU5OI4 1372897682
Date: Wed, 3 Jul 2013 17:28:41 -0700
From: Greg KH <greg@kroah.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Message-ID: <20130704002841.GA8962@kroah.com>
References: <20130703181249.GA21797@kroah.com>
 <CDF9C6B7.51285%andreas.dilger@intel.com>
 <20130703235444.GF4072@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703235444.GF4072@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 09:54:44AM +1000, Dave Chinner wrote:
> On Wed, Jul 03, 2013 at 06:40:40PM +0000, Dilger, Andreas wrote:
> > On 2013/03/07 12:12 PM, "Greg KH" <greg@kroah.com> wrote:
> > >On Wed, Jul 03, 2013 at 01:29:41PM +1000, Dave Chinner wrote:
> > >> On Tue, Jul 02, 2013 at 06:01:11PM -0700, Greg KH wrote:
> > >> > For this filesystem, it seems that they don't have any
> > >> > resources to do this work and are relying on the community to
> > >> > help out.  Which is odd, but big companies are strange some
> > >> > times...
> > >> 
> > >> Didn't we learn this lesson already with POHMELFS? i.e. that
> > >> dumping filesystem code in staging on the assumption "the
> > >> community" will fix it up when nobody in "the community" uses
> > >> or can even test that filesystem is a broken development
> > >> model....
> > >
> > >They (Intel) has said that they will continue to clean up this
> > >code in the tree, until it is in good enough shape to be merged
> > >into fs/ properly.  If they ever stop helping out, I will end up
> > >dropping it from the tree, just like I did for pohmelfs, so don't
> > >worry about it lingering around abandoned.
> > 
> > Right, we are going to continue working on cleaning the code at a
> > steady pace until it is ready to move to fs/.  I don't expect Al
> > or Dave or Christoph to spend their time (or make their eyes
> > bleed) with the current state of the code.  It has already
> > undergone some significant cleanup, but needs a bunch more still.
> 
> The issue I'm more concerned about is more to do with what happens
> when we do something that affects all filesystems, such as API
> changes. Then we are forced to look at it and to try to work out
> what the hell is going on. This was the real problem with pomelhfs
> being in staging - it had an unreasonably high maintenance overhead
> compared to other filesystems.
> 
> This was mainly because pohelmfs was effectively dumped in staging
> and then left unmaintained - if there's consistent effort put into
> the Lustre code to clean it up, maintain it and help with API
> transitions, then I have nothing to object to and I'll just crawl
> back into my box. ;)

Again, as with all code in the drivers/staging/ area, if you change any
kernel apis, you are not responsible for fixing up the staging drivers,
that's my job.  A heads-up is always nice, but again, not required.  You
should be able to just safely ignore them if you don't want to ever look
at them.

thanks,

greg k-h
