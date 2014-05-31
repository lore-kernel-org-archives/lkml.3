Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaEaC4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 22:56:38 -0400
Received: from mail1-ar.fullrate.dk ([90.185.3.41]:53779 "EHLO
	mail1-ar.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbaEaC4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 22:56:37 -0400
Message-ID: <538944E2.2070706@molgaard.org>
Date: Sat, 31 May 2014 04:56:34 +0200
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29a1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Summarizing deprecations
References: <53893895.3040202@molgaard.org> <20140531022151.GA32348@kroah.com>
In-Reply-To: <20140531022151.GA32348@kroah.com>
X-Enigmail-Version: 1.7a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, and thank you for correcting me!

Greg KH wrote:
[snip]
> Not true at all.

I trust you to know enough to be correct, but as we speak, I have at
least 3 pieces of hardware, whose (out-of-tree) drivers regularly fail
to compile come a new rc1. I usually manage to find or create a patch,
but the breakage is usually due to months-old deprecations of system
calls that finally (and understandably) where removed in those new rc1s.

My experience is that vendors are not only blissfully aware of such
changes until removal, but will generally only support final kernel
versions - even if the deprecation/removal was announced several
versions earlier.

[snip]
> It was a success.  Do you know of any hardware that Linux currently does
> not support that a vendor wants a Linux driver for it?  I do not.
> 
> If you do, send them to me, I'll be glad to work on it, much like all of
> the other drivers we have worked on in this program over the years.
> 
> Of course, if the vendor doesn't want a Linux driver for their hardware,
> well, there's nothing anyone of us can do about that.

My sincerest apologies for remembering the project incorrectly!

It was, as is apparent from your answer, about bringing Linux drivers
about for hardware that didn't have even an attempt at a Linux driver
beforehand, and I, mistakenly, remembered it as a completely different
offer.

Sorry for the confusion, and most well-deserved kudos for the success!

> Have you looked at the kernel backport group and scripts?  They do much
> of this already, automatically, backporting newer drivers to older
> kernel versions for people stuck at those releases.  I think what you
> want is already completed...

Whereas I thank you for those pointers, I now realize that I failed to
mention a few crucial details.

My "knee-jerk" comment above was based on a rather important point that
I failed to mention, namely that what I was talking about was drivers
employing closed binary blobs, obviously and naturally precluding them
from mainlining.

Based as this is upon my personal experience, even if a vendor that does
provide an out-of-tree driver would like to mainline and get rid of the
binary blob, some components of their board may preclude them from doing
so. Case in point would be HighPoint, who provides a driver for the
consumer-level board that I own, and have been rather forthcoming with
regards to listening and responding to my gripes about their driver
failing to compile or function with newer kernels, but excuse themselves
for not going full OSS by demands from sub-vendors of particular chips.

nVidia is a whole other kettle of fish with them referring to a failure
of their driver on certain laptop configurations being due to a kernel
bug, even though at least some systems, including my own, works if one
updates a number of system calls in the open part of their driver to the
"new" call.

Still, I imagine that you recommendation for the backport group and
scripts means that they actually "scan" for such changes, and I shall
contact them shortly, but I wanted to clarify what I meant, and also
apologize for my misremembering the scope of the project that I referred to.
> 
> thanks,
> 
> greg k-h

My thanks as well,

Sune Mølgaard
