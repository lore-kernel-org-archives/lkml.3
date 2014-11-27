Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaK0VF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:05:29 -0500
Received: from 1wt.eu ([62.212.114.60]:11617 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaK0VF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:05:28 -0500
Date: Thu, 27 Nov 2014 22:05:21 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/9] staging: panel: Use defined value or checking module params state
Message-ID: <20141127210521.GE23012@1wt.eu>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com> <1416429531-11088-5-git-send-email-marius.gorski@gmail.com> <20141126215801.GA32756@kroah.com> <20141127132657.GA12298@firebird> <20141127152417.GB23247@kroah.com> <20141127155706.GB24149@kroah.com> <20141127195054.GA14536@firebird>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127195054.GA14536@firebird>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 08:50:55PM +0100, Mariusz Gorski wrote:
> > And the reason I got confused was because you didn't label your second
> > set of patches "v2", which it was, I saw two separate series, one with a
> > few patches, and then 2 sets of 9, the second set labeled "v2" so I
> > thought they were independant.  Please think of the poor maintainer who
> > has to decipher things like this when you send them out...
> 
> I'm confused right now. As you say, first I've sent a patchset of 4:
> https://lkml.org/lkml/2014/11/11/963
> 
> Then, a couple of days later, I've sent the initial patchset of 9:
> https://lkml.org/lkml/2014/11/18/922
> 
> And a day I've sent a fixed version of the above patchset, labeled with v2:
> https://lkml.org/lkml/2014/11/19/653
> 
> Isn't this the right way to do? I still don't get my mistake. Because
> what I was just about to do is to resend the v2 patchset, but now I'm
> not sure anymore if this is what I'm supposed to do.
> 
> BTW: Out of these 3 patchsets, 1st and 3rd should be applied.

Mariusz, for people who have to parse hundreds to thousands of e-mails
a day, dealing with non-trivial operation modes like this is never easy.

I think (I'll let Greg suggest what he prefers) that the most reliable
thing to do *right now* is to rebase your tree on top of Greg's staging
tree, and you send the resulting series (what you apply *after* staging)
at once, maybe even tagged as v3 to avoid any confusion.

Sometimes for the recipient, things apparently as simple as sorting
e-mails by subjects to find something can cause some confusion when
it's not obvious what replaces what, and tagging with the version or
ensuring that each series is different enough helps avoiding this.

If you need any help, contact me off-list and I'll gladly help you.

Don't worry, issues like this commonly happen and will happen again,
whatever you do against them will only reduce the likeliness that
they happen again (and that's important to care about this) :-)

Thanks,
Willy

