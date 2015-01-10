Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbbAJWfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:35:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52975 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbbAJWfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:35:22 -0500
Date: Sat, 10 Jan 2015 23:35:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/4] x86: ia32entry.S: fix wrong symbolic constant usage:
 R11->ARGOFFSET
Message-ID: <20150110223519.GI12218@pd.tnic>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
 <1420927210-19738-3-git-send-email-dvlasenk@redhat.com>
 <CALCETrWsT75a1Mh61BCEO41CAEz1SWJTuVjkRP=60kr=21T3OQ@mail.gmail.com>
 <CA+55aFwTJHOtMh7CMctVojO+4iy-s1UsoLD6tVukeEhdAPM44A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwTJHOtMh7CMctVojO+4iy-s1UsoLD6tVukeEhdAPM44A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 02:27:06PM -0800, Linus Torvalds wrote:
> I I do actually agree with you taking the fixes (and maybe you should
> *entirely* take ownership of all the entry_64.S changes, so that there
> is no "other side" to conflict with at all!). I just wanted to point
> out the actual effects from a conflict standpoint.

Haha, Linus just made you maintainer of entry_64.S :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
