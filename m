Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935105Ab3DOXJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:09:34 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59386 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933440Ab3DOXJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:09:33 -0400
X-Sasl-enc: e+JvIiOE8a4soIJlqdJ+aRTAcPPjN9MK7lmheW2EQGXy 1366067372
Date: Mon, 15 Apr 2013 16:09:23 -0700
From: Greg KH <greg@kroah.com>
To: D M German <dmg@uvic.ca>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: helping with tracking commits across repos
Message-ID: <20130415230923.GA2417@kroah.com>
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
 <20130412203146.GA31283@kroah.com>
 <87r4ibpiq9.fsf@mn.cs.uvic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4ibpiq9.fsf@mn.cs.uvic.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 02:49:34PM -0700, D M German wrote:
> 
> 
> Greg KH twisted the bytes to say:
> 
>  Greg> But, for the linux-next stuff, that could be very interesting.  We
>  Greg> always like seeing what commits in a -rc1 release did NOT previously
>  Greg> show up in linux-next.  Stephen has some tools on how to do this, it
>  Greg> would be interesting to see if your tools could do something like that
>  Greg> to track down the "rouge" commits that don't get community testing.
> 
> 
> Hi Greg,
> 
> Let me see if I understood you.
> 
> I looked into commits created during 2013 that satisfy the following
> condition:
> 
> * We observed them in Linus repo _before_ Linux-next (that does not
> necessarily mean they didn't appear in linus before linux next)
> * Are not merge commits
> * Were committed in 2013 (no point of showing you 2012, i guess).
> 
> they are listed here (it takes a couple of minutes to create the list... so
> it is not a realtime list, but I that can be fixed
> if it is useful):
> 
> http://o.cs.uvic.ca:20810/perl/next.pl

Yes, that's a great thing.  Maybe the ability to see the subject: line
of the commit somewhere easier than having to click through to the patch
would be nice, so we can just glance at the report and say, "Look at all
of the btrfs patches that showed up out of nowhere, what happened?"

Oh, and if you could do it for a specific kernel release, not a date
range, that would be nice (i.e. report for 3.9-rc1, 3.8-rc1, 3.7-rc1,
etc.)

> is this what you had in mind? obviously Linus commits appear in his repo
> before Next, so I could drop him from the report.

That's just a tiny number so it's probably not needed.

> I have also added the commit that merges each commit, which is probably
> useful too. If it is empty either we haven't update the data or it
> was done straight into linus repo (as in 3e2e0d2c222bdf5bafd722dec1618fa6073ef372).

Yes, that is useful, thanks.

greg k-h
