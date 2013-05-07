Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3EGRU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:20:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60705 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab3EGRU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:20:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ARM: Third batch of arm-soc changes for 3.10
Date: Tue, 7 May 2013 19:19:53 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1367942534-2934003-1-git-send-email-arnd@arndb.de> <CA+55aFwMXmJ9V+3o62ELm-0NT1DaUCTvidmAhJSXzQcTMfJygA@mail.gmail.com>
In-Reply-To: <CA+55aFwMXmJ9V+3o62ELm-0NT1DaUCTvidmAhJSXzQcTMfJygA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305071919.53353.arnd@arndb.de>
X-Provags-ID: V02:K0:xzLyGrZA1Fnw/XDMrOxhrz/4dSfODVt2+5m/YQp4/ah
 JvMBevuBngmJj6V/MW7X41IZm4l3FwnrDo3bCFTHDOgwAAQRTU
 fZDC+JzSKrZls/j22Yy0ghmQK1JQy+DjafJWaWFkDwSBUsWUJo
 DJB1PexyNsK5G4iJM/mn9A62VyzPKwRl5TOcDDvrpcIN4xPMjb
 0S/HeVhE/n3pwZBuwXjQfWIxkDkzCh5JC5+ioBpeFn6I9nf/6i
 1FD7iqEWD/m5eKJ9ZfGgIpQGORQcFnEEm5VJHvZbLzFwOtGrwM
 H/8aSzGh+mLU9uVkf6i3uM0ruvp4SLh9ZSqDpoGhh9t5A/gr+D
 nGXaQvWVupNK4cjGBeAc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 May 2013, Linus Torvalds wrote:
> On Tue, May 7, 2013 at 9:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > I used a new script to create the pull requests this time, hope
> > I got it right now.
> 
> So you seem to have blasted this series out with that automated
> script, so they all got sent basically at the same timestamp, and they
> are in the wrong order in my mailbox because email isn't that ordered.

Yep, I'm very sorry about that. The old script I used had been a bit
fragile so I stopped using it for the last few merge windows
but tried something simpler this time. I had the sequence numbers
in the script but forgot to actually write them out in the subject.

> Of course, when there aren't any dependencies between pull requests,
> and the ordering doesn't matter, this isn't an issue. And *most* of
> the time you either have sent out emails by hand (and there's been
> that human delay and they arrived in the right order) or I've just
> been lucky.

I think it's the first time I made /this/ mistake, they were always
numbered in the past, and usually also had distinct time stamps.
 
> Quite frankly, I'm not going to bother guessing after the first one I
> took was clearly not the right one and gave the wrong diffstat etc, so
> they are all thrown down the toilet.
> 
> Nothing pulled.

Yes, of course. It was an obvious mistake and I would have rejected
it the same way coming from my downstream maintainers. Sorry about
bothering you with this and your lenghty reply. I hope you don't
mind the contents, and I'll follow up with the same pull requests
again, using sequence numbers.

	Arnd

