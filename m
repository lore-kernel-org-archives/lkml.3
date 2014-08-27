Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaH0D4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 23:56:37 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:44846 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaH0D4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 23:56:35 -0400
MIME-Version: 1.0
In-Reply-To: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
References: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 26 Aug 2014 20:56:13 -0700
Message-ID: <CALCETrX2MzNxQ1ogt+Qx8iPjUe+z0gN6ZLwu9nAcZzTN+D+iYw@mail.gmail.com>
Subject: Re: [PATCH RFC v7 net-next 00/28] BPF syscall
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chema Gonzalez <chema@google.com>, Namhyung Kim <namhyung@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 26, 2014 7:29 PM, "Alexei Starovoitov" <ast@plumgrid.com> wrote:
>
> Hi Ingo, David,
>
> posting whole thing again as RFC to get feedback on syscall only.
> If syscall bpf(int cmd, union bpf_attr *attr, unsigned int size) is ok,
> I'll split them into small chunks as requested and will repost without RFC.

IMO it's much easier to review a syscall if we just look at a
specification of what it does.  The code is, in some sense, secondary.

--Andy
