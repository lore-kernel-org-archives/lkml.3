Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3H0Ap2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 20:45:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3H0Ap0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 20:45:26 -0400
Date: Mon, 26 Aug 2013 17:47:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: stable@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Bcache fixes for stable
Message-ID: <20130827004743.GA27241@kroah.com>
References: <20130826220249.GF2798@kmo-pixel>
 <20130826221957.GA2782@kroah.com>
 <20130826232333.GA11778@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826232333.GA11778@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 04:23:33PM -0700, Kent Overstreet wrote:
> On Mon, Aug 26, 2013 at 03:19:57PM -0700, Greg Kroah-Hartman wrote:
> > On Mon, Aug 26, 2013 at 03:02:49PM -0700, Kent Overstreet wrote:
> > > Two fixes that went into 3.11 should've been marked for stable, but I
> > > screwed up and forgot to mark them.
> > > 
> > > One of them fixes bugs that appear to being hit in the wild, so please
> > > pull these:
> > > 
> > > The following changes since commit 0a4b6d4ff200a553951f77f765971cb3e4c91ec0:
> > > 
> > >   Linux 3.10.9 (2013-08-20 15:40:47 -0700)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.10
> > > 
> > > for you to fetch changes up to a213846fafcdf52153dfebf8b1671498a72b6285:
> > > 
> > >   bcache: FUA fixes (2013-08-26 14:56:52 -0700)
> > > 
> > > ----------------------------------------------------------------
> > > Kent Overstreet (1):
> > >       bcache: FUA fixes
> > > 
> > > Kumar Amit Mehta (1):
> > >       md: bcache: io.c: fix a potential NULL pointer dereference
> > 
> > Can I get a hint as to what the git commit ids of these patches are in
> > Linus's tree?
> 
> 5c694129c8db6d89c9be109049a16510b2f70f6d
> e49c7c374e7aacd1f04ecbc21d9dbbeeea4a77d6
> 
> > Ideally, that's all you need to send me, but if you want to send me a
> > git pull, that's fine too, but please use a signed tag, otherwise it's
> > just a random tree...
> 
> *nod* I need to get some more signatures on my gpg key...
> 
> > Also, if you do a git pull, I need the git commit ids in the changelog
> > entry that match Linus's tree, so people (like me) can verify things.
> 
> Ok, I'll remember that for the future.
> 
> > For now, I can edit these two patches and add them in, if you give me
> > the git commit ids to verify them.
> 
> Ok - I don't care too much either way but there were some slightly
> nontrivial conflicts on the second patch, and the one I did backported
> has been tested.

Thanks, I took your second patch, and the first patch directly from
Linus's tree, and added them to the 3.10-stable queue.

greg k-h
