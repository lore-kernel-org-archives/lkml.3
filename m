Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaGWRtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:49:00 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:64531 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbaGWRs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:48:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+mGDEPx5rCdVXzAdxR9SwQQ4ERM-Brxt4TmmncdPjzzg@mail.gmail.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
	<1405657206-12060-3-git-send-email-ast@plumgrid.com>
	<CAGXu5j+mGDEPx5rCdVXzAdxR9SwQQ4ERM-Brxt4TmmncdPjzzg@mail.gmail.com>
Date: Wed, 23 Jul 2014 10:48:55 -0700
Message-ID: <CAMEtUuzcMcYnRryykqb9LQWjnVmYi3ErMtGQ+9nyY5uS+OpwpQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 02/16] bpf: update MAINTAINERS entry
From: Alexei Starovoitov <ast@plumgrid.com>
To: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:37 AM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jul 17, 2014 at 9:19 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
>> ---
>>  MAINTAINERS |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ae8cd00215b2..32e24ff46da3 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1912,6 +1912,13 @@ S:       Supported
>>  F:     drivers/net/bonding/
>>  F:     include/uapi/linux/if_bonding.h
>>
>> +BPF (Safe dynamic programs and tools)
>
> bikeshed: I feel like this shouldn't be an acronym. Maybe instead:
>
> BERKELEY PACKET FILTER (BPF: Safe dynamic programs and tools)

pile on :)

I think eBPF is no longer acronym. 'e' stands for 'extended',
but BPF is no longer 'packet filter' only and definitely not 'berkeley'.
So I'd rather keep BPF as a magic abbreviation without spelling it out,
since full name is historic and no longer meaningful.
I've considered coming up with brand new abbreviation and full name
for this instruction set, but none looked good and all lose in comparison
to 'eBPF' name, which is concise and carries enough historical
references to explain the idea behind new ISA.
