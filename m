Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbbAJNwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 08:52:54 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37632 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbbAJNwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 08:52:53 -0500
Date: Sat, 10 Jan 2015 14:52:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
Message-ID: <20150110135250.GB12218@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
 <20150109105541.GC13637@pd.tnic>
 <CAK1hOcO7QZxn2pbkYbytg6hL-M0rB+Pc4W2An4d-g3+yNTimSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK1hOcO7QZxn2pbkYbytg6hL-M0rB+Pc4W2An4d-g3+yNTimSA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 09:29:10PM +0100, Denys Vlasenko wrote:
> On Fri, Jan 9, 2015 at 11:55 AM, Borislav Petkov <bp@alien8.de> wrote:
> > Also, can you post the struct pt_regs change too so that we know where
> > this is going?
> 
> I'm concerned that posting too many patches at once
> actually lowers the chances of them being reviewed/accepted.

Yeah, especially if they touch entry_64.S :-)

> For example, this probably is the reason why they fell through last time.
> 
> Since you expressed interest in seeing them, I'm going to send
> all remaining patches to you off-list. Thanks.

Thanks, I'll take a look.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
