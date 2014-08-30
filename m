Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaH3WET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 18:04:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaH3WES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 18:04:18 -0400
Date: Sat, 30 Aug 2014 15:04:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: cmroliv@gmail.com, marcel@holtmann.org, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: patch "staging: remove nokia_hp4p driver
Message-ID: <20140830220417.GA15000@kroah.com>
References: <14094295422869@kroah.com>
 <20140830213022.GA17147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140830213022.GA17147@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 11:30:22PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     staging: remove nokia_hp4p driver
> > -Re: [PATCH v6] Bluetooth: Add hci_h4p driver
> > 
> > to my staging git tree which can be found at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> > in the staging-next branch.
> > 
> > The patch will show up in the next release of the linux-next tree
> > (usually sometime within the next 24 hours during the week.)
> > 
> > The patch will also be merged in the next major kernel release
> > during the merge window.
> > 
> > If you have any questions about this process, please let me know.
> 
> What is going on here? I get flamed for not cleaning up the driver,
> because I cleaned it up before merging to -staging. Ok, so I did more
> cleanups, sent 3 cleanup patches, no reaction on those, and now I got
> a note that you are going to remove the driver...?

For the 3 "cleanup" patches, the first one was rejected and you said to
not include it, so I couldn't apply the others.

> Please don't, I'd still like to clean the driver up and get included,
> as n900's are still under active use.

As the Bluetooth maintainer has said a number of times, he doesn't want
the driver in the tree as it is not doing the correct things.  It's been
a long time in the tree with no work on it at all, and I follow the
suggestions of the maintainers of the subsystems that staging drivers
follow.

I suggest cleaning this up in your own tree, and then just submitting it
for inclusion in the "normal" part of the kernel.  That way I'm not
standing in your way on applying patches, and you can work much quicker
to resolve the issues that Marcel has pointed out.

thanks,

greg k-h
