Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3HCVtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 17:49:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54247 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab3HCVtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 17:49:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.11-rc4
Date: Sat, 03 Aug 2013 23:59:50 +0200
Message-ID: <2185529.xKyHXi1s1o@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s2dbNBbKwLd9hGaYVPL_Z6-v_S0xZpmz8cwicg1wgMr+Q@mail.gmail.com>
References: <2052880.bHfzt6NKt5@vostro.rjw.lan> <1963015.Y2AObmEn2f@vostro.rjw.lan> <CAMP44s2dbNBbKwLd9hGaYVPL_Z6-v_S0xZpmz8cwicg1wgMr+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 03, 2013 03:20:22 PM Felipe Contreras wrote:
> On Sat, Aug 3, 2013 at 6:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, August 02, 2013 08:48:09 PM Felipe Contreras wrote:
> 
> >> Yes, that's fine, either the revert, or the patch I mentioned, or
> >> something else, but something has to be done, and it was better to do
> >> it in v3.11-rc4 than in v3.11-rc5, because that change itself can
> >> cause further problems.
> >
> > A revert can be done in -rc5 just fine.  If we don't have a working fix this
> > week, I'll do the revert.
> 
> I think you are waiting for miracles. But whatever.
> 
> >> Let's do a though experiment, let's say you are right, and they can
> >> survive the 6 months it would take you to find the "perfect" solution,
> >> say in v3.13. What's wrong with having a partial solution in v3.12? If
> >> the blacklisting doesn't work properly (there's absolutely no evidence
> >> for that), then you revert it on v3.12.1.
> >>
> >> What's wrong with that approach?
> >
> > If the blacklisting leads to problems, they may not be reported in the 3.12
> > time frame, but much later.  For example because people won't realize that
> > the problems are caused by the blacklisting until much much later.  And then
> > we'll be in a spot where whatever we do will break things for someone.
> 
> The key word is *may*, you don't *know*. Why do you insist in
> committing this reification fallacy?
> 
> This threat is not real, it's theoretical.

I believe it is real.  Igor has told you that already, hasn't he?

> But let's suppose you are right, and there are issues, and those don't
> get reported in v3.12. That is actually GOOD, if people don't report
> issues, it means the issues are not that big, or not even *there*.

You don't even realize how wrong you are.  The issues that aren't visible
in testing from the start are often much *worse* than those we can see
immediately, because usually they are much more difficult to fix and they
cause much more pain overall as a result.

But I'm not sure why I'm still trying to explain things to you, because you
don't understand basic stuff.

> And no, we won't be in a spot where whatever we do will break things,
> because if the intel backlight driver works correctly, that solution
> would work for everyone. And if it doesn't, we should stay with what
> works best.
> 
> > And we had situations like that in the past, which is the source of my concern.
> > You obviously don't have that experience, or you won't be so eager to inflict
> > the blacklisting on everyone.
> >
> > Anyway, as you know, but conveniently don't mention, I asked some experienced
> > people for opinions about that.  If they agree with you, we will add the
> > blacklist.  If they don't, we won't add it.
> 
> Again, screw the users. We are stuck with broken backlight for several
> more months to come. Great.

Whatever you are thinking you will achieve this way, it doesn't work.

You seem to believe that the more you press people, the more they are likely
to do what you want.  Maybe that belief is a result of your previous
experience, but this is not helping you here.

Decisions made under pressure usually lead to wrong choices, so I avoid that
as much as I can.  As a result, the more you're pressing me, the more I'm
concerned about the drawbacks and the less convincing you are to me.

Consider this before you reply.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
