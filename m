Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3EIRb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:31:59 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48682 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3EIRb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:31:57 -0400
Date: Thu, 9 May 2013 10:31:30 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Dave Hansen <dave@sr71.net>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/7] Put "Kernel hacking" Kconfig menu on a diet
Message-ID: <20130509173130.GA17021@moria.home.lan>
References: <20130507204642.D010DDC1@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507204642.D010DDC1@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 01:46:42PM -0700, Dave Hansen wrote:
> Michal, I figure you're the most logical person for these to go
> through.
> 
> There is a fair amount of churn in the areas around these patches
> so I've resolved conflicts a couple of times.  For the patches that
> are almost purely code move patches, I'm doing this:
> 
> 	cat foo.patch | grep '^[-+]' | perl -pe 's/^.//' | sort | uniq -c | sort -n
> 
> and watching for any non-even numbers coming out of uniq.  This
> helps me make sure I'm not adding/removing code that I should not
> be.
> 
> The Signed-off-by's in here look funky.  I changed employers
> while working on this set, so I have signoffs from both email
> addresses.
> 
> ---
> 
> I think the "Kernel Hacking" menu has gotten a bit out of hand.  It
> is over 120 lines long on my system with everything enabled and
> options are scattered around it haphazardly.
> 
>         http://sr71.net/~dave/linux/kconfig-horror.png
> 
> Let's try to introduce some sanity.  This set takes that 120 lines
> down to 55 and makes it vastly easier to find some things.  It's a
> start.
> 
> This set stands on its own, but there is plenty of room for follow-up
> patches.  The arch-specific debug options still end up getting stuck
> in the top-level "kernel hacking" menu.  OPTIMIZE_INLINING, for
> instance, could obviously go in to the "compiler options" menu, but
> the fact that it is defined in arch/ in a separate Kconfig file keeps
> it on its own for the moment.

Yes, please!

I'm sure there's more that could be done but, like you said, it's a
start - and a significant one.

Any chance this could go in sooner than later? I spend way too much time
hunting down options in kernel hacking and I spend enough time in that
menu that I should have the damn thing memorized by now.
