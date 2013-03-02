Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3CBSKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 13:10:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39918 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3CBSKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 13:10:38 -0500
Date: Sat, 2 Mar 2013 19:10:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, Arnd <arnd@arndb.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
Message-ID: <20130302181025.GA15498@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 08:28:56AM -0800, Linus Torvalds wrote:
> On Sat, Mar 2, 2013 at 2:22 AM, James Hogan <james.hogan@imgtec.com> wrote:
> >
> > Okay, I've rebased the arch/metag tree onto mainline to make all the
> > back-merges unnecessary and applied those simple fixes into "Build
> > infrastructure" and "Various other headers" commits (additionally
> > trivially removing ARCH_NO_VIRT_TO_BUS which is also now unnecessary).
> 
> No, this is *exactly* the wrong thing to do.

<snip good practices and musings about maintainer trees>

Hmm, so this comes up almost everytime new maintainers send stuff (and
when seasoned maintainers forget :)), maybe we should hold it down
somewhere in Documentation/ for future reference?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
