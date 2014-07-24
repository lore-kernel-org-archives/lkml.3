Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbaGXSZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:25:47 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62759 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924AbaGXSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <1405657206-12060-11-git-send-email-ast@plumgrid.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com> <1405657206-12060-11-git-send-email-ast@plumgrid.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 24 Jul 2014 11:25:23 -0700
Message-ID: <CALCETrUt1yLXTt5pDZJd0s4s+4dhs0LB7tbJYd6p1+EbdNWw7w@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 10/16] bpf: add eBPF verifier
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 9:20 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> Safety of eBPF programs is statically determined by the verifier, which detects:
> - loops
> - out of range jumps
> - unreachable instructions
> - invalid instructions
> - uninitialized register access
> - uninitialized stack access
> - misaligned stack access
> - out of range stack access
> - invalid calling convention

Is there something that documents exactly what conditions an eBPF
program must satisfy in order to be considered valid?

--Andy
