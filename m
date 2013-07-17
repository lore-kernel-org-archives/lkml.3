Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab3GQUHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:07:20 -0400
Received: from science.horizon.com ([71.41.210.146]:41579 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932140Ab3GQUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:07:18 -0400
Date: 17 Jul 2013 16:07:16 -0400
Message-ID: <20130717200716.26404.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: stefano.stabellini@eu.citrix.com
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it's pretty clear that one doesn't need to be verbally abusive
> in order to stop bad code from getting into the kernel.

Actually, it *not* clear.  Without drawing fine distinctions about
the definition of "abusive", I think Linus's rants have a real purpose
at times.

One is so that *everyone* hears it, not just the immediate target of
his ire.  I really remember "don't rebase just before sending upstream"
precisely because there have been a few explosions on the subject.

It's pretty obvious that Linus tries to be entertaining when going
over the top, precisely so it's memorable.  And it works.


But the other thing is that Linux development is big business these
days, and many contributors have to justify their time to managers and
bean-counters.  It makes their lives *easier* if Linus plays "bad cop".

I remember a couple of blowups about the state of the ARM tree.  I don't
think Russell enjoyed it much, but that exchange gave him something to
wave in front of his bosses, his contributors, and his contributors'
bosses to say that the old sloppy ways had to change.

If Linus had limited himself to what was needed to make Russell
understand, it would have been all up to him to put pressure on his
contributors.  That's harder for someone without Linus' unassailable
position.

Yes, Linus put the nuclear option of not pulling the tree on the table,
but the vigor with which he expressed his opinion helped keep him from
having to *use* that option to make it clear that he was serious.  Linus
wasn't just yelling at Russell, but the entire ARM developer population,
and being loud enough that everyone heard was a goal.

It's an old military command maxim that good news should go through
channels, while bad news should come direct from the boss.  Linus'
rants serve as that kind of "bad news from the top".

As he wrote himself during the discussion:
> I've told people this before, and I'll tell it again: when I flame
> submaintainers, they should try to push the pain down. I'm not really
> asking those submaintainers to clean up all the stuff they are
> getting: I'm basically asking people to say "no", or at least push
> back a lot, and argue with the people who send you code. Tell them
> what you don't like about the code, and tell them that you can't take
> it any more.


There is definitely tension here, but I don't think it's as simple as
"you don't need to shout to stop bad code getting into the kernel."
Sometimes you *do* need to shout to make people think twice before
sending crap upstream.
