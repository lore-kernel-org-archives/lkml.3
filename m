Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982AbaH0TgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:36:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964959AbaH0TgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:36:01 -0400
Message-ID: <53FE3304.9040305@redhat.com>
Date: Wed, 27 Aug 2014 21:35:32 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>
CC: Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
Subject: Re: [PATCH RFC v7 net-next 00/28] BPF syscall
References: <1409106582-10095-1-git-send-email-ast@plumgrid.com> <CALCETrX2MzNxQ1ogt+Qx8iPjUe+z0gN6ZLwu9nAcZzTN+D+iYw@mail.gmail.com> <CAMEtUuwYqJVUuZxPBKy57NonWF+X_5vkNx4uSEx_d=-xBka1Kg@mail.gmail.com> <CALCETrWs9GRufGKxAoV628bh1f3HObkxNQuW3tYRt2rFwNAbxA@mail.gmail.com> <CAMEtUuw1n1HzAeyKFj9=nGq7RKZq7TADS-6M_BkHbTsWJ_Gm-Q@mail.gmail.com> <CALCETrXAfZJTsF2nPFw55rHkfbNXKQuF8Frnq3e1wHEoGxLM4w@mail.gmail.com> <20140827121801.3bfd916e@urahara>
In-Reply-To: <20140827121801.3bfd916e@urahara>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 09:18 PM, Stephen Hemminger wrote:
> Something in man page format similar to FreeBSD man page:
>   http://www.freebsd.org/cgi/man.cgi?bpf(4)
>
> would be more readable and reviewable.

I think at some point, we could perhaps do a section 7 page
with a general overview of the engine and where it can be
applied, and let the syscall page partially refer to it so
that it doesn't get too long. So far, we tried to squeeze
everything into Documentation/networking/filter.txt, and that
itself is quite long already.
