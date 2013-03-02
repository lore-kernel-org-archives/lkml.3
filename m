Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3CBTHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 14:07:20 -0500
Received: from multi.imgtec.com ([194.200.65.239]:60408 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab3CBTHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 14:07:19 -0500
Message-ID: <51324D92.5090100@imgtec.com>
Date: Sat, 2 Mar 2013 19:05:54 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
References: <5130DD94.2060408@imgtec.com> <CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com> <5130F978.9040604@imgtec.com> <5131D2F0.2010705@imgtec.com> <CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com>
In-Reply-To: <CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_02_19_07_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/13 16:28, Linus Torvalds wrote:
> You are the
> architecture maintainer, and your job is not integration, it's to make
> sure that *your* work is as stable and unsurprising as possible.

Right, make sense. This is what it comes down to.

> See why I hate rebasing and back-merges so much?

Yes. To be clear I wasn't keen on the idea of rebasing the tree (which
is why I had fixes applied on top of it instead of keeping rebasing it),
but I was missing your point about not being my job to do integration so
I wasn't sure what other alternative to back-merges there was.

> Right now, I think your best option is to rebase just your own commits
> on top of v3.8, and then ask me to pull the result, with explanations
> of what the conflicts will be. And while I much prefer explanations
> (and also a general over-view, just so that I can put it in the commit
> message), I actually even prefer unexplained merge conflicts that I
> have to resolve over the "I did a back-merge at some random point
> because I was trying to be helpful, or because I wanted to use a new
> and untested feature that isn't even in a release kernel yet".

Okay,

> But I do *not* take new trees that do bad things. If I take a new
> architecture, I want to feel like I'm not just getting the
> architecture, but I'm also getting a maintainer that knows about
> keeping his history clean and not mixing with the independent work
> other people did, or messing up other people by rebasing public
> commits etc.

I actually take slightly obsessive pride in trying to have a clean
history where every commit works so that bisection doesn't break, which
is probably the problem here. I was trying too hard to make it just work
when everything is integrated (e.g. trying to make linux-next just work,
which now seems like a conflicting goal) instead of helping you do that.
Obviously I'll have to do better.

Thanks
James

