Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935061AbaEaCVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 22:21:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbaEaCVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 22:21:52 -0400
Date: Fri, 30 May 2014 19:21:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sune =?iso-8859-1?Q?M=F8lgaard?= <sune@molgaard.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Summarizing deprecations
Message-ID: <20140531022151.GA32348@kroah.com>
References: <53893895.3040202@molgaard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53893895.3040202@molgaard.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 04:04:05AM +0200, Sune Mølgaard wrote:
> Dear list,
> 
> In order to keep this non-code RFC brief, allow me to list a few
> observations and then a proposal, that I shall be happy to engage in,
> but for which I'd like a bit of guidance:
> 
> 1) System calls get superseded and deprecated on a regular basis
> 2) Keeping track of deprecations can be difficult
> 3) HW vendors with out-of-tree drivers allocate too few resources to
> handle 1) and 2)
> 4) Out-of-tree drivers usually fail to take deprecations into
> consideration, and then breaking when deprecation leads to removal
> 
> A knee-jerk reaction to 3) might be that they all need to shape up, but
> experience seems to relegate that reaction to the pile of wishful
> thoughts that lead nowhere.

Not true at all.

> IIRC, Greg K-H once tried to extend an offer to HW vendors to the effect
> of helping with opening their code base, with the reward of helping
> write drivers. I don't know what came of it, but I imagine that I would
> have heard, if it was a roaring success.

It was a success.  Do you know of any hardware that Linux currently does
not support that a vendor wants a Linux driver for it?  I do not.

If you do, send them to me, I'll be glad to work on it, much like all of
the other drivers we have worked on in this program over the years.

Of course, if the vendor doesn't want a Linux driver for their hardware,
well, there's nothing anyone of us can do about that.

> As said, I'm more of a user, so I may be unaware of practices already in
> place to mark commits as causing deprecation, but if such practices
> exist, I should be able to whip up some sort of script that periodically
> does a "git log" and collates deprecations into some format that could
> then be parsed by a bash script grepping various out-of-tree code bases
> and notifies the relevant parties.

Have you looked at the kernel backport group and scripts?  They do much
of this already, automatically, backporting newer drivers to older
kernel versions for people stuck at those releases.  I think what you
want is already completed...

thanks,

greg k-h
