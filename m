Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3GMMHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 08:07:19 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:54476 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751555Ab3GMMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 08:07:17 -0400
Date: Sat, 13 Jul 2013 14:07:13 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.11-rc1
Message-ID: <20130713120713.GG14258@spo001.leaseweb.com>
References: <20130711203424.GE14258@spo001.leaseweb.com> <20130712162241.08c8dd775abd0d6792b4927b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712162241.08c8dd775abd0d6792b4927b@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> On Thu, 11 Jul 2013 22:34:24 +0200 Wim Van Sebroeck <wim@iguana.be> wrote:
> >
> > Please pull from 'master' branch of
> > 	git://www.linux-watchdog.org/linux-watchdog.git
> 
> This was all rebased in the last day from what has been in linux-next for
> some time.  All the patches are the same, so the rebase achieved nothing
> positive at all.  Please don't do this (see I am still much nicer than
> Linus :-)).  Just submit what you have in linux-next which has already
> been tested (presumably) and Linus can fix up any conflicts (in this case
> there were nothing significant anyway).

<sigh on><sigh off>.
My linux-next patches are in:
git://www.linux-watchdog.org/linux-watchdog-next.git
which is a different tree then:
git://www.linux-watchdog.org/linux-watchdog.git .

So my development process is the following:
After the merge window is closed I start adding patch to the
linux-watchdog-next.git tree. All patches go into the linux-watchdog-next tree
so that they also become part of the linux-next tree. This to make sure that
patches are normally tested. Once in a while I receive a bugfix which is also
applied to linux-watchdog-next. After having been a couple of days in
linux-watchdog-next, I also apply this patch to the linux-watchdog tree and ask
Linus to pull the fix from the linux-watchdog tree (and thus not from the
linux-watchdog-next tree). Near the end of the merge window I sync up the
linux-watchdog tree to the mainline linux tree and add the patches (that have
been in linux-next) to this tree. Reason I do this is because there are
also other watchdog patches that come in via the arch or mfd trees. I can then
catch small merge conflicts so that Linus has no problem with this. At the same
time I clean-up my linux-watchdog-next tree so that it is clean again for the
development towards the next merge window again.

I'm sure that everything can be done in one tree with different branches, but
I am used to do this for years now.

So to answer on what you wrote:
1) it was not a rebase in the linux-watchdog-next tree but a sync + the addition
of the patches from development into the linux-watchdog tree so that I can do
a so clean possible handover to Linus for the watchdog patches.
2) If I have to submit what is in Linux-next, why don't we then make the merge
only one day where Linus just pulls linux-next ? We don't allow any patches
for the nex merge window in linux-next when the merge window opens so
technically this is possible. But I'm sure you also understand that everything
what is in linux-next is not always something what Linus want's to pull. So me
sticking to 2 different trees is still in line with the phylosofy that Linus
decides on which trees he wants to pull and that we test as much as possible by
using linux-next.
3) I personnaly think you are doing a great job for the complete community and
linux kernel development, but I think you started to focus on merge details to
much so that you forgot the overal system that we created. If our Basic system
(testing in linux-next and then handing over the tested stuff to Linus so that
he still has the final decision as the overall maintainer) however has changed
then I have to apologize and then my development cycle is indeed wrong. If the
basic system is still the same then my way or working is probably not the best
but still the easiest for me, and still correct.

> Also, you might like to consider using "git request-pull" to generate a
> starting place for your pull request rather than sending all the commit
> messages and the diff in line.

Nice! Learned something new here. Thanks!

Kind regards,
Wim.

