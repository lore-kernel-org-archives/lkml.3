Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3HUArh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:47:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3HUArd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:47:33 -0400
Date: Tue, 20 Aug 2013 17:49:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821004924.GA19098@kroah.com>
References: <20130820224032.GA20491@kroah.com>
 <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
 <20130820235700.GA7209@kroah.com>
 <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:41:23PM -0400, Josh Boyer wrote:
> On Tue, Aug 20, 2013 at 7:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> I like this overall.  The only thing I might change is "wait for -rc2"
> >> for patches tagged with CC: stable that go in during the merge window.
> >>  It seems those are the ones that tend to bite us.
> >
> > Maintainers can always tag their patches to have me hold off until -rc2
> > for that.
> 
> They can (not immediately sure how though?)

Some do:
	Cc: stable <stable@vger.kernel.org> # after -rc5 is out
or
	Cc: stable <stable@vger.kernel.org> # wait a -rc cycle
or
	Cc: stable <stable@vger.kernel.org> # wait a few weeks to bake

> , but they don't with the
> exception of the few that don't tag at all and send you patches in
> bundles.  I mean, that's what the huge thread about the stable trees
> that hopefully leads to a conversation at KS is about, right?

Hopefully, yes, but I don't know about that yet.

> Let me phrase this as a question instead.  Is there something we can
> do to help catch the patches that get sucked into stable during the
> merge window and then wind up causing issues and reverted/fixed after
> things settle down in the -rc releases?

Test linux-next and Linus's tree-of-the-day better.  If problems happen,
and a patch has a cc: stable@ on it, let stable@ know about it.

> I'm offering to help in whatever way you think is best.  It's your
> workflow (and sanity) that are the most impacted.  However, I share
> the pain whenever something breaks in stable through the wonderful
> place that is Fedora bugzilla so I'm looking for ways to reduce that.

Letting me know when something breaks is always good as well.  Right now
that doesn't seem to happen much, so either not much is breaking, or I'm
just not told about it, I don't know which.

thanks,

greg k-h
