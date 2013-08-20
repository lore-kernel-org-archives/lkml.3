Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3HTXMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:12:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3HTXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:12:08 -0400
Date: Tue, 20 Aug 2013 16:12:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130820231207.GA703@kroah.com>
References: <20130820224032.GA20491@kroah.com>
 <1377039840.32763.11.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377039840.32763.11.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:04:00PM -0700, Nicholas A. Bellinger wrote:
> On Tue, 2013-08-20 at 15:40 -0700, Greg KH wrote:
> > Hi all,
> > 
> > Given that I had to just revert a patch in the recent stable releases
> > that didn't get enough time to "bake" in Linus's tree (or in -next), I
> > figured it was worth discussing some possible changes with how "fast" I
> > pick up patches for stable releases.
> > 
> > So, how about this proposal:
> > 
> > - I will wait for a -rc to come out with the patch in it before putting
> >   it into a stable release, unless:
> > 	- the maintainer ACKs it, or sends it directly (like DaveM does
> > 	  for networking patches)
> > 	- I have seen enough discussion about a patch to show that it
> > 	  really does fix something / is good / doesn't cause problems.
> > 	- obviously safe, i.e. "add a device id" type thing.
> > 
> > Given that we have -rc releases every week, except for the initial -rc1
> > release, I don't think this will really cause any major delays.
> > 
> > Also, now that we are about to head into my busy "travel season", odds
> > are, I'll be at least a week behind anyway, so this would probably start
> > happening without an "official" change.  It's been a boring summer, I've
> > been able to keep up with the stable stuff really easily, causing
> > problems like this :)
> > 
> > Objections?  Comments?
> 
> Sounds like a reasonable tradeoff, as long as the 'please include this
> to stable ASAP' latency for critical fixes does not end up being too
> large..

Given the current number of those that I get are relativly small, it
shouldn't be that big of a deal.

All this really means is that I get a week vacation now, and then I'll
pick back up with stable releases :)

thanks,

greg k-h
