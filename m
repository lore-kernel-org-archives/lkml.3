Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3CBTTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 14:19:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45286 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab3CBTTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 14:19:31 -0500
Date: Sat, 2 Mar 2013 20:19:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, Arnd <arnd@arndb.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
Message-ID: <20130302191918.GC16218@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Hogan <james.hogan@imgtec.com>, Arnd <arnd@arndb.de>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <5130DD94.2060408@imgtec.com>
 <CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
 <5130F978.9040604@imgtec.com>
 <5131D2F0.2010705@imgtec.com>
 <CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com>
 <20130302181025.GA15498@pd.tnic>
 <CA+55aFyTg5oxT-Sx65CF3RJaK8Ejyf7RvPSrTWv-bNV0Um-k+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFyTg5oxT-Sx65CF3RJaK8Ejyf7RvPSrTWv-bNV0Um-k+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 10:40:16AM -0800, Linus Torvalds wrote:
> > Hmm, so this comes up almost everytime new maintainers send stuff (and
> > when seasoned maintainers forget :)), maybe we should hold it down
> > somewhere in Documentation/ for future reference?
> 
> If somebody wants to edit it a bit for readability (and maybe try to
> gather previous rants of mine), I'll happily take the patch.

I have a faint suspicion who "somebody" might be. :)

> And we should probably add some commentary from submaintainers too.
> They often have their own issues. Some of them are the same "dammit, I
> relied on a rebased tree of another", but I bet there are cross-merge
> issues *within* submaintainerships too (eg there are some trees that I
> pull that have their internal topic branches with multiple maintainers
> where they merge between them, and some of them sometimes seem to have
> a bit too much merging going on).

I'll scribble something up.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
