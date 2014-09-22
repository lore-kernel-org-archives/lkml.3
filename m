Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaIVWwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:52:03 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39949 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaIVWwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:52:02 -0400
Date: Mon, 22 Sep 2014 15:51:56 -0700
From: josh@joshtriplett.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please add the tiny tree to linux-next
Message-ID: <20140922225156.GA929@cloud>
References: <20140922175301.GA27348@thin>
 <20140923083442.15400844@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923083442.15400844@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 08:34:42AM +1000, Stephen Rothwell wrote:
> Hi Josh,
> 
> On Mon, 22 Sep 2014 10:53:04 -0700 Josh Triplett <josh@joshtriplett.org> wrote:
> >
> > Can you please add the tiny tree, branch tiny/next of
> > https://git.kernel.org/pub/scm/linux/kernel/git/josh/linux.git , to
> > linux-next?
> > 
> > I'll be using this tree to upstream various patches for Linux kernel
> > tinification.  I plan to use topic branches under tiny/* for separate
> > topics, typically based on the previous -rc1, merging them into
> > tiny/next; when the merge window opens, I'll submit a pull request for
> > tiny/next and start merging new tiny/* topic branches into a
> > tiny/next-next branch or similar that will become the new tiny/next
> > after tiny/next gets merged.
> 
> Added from today.  I used git:// instead of https:// for the URL.
> 
> I do not want code for release N in linux-next until after (N-1)-rc1
> has been released.

So, rather than moving tiny/next-next to tiny/next as soon as tiny/next
gets merged during the merge window, wait until the end of the merge
window (and the release of -rc1) to do so?  That makes sense, to avoid
causing confusion and unnecessary conflicts during the merge window.

The code in tiny/next right now is based on 3.17-rc1, and is intended
for 3.18.  I'll send a pull request for 3.18 as soon as the 3.18 merge
window opens, and any patches I receive after that point will go into
tiny/next-next.  I'll wait to move tiny/next-next to tiny/next until
3.18-rc1 is released.

- Josh Triplett
