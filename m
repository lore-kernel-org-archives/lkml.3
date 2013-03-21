Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3CUXr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:47:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58788 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932882Ab3CUXr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:47:26 -0400
X-Sasl-enc: 9vbZDgoHSY530wHEaswK7IZGxe4aEA6WI4dsH1RTca1N 1363909646
Date: Thu, 21 Mar 2013 16:47:24 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Jiri Slaby <jslaby@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20130321234724.GA1734@kroah.com>
References: <5149D1FD.90400@suse.cz>
 <20130320151511.170EC8017A@viridian.itc.virginia.edu>
 <20130321001628.GC27981@kroah.com>
 <20130322095423.799b201fd0f6671e8127c2ac@canb.auug.org.au>
 <20130322102808.5bdd9e5e0d98733e202e49c2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322102808.5bdd9e5e0d98733e202e49c2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 10:28:08AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Fri, 22 Mar 2013 09:54:23 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Wed, 20 Mar 2013 17:16:28 -0700 Greg KH <greg@kroah.com> wrote:
> > >
> > > On Wed, Mar 20, 2013 at 11:15:11AM -0400, Bill Pemberton wrote:
> > > > Jiri Slaby writes:
> > > > > 
> > > > > On 03/20/2013 03:42 PM, Bill Pemberton wrote:
> > > > > 
> > > > > Asking Greg to revert should suffice. I commented on that patch, but in
> > > > > a different thread, so Greg missed the comment the patch is not needed
> > > > > IIRC. What was the title of the patch, I cannot find it immediately :/?
> > > > 
> > > > "USB: quatech2: only write to the tty if the port is open." (commit
> > > > 27b351c in v3.9-rc3).
> > > 
> > > I've now reverted this, so it should be ok.
> > 
> > That patch needed to be reverted in your tty tree, not your usb tree
> > since it breaks a patch added to your tty tree (see Subject).
> 
> Except, of course, commit 27b351c is not in your tty tree :-(

Which was causing me lots of confusion :)

I've merged it in there now, and reverted it, so all should be good.

greg k-h
