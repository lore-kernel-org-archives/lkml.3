Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaH3GWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 02:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaH3GWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 02:22:52 -0400
Message-ID: <54016D9B.5070905@redhat.com>
Date: Sat, 30 Aug 2014 08:22:19 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>,
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
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
References: <1409171833-6979-1-git-send-email-ast@plumgrid.com> <1409171833-6979-3-git-send-email-ast@plumgrid.com> <5400BAB7.80001@redhat.com> <CAADnVQJbgiUK1vt_SDEG6Yee-Ht67e2M82PrHb3Kx533BOF-rg@mail.gmail.com> <5400FDA0.7000704@redhat.com> <CAMEtUuyRUujYhRsH9aUx0h7wvU1DrKRHNWZtoOYEgHVfKdCTxw@mail.gmail.com>
In-Reply-To: <CAMEtUuyRUujYhRsH9aUx0h7wvU1DrKRHNWZtoOYEgHVfKdCTxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2014 01:01 AM, Alexei Starovoitov wrote:
...
> btw, I've spent last two days writing syscall manpage :(
> What is the best way to present it for review?
> If I just attach it raw, it's unreadable... I can include a link
> to html page, but man2html produces ugly pages comparing
> to what 'man' command shows. Any nice man converters
> that generate stuff seen on man7.org ?

What about :

   man foo > bar

And then copy that into your mail client?
