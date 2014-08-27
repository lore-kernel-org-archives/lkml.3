Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbaH0BpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:45:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38668 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaH0BpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:45:07 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUaZ8w92g96SmFEZDE0Jr+0Moeo+S24-TyW8crrK5reSg@mail.gmail.com>
References: <CALCETrUaZ8w92g96SmFEZDE0Jr+0Moeo+S24-TyW8crrK5reSg@mail.gmail.com>
Date: Tue, 26 Aug 2014 18:45:06 -0700
Message-ID: <CAMEtUuwZPn+hY6BTz6jj+TJHFWjhyOVFZGj_Brw9DE9YjiTbrQ@mail.gmail.com>
Subject: Re: Post-merge-window ping (Re: [PATCH v4 0/5] x86: two-phase syscall
 tracing and seccomp fastpath)
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 6:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Jul 28, 2014 at 8:38 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> This applies to:
>> git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git seccomp-fastpath
>>
>> Gitweb:
>> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=seccomp/fastpath
>
> Hi all-
>
> AFAIK the only thing that's changed since I submitted it is that the
> 3.17 merge window is closed.  Kees rebased the tree this applies to,
> but I think the patches all still apply.  What, if anything, do I need
> to do to help this along for 3.18?
>

+1
I think it's not just an optimization of seccomp path, but I feel
in the future it will help me speedup syscall tracepoints which
are quite slow right now comparing to kprobes...
