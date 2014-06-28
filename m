Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaF1F7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 01:59:45 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42505 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaF1F7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 01:59:43 -0400
MIME-Version: 1.0
In-Reply-To: <1403914688.9064.20.camel@joe-AO725>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-5-git-send-email-ast@plumgrid.com>
	<1403914688.9064.20.camel@joe-AO725>
Date: Fri, 27 Jun 2014 22:59:42 -0700
Message-ID: <CAMEtUuyUYD-=ymo8HYCStUwnQbWB21qnste-xgS4+Q_+uEV9_g@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 04/14] bpf: update MAINTAINERS entry
From: Alexei Starovoitov <ast@plumgrid.com>
To: Joe Perches <joe@perches.com>
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
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 5:18 PM, Joe Perches <joe@perches.com> wrote:
> Add MAINTAINERS entry.
>
> On Fri, 2014-06-27 at 17:05 -0700, Alexei Starovoitov wrote:
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -1881,6 +1881,15 @@ S:     Supported
>>  F:   drivers/net/bonding/
>>  F:   include/uapi/linux/if_bonding.h
>>
>> +BPF
>
> While a lot of people know what BPF is, I think it'd
> be better to have something like
>
> BPF - SOCKET FILTER (Berkeley Packet Filter like)

BPF is indeed succinct, but 'socket filter' suffix would be misleading,
since it's way more than just socket filtering.
May be: "BPF (Safe dynamic programs and tools)"
since 'perf' will become 'stap/dtrace'-like based on this infra.
