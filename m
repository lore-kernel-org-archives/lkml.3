Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3DLUbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:31:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52541 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3DLUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:31:50 -0400
Date: Fri, 12 Apr 2013 13:31:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: D M German <dmg@uvic.ca>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: helping with tracking commits across repos
Message-ID: <20130412203146.GA31283@kroah.com>
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 01:22:09PM -0700, D M German wrote:
> 
> Hi Everybody,
> 
> I am professor of computer science at the University of Victoria
> (Canada).
> 
> During the last year and a half, we have been trying to track the
> commits as they move in the entire linux git repos ecosystem. We have
> amassed a good amount of data that tell us for every commit (and in fact
> for every unique patch inside a commit) where it has been and whether it
> has reached linus or not ---or any other repository, as a matter of
> fact.
> 
> please look at the following URLs:
> 
> http://o.cs.uvic.ca:20810/perl/cid.pl?cid=9753dfe19a85e7e45a34a56f4cb2048bb4f50e27
> 
> http://o.cs.uvic.ca:20810/perl/cid.pl?cid=55345fb9ff68e2e5c0259c814542e72aec972c02
> 
> or
> 
> http://o.cs.uvic.ca:20810/perl/cid.pl?cid=e59bcdae87ec116dde25da6d725f79fefb253693
> 
> it will give you an idea of the data we have. You can also track other
> commits using the input box, if you are interested.

Very interesting, thanks for the links.

> I wonder if this information is of use to any of you. If you have
> specific needs on how you think this info (and some more we have) can be
> of use, please let me know.

For stable releases, I can't think of anything, other than the tracking
of commits from a stable tree into a distro tree, as you do show
happening above into the openSUSE kernel, which is really nice.

But, for the linux-next stuff, that could be very interesting.  We
always like seeing what commits in a -rc1 release did NOT previously
show up in linux-next.  Stephen has some tools on how to do this, it
would be interesting to see if your tools could do something like that
to track down the "rouge" commits that don't get community testing.

> By the way, I'll be at the Linux Collaboration Summit next week (I am
> involved with the development of SPDX). If any of you is interested to
> meet, please let me know,

I'll be there as well, if you want to talk about this in person, just
grab me if you see me around.

thanks,

greg k-h
