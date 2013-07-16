Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab3GPStI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:49:08 -0400
Received: from 1wt.eu ([62.212.114.60]:34734 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353Ab3GPStF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:49:05 -0400
Date: Tue, 16 Jul 2013 20:48:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Mark Brown <broonie@kernel.org>,
        Takashi Iwai <tiwai@suse.de>, David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130716184848.GI15902@1wt.eu>
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu> <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz> <s5hwqoqv4oo.wl%tiwai@suse.de> <20130716165933.GU22506@sirena.org.uk> <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com> <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:29:15AM -0700, Linus Torvalds wrote:
> There have been tons of obvious patches that turned out to simply be
> wrong - often for very non-obvious reasons. Even when they are small.
> And the problems seldom get caught in early testing, often exactly
> because of this self-selecting property of testers (and test*ing* -
> when you fix a particular behavior, you tend to test the behavior
> you're trying to fix, you don't test the other cases that the patch
> wasn't about).

I can't agree more, I know it's one of my defaults. I don't count the
number of bugs I have introduced in Haproxy while fixing a bug, and I
know this and care a lot about this. Still shit happens. And I'm sure
I'm not the only one out there !

> Anyway, the point I'm making is that Q&A is limited and often even
> actively misleading ("Hey, I have three tested-by's, so it must be
> fine"), and we might actually want to have a new class of
> "non-critical patch that might be worth backporting to stable, but
> only do so after it's been in a release for some time". Because while
> it might be an "obvious" fix, maybe it's not critical enough that it
> needs to be backported _now_ - maybe it could wait a month or two, and
> get wider testing.

That's what was discussed earlier in this thread, something like not
merging into stable before current kernel is released plus maybe one
.1 stable version to ensure that we've got some bug reports. That
would mean something like "don't backport this before 3.12.1 has
been released" for example. The tag could simply be "Not-Before".

Willy

