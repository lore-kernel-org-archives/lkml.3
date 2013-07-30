Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3G3BiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:38:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60019 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab3G3BiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:38:11 -0400
X-Sasl-enc: sKLFU5bKer5lS3W5ISd2DvD3EEp06iBAPxS8wvP3dW9x 1375148289
Date: Mon, 29 Jul 2013 18:38:08 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: linux-next: manual merge of the char-misc tree with Linus' tree
Message-ID: <20130730013808.GA5373@kroah.com>
References: <20130729150129.76a9fab4023ee22c940b7920@canb.auug.org.au>
 <20130729192649.GA9191@kroah.com>
 <20130730102754.749949a5d53c54e4c6c72d53@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730102754.749949a5d53c54e4c6c72d53@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:27:54AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 29 Jul 2013 12:26:49 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > On Mon, Jul 29, 2013 at 03:01:29PM +1000, Stephen Rothwell wrote:
> > > 
> > > Today's linux-next merge of the char-misc tree got a conflict in
> > > drivers/misc/mei/init.c between commit 99f22c4ef24c ("mei: don't have to
> > > clean the state on power up") from Linus' tree and commit b950ac1dabfc
> > > ("mei: don't get stuck in select during reset") from the char-misc tree.
> > > 
> > > (Unrelated white space changes are a pest :-()
> > > 
> > > I fixed it up (see below) and can carry the fix as necessary (no action
> > > is required).
> > 
> > Thanks, I've merged the char-misc-next branch into 3.11-rc3, so this
> > merge problem should no longer be there.
> 
> Unfortunately, I think this is exactly the sort of back merge that Linus
> hates.  He and I are quite capable of coping with relatively complex
> merge conflicts, so ones like this are really not a problem (and "git
> rerere" takes care of it once I have resolved it the first time).  That
> is why I added "no action is required" to my notification messages.
> These messages are really more "this is what I did, please tell me if I
> did something wrong", not "please fix this up"  (I know this message from
> me has changed over time - we can all learn, even us oldies :-))
> 
> Also, if you are doing a merge of fixes that you have submitted to
> Linus, it is probably better to merge your fixes branch rather that
> Linus' tree after he has merged it - that way you are not dragging
> irrelevant stuff from Linus' tree into yours and complicating the git
> history/bisecting so much.
> 
> Of course, if you need something from Linus' tree that someone else put
> there to continue development, then you need to back merge Linus' tree,
> but after rc2 or 3 that should be rare.  And, of course, such a back
> merge needs a good changelog explaining exactly why it was done.

I usually want those fixes from the rcs and merge at that point in time
every other -rc release or so, just to make it much easier for me to
test with, and to pick in the patches I've sent to Linus.

Yes, I could just suck in my fixes branch, but I would be stuck with
trees based on -rc1, which is almost always a pain to test with.

I'm not doing "merges every week", and have been doing it this way for a
few years now with no complaints.  The -rc point in time is a good place
to sync up with it seems.

thanks,

greg k-h
