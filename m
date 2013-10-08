Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3JHCIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:08:23 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59781 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3JHCIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:08:22 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 7 Oct 2013 19:08:14 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, gregkh@linux-foundation.org,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] checkpatch: Make the 80-character limit a --strict
 check only
Message-ID: <20131008020814.GD6392@leaf>
References: <20131007191835.GA28737@jtriplet-mobl1>
 <1381174106.2081.207.camel@joe-AO722>
 <20131007193433.GF13643@jtriplet-mobl1>
 <1381174700.2081.209.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381174700.2081.209.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 12:38:20PM -0700, Joe Perches wrote:
> On Mon, 2013-10-07 at 12:34 -0700, Josh Triplett wrote:
> > On Mon, Oct 07, 2013 at 12:28:26PM -0700, Joe Perches wrote:
> > > On Mon, 2013-10-07 at 12:18 -0700, Josh Triplett wrote:
> > > > The 80-character limit is not a hard-and-fast rule, nor should it be
> > > > applied blindly by people running checkpatch and fixing its warnings.
> > > > Sometimes it's better to violate the 80-character "limit" in the name of
> > > > readability, and when it isn't, it's often better to refactor into a
> > > > function or otherwise restructure the code rather than just finding
> > > > increasingly awkward places to break lines.
> > > > 
> > > > Thus, change checkpatch's LONG_LINE warning to a --strict CHK instead.
> > > > Anyone wanting to use checkpatch to check for this can easily enough
> > > > enable --strict or turn on LONG_LINE explicitly, but it shouldn't be
> > > > part of the default warnings.
> > > 
> > > I don't agree with this.
> > > 
> > > CodingStyle says:
> > > ----------------------
> > > The limit on the length of lines is 80 columns and this is a strongly
> > > preferred limit.
> > > ----------------------
> > 
> > Which is the subject of much controversy and extensive discussion, and
> > the consensus on the list (including by many maintainers) frequently
> > differs from that.
> 
> Been there, had that discussion.
> https://lkml.org/lkml/2009/12/18/3

I see many positive responses in that thread, from Linus and others, and
very little negativity (mostly quibbles about implementation, not about
the overall proposal).  What was the problem?

In particular:
> I'll happily remove the checkpatch.pl limit entirely, and ask people to
> try to use common sense, though.

Between that and the positive responses in this thread, I'd love to see
your proposed patch revived.

- Josh Triplett
