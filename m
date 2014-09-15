Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaIOP5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:57:39 -0400
Received: from bes.se.axis.com ([195.60.68.10]:36527 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbaIOP5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:57:38 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 11:57:38 EDT
Date: Mon, 15 Sep 2014 17:49:49 +0200
Message-Id: <201409151549.s8FFnner005703@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: linux@roeck-us.net
CC: jespern@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, edgar.iglesias@gmail.com
In-reply-to: <20140915145203.GK4659@axis.com> (message from Jesper Nilsson on
	Mon, 15 Sep 2014 16:52:03 +0200)
Subject: Re: Status of 'cris' architecture support in Linux kernel
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following up on Jesper's reply...

> From: Jesper Nilsson <jespern@axis.com>
> Date: Mon, 15 Sep 2014 16:52:03 +0200

> > Toolchain
> > 
> > Creating a toolchain from upstream sources required a number of patches.

> > - gcc 4.7.4
> >   Requires a backport from upstream gcc to compile.
> >   Later versions of gcc (4.8.3, 4.9.1) fail with internal compiler errors
> >   even after patching.

This sounds like PR61737 (fixed; use 4.9.2 not released yet),
but of course with the above sentence serving as your complete
bug-report (or did I miss one?) that will only be a guess.

> I'm using gcc 4.7.2, but of course, that is a locally built
> version that might have patches not upstream
> (although I doubt it knowing the gcc CRIS maintainer :-)

(oops. *blush*)  The TLS stuff is unfortunately not upstreamed
at this time.  Unimportant when building the kernel, but
mentioned for completeness.  (The bad excuse is that I
originally awaited pre-v32 kernels to get the corresponding TLS
support so I wouldn't have to do ugly pre-vs.-v32 conditionals,
then the whole thing lost priority, and now I avoid adding code
I can't/won't test - the glibc end isn't upstreamed either.
Sorry.)

brgds, H-P
