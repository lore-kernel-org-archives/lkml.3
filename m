Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab3GCSMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:12:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32893 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932630Ab3GCSMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:12:53 -0400
X-Sasl-enc: hbFCXYbi7FXj6l8wM2HMNEkqa2cQF50MNLNrzgbPytsJ 1372875170
Date: Wed, 3 Jul 2013 11:12:49 -0700
From: Greg KH <greg@kroah.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Message-ID: <20130703181249.GA21797@kroah.com>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
 <20130703094529.99444050e676467d281a3b51@canb.auug.org.au>
 <CA+55aFxdAHqEhnV-zKwExVfBAvw=k8+GprTGniNz=TpJM6obtQ@mail.gmail.com>
 <20130703005419.GA7744@kroah.com>
 <CA+55aFxdNVX9koH=GViv1Haj3kU07PD-CTKCNuWrm-c-BF3mQw@mail.gmail.com>
 <20130703010111.GA7986@kroah.com>
 <20130703032941.GH14996@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703032941.GH14996@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 01:29:41PM +1000, Dave Chinner wrote:
> On Tue, Jul 02, 2013 at 06:01:11PM -0700, Greg KH wrote:
> > On Tue, Jul 02, 2013 at 05:58:15PM -0700, Linus Torvalds wrote:
> > > On Tue, Jul 2, 2013 at 5:54 PM, Greg KH <greg@kroah.com> wrote:
> > > > On Tue, Jul 02, 2013 at 05:02:21PM -0700, Linus Torvalds wrote:
> > > >>
> > > >> I'm really not convinced this whole Lustre thing was correctly
> > > >> handled. Merging it into stable and yet being in such bad shape that
> > > >> it isn't enabled even there? I just dunno. But I have the turd in my
> > > >> tree now, let's hope it gets fixed up.
> > > >
> > > > It's in "staging", not "stable" :)
> > > 
> > > Yes. But what was the reason to actually merge it even there? And once
> > > it gets merged, disabling it again rather than fixing the problems it
> > > has?
> > 
> > The problems turned out to be too big, too late in the merge cycle for
> > me to be able to take them (they still aren't even done, as I don't have
> > a working set of patches yet.)  So I just disabled it from the build to
> > give Andreas and team time to get it working properly.
> > 
> > I could have just removed it, but I thought I would give them a chance.
> > 
> > > This is a filesystem that Intel apparently wants to push. I think it
> > > would have been a better idea to push back a bit and say "at least
> > > clean it up a bit first". It's not like Intel is one of the clueless
> > > companies that couldn't have done so and need help from the community.
> > 
> > For this filesystem, it seems that they don't have any resources to do
> > this work and are relying on the community to help out.  Which is odd,
> > but big companies are strange some times...
> 
> Didn't we learn this lesson already with POHMELFS? i.e. that dumping
> filesystem code in staging on the assumption "the community" will
> fix it up when nobody in "the community" uses or can even test that
> filesystem is a broken development model....

They (Intel) has said that they will continue to clean up this code in
the tree, until it is in good enough shape to be merged into fs/
properly.  If they ever stop helping out, I will end up dropping it from
the tree, just like I did for pohmelfs, so don't worry about it
lingering around abandoned.

thanks,

greg k-h
