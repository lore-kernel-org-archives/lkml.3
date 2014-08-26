Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaHZEYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:24:37 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35155 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaHZEYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140825205201.10ac5ee3@uryu.home.lan>
References: <1409014858-1410-1-git-send-email-ast@plumgrid.com>
	<1409014858-1410-5-git-send-email-ast@plumgrid.com>
	<20140825205201.10ac5ee3@uryu.home.lan>
Date: Mon, 25 Aug 2014 21:24:34 -0700
Message-ID: <CAMEtUuxicvHsEQ59CeG2kmLW0b4TQ9ExfDkKo2kktH-t8x5tBg@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 4/6] bpf: enable bpf syscall on x64 and i386
From: Alexei Starovoitov <ast@plumgrid.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
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

On Mon, Aug 25, 2014 at 8:52 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> Per discussion at Kernel Summit. Every new syscall requires
> a manual page and test programs. We have had too many new syscalls
> that are DOA.

There is verifier testsuite that is testing eBPF verifier from userspace
via bpf syscall. Also there are multiple examples and libbpf.
I think test coverage for bpf syscall is quite substantial already.

As far as manpage I already mentioned my plan in the other thread.
I will do it when stuff lands, since writing docs in english is the most
difficult part of these patches. I already rewrote Documentation/../filter.txt
several times. Even once Kees noticed discrepancies there when
interface changed from map_id to map_fd.
To do a manpage I'll use a help from tech writer, since I want it to
be better than docs I put in Documentation/...
