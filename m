Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbbAIU3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:29:32 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:38413 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbAIU3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:29:31 -0500
MIME-Version: 1.0
In-Reply-To: <20150109105541.GC13637@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com> <20150109105541.GC13637@pd.tnic>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 9 Jan 2015 21:29:10 +0100
Message-ID: <CAK1hOcO7QZxn2pbkYbytg6hL-M0rB+Pc4W2An4d-g3+yNTimSA@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 11:55 AM, Borislav Petkov <bp@alien8.de> wrote:
> Also, can you post the struct pt_regs change too so that we know where
> this is going?

I'm concerned that posting too many patches at once
actually lowers the chances of them being reviewed/accepted.

For example, this probably is the reason why they fell through last time.

Since you expressed interest in seeing them, I'm going to send
all remaining patches to you off-list. Thanks.
-- 
vda
