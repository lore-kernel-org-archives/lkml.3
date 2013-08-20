Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3HTXL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:11:26 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52190 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3HTXLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:11:24 -0400
Date: Tue, 20 Aug 2013 16:11:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130820231117.GA24702@roeck-us.net>
References: <20130820224032.GA20491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820224032.GA20491@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 03:40:32PM -0700, Greg KH wrote:
> Hi all,
> 
> Given that I had to just revert a patch in the recent stable releases
> that didn't get enough time to "bake" in Linus's tree (or in -next), I
> figured it was worth discussing some possible changes with how "fast" I
> pick up patches for stable releases.
> 
> So, how about this proposal:
> 
> - I will wait for a -rc to come out with the patch in it before putting
>   it into a stable release, unless:
> 	- the maintainer ACKs it, or sends it directly (like DaveM does
> 	  for networking patches)
> 	- I have seen enough discussion about a patch to show that it
> 	  really does fix something / is good / doesn't cause problems.
> 	- obviously safe, i.e. "add a device id" type thing.
> 
> Given that we have -rc releases every week, except for the initial -rc1
> release, I don't think this will really cause any major delays.
> 
> Also, now that we are about to head into my busy "travel season", odds
> are, I'll be at least a week behind anyway, so this would probably start
> happening without an "official" change.  It's been a boring summer, I've
> been able to keep up with the stable stuff really easily, causing
> problems like this :)
> 
> Objections?  Comments?
> 
Makes sense to me.

It would be even better if you could find the time to push -rc releases
into the stable repository before you accept patches into a stable branch.
I am now running my test suite on stable/master, so that would give it
some time to catch new problems before they make their way into a stable
branch.

Guenter
