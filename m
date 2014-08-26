Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaHZQkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:40:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63366 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaHZQkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140826080231.GA20565@gmail.com>
References: <1409014858-1410-1-git-send-email-ast@plumgrid.com>
	<1409014858-1410-5-git-send-email-ast@plumgrid.com>
	<20140825205201.10ac5ee3@uryu.home.lan>
	<CAMEtUuxicvHsEQ59CeG2kmLW0b4TQ9ExfDkKo2kktH-t8x5tBg@mail.gmail.com>
	<20140826074655.GB19799@gmail.com>
	<53FC3E9A.1020108@redhat.com>
	<20140826080231.GA20565@gmail.com>
Date: Tue, 26 Aug 2014 09:40:18 -0700
Message-ID: <CAMEtUuyBqTuqdhpmgYHJm2A-sLmmf5JzRaNG-qxTkDiJgMBNVg@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 4/6] bpf: enable bpf syscall on x64 and i386
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Borkmann <dborkman@redhat.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 1:02 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>> That said, I think Alexei is referring to the examples et al
>> from the bigger previous proposed patch set.
>
> I mean, if all the testing already exists, it should be part of
> an initial submission and such.

That's what I did. V5 set contains all examples and verifier testsuite:
https://lkml.org/lkml/2014/8/24/107
Dave asked to split it up into subsets, since it's too big too review
at once. which makes sense, so this V6 is only first part and
the plan was:
1st(this) set - introduces uapi/linux/bpf.h and BPF syscall for maps only
2nd set will extend BPF syscall with programs and verifier
3rd set will use eBPF in tracing, add samples and verifier tests
4th set will have llvm and C examples
Each set is around 6-8 patches instead of 29 in V5
