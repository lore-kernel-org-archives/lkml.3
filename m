Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978AbaHZICl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:02:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35238 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHZICg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:02:36 -0400
Date: Tue, 26 Aug 2014 10:02:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 net-next 4/6] bpf: enable bpf syscall on x64 and i386
Message-ID: <20140826080231.GA20565@gmail.com>
References: <1409014858-1410-1-git-send-email-ast@plumgrid.com>
 <1409014858-1410-5-git-send-email-ast@plumgrid.com>
 <20140825205201.10ac5ee3@uryu.home.lan>
 <CAMEtUuxicvHsEQ59CeG2kmLW0b4TQ9ExfDkKo2kktH-t8x5tBg@mail.gmail.com>
 <20140826074655.GB19799@gmail.com>
 <53FC3E9A.1020108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FC3E9A.1020108@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Borkmann <dborkman@redhat.com> wrote:

> On 08/26/2014 09:46 AM, Ingo Molnar wrote:
> >* Alexei Starovoitov <ast@plumgrid.com> wrote:
> >>On Mon, Aug 25, 2014 at 8:52 PM, Stephen Hemminger
> >><stephen@networkplumber.org> wrote:
> >>>Per discussion at Kernel Summit. Every new syscall requires
> >>>a manual page and test programs. We have had too many new syscalls
> >>>that are DOA.
> >>
> >>There is verifier testsuite that is testing eBPF verifier from userspace
> >>via bpf syscall. Also there are multiple examples and libbpf.
> >>I think test coverage for bpf syscall is quite substantial already.
> >
> >This is in tools/bpf/, right?
> 
> No, it contains a BPF JIT disasm, bpf assembler and a debugger, 
> but the last two are for the 'classic' BPF interface only. 
> There's a test suite for BPF/eBPF in general under 
> lib/test_bpf.c, but so far it tests only the current code w/o 
> eBPF verifier.
> 
> That said, I think Alexei is referring to the examples et al 
> from the bigger previous proposed patch set.

I mean, if all the testing already exists, it should be part of 
an initial submission and such.

Thanks,

	Ingo
