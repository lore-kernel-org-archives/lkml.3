Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524AbaFCUgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:36:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbaFCUga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:36:30 -0400
Message-ID: <538E319B.3000606@redhat.com>
Date: Tue, 03 Jun 2014 22:35:39 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/2] split BPF out of core networking
References: <1401692506-7796-1-git-send-email-ast@plumgrid.com> <538C3C94.3080206@redhat.com> <CAMEtUuzkjZCsReWH9cZs8AU0mJjZH9YOdCBTWusxe6-NZ9mQ=g@mail.gmail.com> <538CAEA6.4060307@redhat.com> <CAMEtUuwxJOgYgFjg9deQZOffeg6-JUGZXZ1Rj344eQmriQ0F0Q@mail.gmail.com> <538D8DAA.7090105@redhat.com> <CAMEtUuw8uyCGeLeUB0PXm5cCpqcsjPLZt6y9FcKjapbVPjWTuw@mail.gmail.com>
In-Reply-To: <CAMEtUuw8uyCGeLeUB0PXm5cCpqcsjPLZt6y9FcKjapbVPjWTuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 05:44 PM, Alexei Starovoitov wrote:
...
> All of your points are valid. They are right questions to ask. I just
> don't see why you're still arguing about first step of filter.c split,
> whereas your concerns are about steps 2, 3, 4.

Fair enough, lets keep them in mind though for future work. Btw,
are other files planned for kernel/bpf/ or should it instead just
simply be kernel/bpf.c?
