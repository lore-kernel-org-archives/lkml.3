Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3HUFiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:38:54 -0400
Received: from 1wt.eu ([62.212.114.60]:35463 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab3HUFix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:38:53 -0400
Date: Wed, 21 Aug 2013 07:38:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821053836.GF16424@1wt.eu>
References: <20130820224032.GA20491@kroah.com> <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com> <20130820235700.GA7209@kroah.com> <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com> <20130821004924.GA19098@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821004924.GA19098@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 05:49:24PM -0700, Greg KH wrote:
> On Tue, Aug 20, 2013 at 08:41:23PM -0400, Josh Boyer wrote:
> > On Tue, Aug 20, 2013 at 7:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >> I like this overall.  The only thing I might change is "wait for -rc2"
> > >> for patches tagged with CC: stable that go in during the merge window.
> > >>  It seems those are the ones that tend to bite us.
> > >
> > > Maintainers can always tag their patches to have me hold off until -rc2
> > > for that.
> > 
> > They can (not immediately sure how though?)
> 
> Some do:
> 	Cc: stable <stable@vger.kernel.org> # after -rc5 is out
> or
> 	Cc: stable <stable@vger.kernel.org> # wait a -rc cycle
> or
> 	Cc: stable <stable@vger.kernel.org> # wait a few weeks to bake

That's where I think that the default one (with no indication) should
be the higher delay. If the author has no clue about the emergency of
his patch, who else can guess for him ?

It's too optimistic to consider that some code authors will be
realist about the impacts of their code. We all create bugs and
regressions everywhere because we're sure about what we do, until
someone says "hey dude you broke this". So if we expect authors to
say "look, I managed to get this merged into mainline but I'm still
not sure about the risks", I suspect only a small fraction of the
patches will be tagged this way. But I may be wrong, after all it
already works well with -net.

Willy

