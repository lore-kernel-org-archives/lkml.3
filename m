Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3ESMYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 08:24:35 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56980 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab3ESMYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 08:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130519110407.987B21FE2D@orac.inputplus.co.uk>
References: <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
	<1368918189923.dd7325ed@Nodemailer>
	<CAPweEDwYm6iQ1vJ_UwAC5pE-uwfnMDHR6wJ1VppW1wakmTMJGQ@mail.gmail.com>
	<20130519110407.987B21FE2D@orac.inputplus.co.uk>
Date: Sun, 19 May 2013 13:24:32 +0100
Message-ID: <CAPweEDyMx7zEzt=g+12vUdeGEwmuvR85QaZB8-vKRP-oRtN5jw@mail.gmail.com>
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
From: "luke.leighton" <luke.leighton@gmail.com>
To: Ralph Corderoy <ralph@inputplus.co.uk>
Cc: Cole Johnson <coleharrisjohnson@gmail.com>, legal@lists.gpl-violations.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 12:04 PM, Ralph Corderoy <ralph@inputplus.co.uk> wrote:
> Hi Luke,
>
>> if i choose to release all copyright code under dual licenses then
>> THAT IS MY RIGHT
>
> Sssh!  It's a Sunday morning;  hangover time for many.

 :)  *sotto voice* sorry.

> Does the LICENSING section in
> http://lxr.free-electrons.com/source/Documentation/development-process/1.Intro#L237
> help?

 it does in some ways.  it doesn't answer the specific question, "how
do i formally get my copyright announcement updated in the linux
kernel source code" yet though but it does provide some opportunity to
point out some errors and mis-... mis-somethings, i can't think of the
exact word.


252 One implication of this ownership structure is that any attempt to change
253 the licensing of the kernel is doomed to almost certain failure.

 interesting.  this statement completely and utterly misses the point.
 it assumes that "the kernel" and "the license" are directly and
irrevocably linked.  which they most certainly are not.

 the statement *should* read as follows:

 "any attempt to change the licensing on the files which make up the
linux kernel"

which, again is mis-leading - in this case very very badly - because
it implies that somehow just because *most* of the files are under one
license, therefore automatically people should not make their *own*
mind - their own free and conscious choice - to release their
contributions under alternative licenses.

 i could give half a dozen examples, here, including many books and
films, documentaries, sports achievement stories and so on, all of
which are along the lines of, "person decides to break
mould/boundaries/tradition, gets told by priests/politicians/peers
it's not possible, distance/time/resources are too far/long/small
therefore you will fail/die/get-strung-up-for-heresy, they do it
anyway, and everyone goes hurrah at the end".

 let's make another attempt:

 "we the major linux copyright holders, who wrote this documentation,
respect your decision to choose an additional license as well as the
GPLv2 to release your code under, and it is important to make it clear
that we do not seek to influence your right to choose an additional
license or licenses, one way or the other.  the key to remember is
that any files released under licenses *not* compatible with the GPLv2
*CANNOT* legally be used.   as the kernel is an aggregated work, over
time the accumulation of files under alternative licenses (those that
are compatible with the current GPLv2 license) *may* result in a
useful and useable subset of the linux kernel source files coming
about.  so our personal opinion here - which should in no way
influence your own decisions - is that you are pissing in the wind if
you think that's going to come about any time soon, and as a result of
that, we (the major linux copyright holders who wrote this
documentation) decided not to bother releasing our contributions under
any license other than the GPLv2."


253          There are
254 few practical scenarios where the agreement of all copyright holders could
255 be obtained

 one such scenario would be to have a pool of individuals and entities
that maintain a subscription to a list such that their permission -
collectively - could be sought.  if there are some individuals or
entities that have begun the process, others may be more inclined to
follow.

 but even there, it's still not the point:

255                   (or their code removed from the kernel).

 i'm intrigued that there has been no mention of rewrites.  at some
point in the future, if there happens to be all but a critical but
tiny subset under an alternative license, surely someone would step up
and do a rewrite, yes?


255
       So, in particular,
256 there is no prospect of a migration to version 3 of the GPL in the
257 foreseeable future.

 "forseeable future".  is that a good reason to not take action??
"we're stuck here therefore we should not move" - how many
civilisations have died out exactly because of that kind of thinking??

 assuming we don't blow up the planet within 50-100 years, is it
reasonable to assume that in 50-100 years - and this is a sincere
question absolutely no dis-integrity here - is it reasonable to start
the process now such that linux in 50 to 100 years time is useable
under an alternative license?

 overall i see this entire paragraph as deeply flawed, full of
assumptions, and thoroughly defeatist.  i'm surprised that the
attention to detail normally inherent in linux kernel programming
hasn't been applied across the board.

l.
