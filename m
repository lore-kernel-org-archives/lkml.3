Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3CUAQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:16:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55098 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab3CUAQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:16:30 -0400
X-Sasl-enc: +IiB5WpsXzHool2UaeyNss6bGxLO1oFNeL3ZFHaOj19C 1363824989
Date: Wed, 20 Mar 2013 17:16:28 -0700
From: Greg KH <greg@kroah.com>
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Cc: Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20130321001628.GC27981@kroah.com>
References: <5149D1FD.90400@suse.cz>
 <20130320151511.170EC8017A@viridian.itc.virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130320151511.170EC8017A@viridian.itc.virginia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:15:11AM -0400, Bill Pemberton wrote:
> Jiri Slaby writes:
> > 
> > On 03/20/2013 03:42 PM, Bill Pemberton wrote:
> > > Ok, for the unopened ports there *should* never be any actual data to
> > > push so the push is really doing nothing anyhow in these cases.  It's
> > > coming from the device sending an initial change port command.
> > > 
> > > Anyhow, so my patch adding more is_open logic can be dropped and then
> > > yours will apply fine.  What's the best way for me to handle this?
> > > Send a revert for my patch so yours will apply or send an updated
> > > version of your patch that removes my additions?
> > 
> > Asking Greg to revert should suffice. I commented on that patch, but in
> > a different thread, so Greg missed the comment the patch is not needed
> > IIRC. What was the title of the patch, I cannot find it immediately :/?
> > 
> 
> "USB: quatech2: only write to the tty if the port is open." (commit
> 27b351c in v3.9-rc3).

I've now reverted this, so it should be ok.

greg k-h
