Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaIJBmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:42:45 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57682 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaIJBmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:42:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140909.103059.1330265085939107782.davem@davemloft.net>
References: <1409894238-9055-1-git-send-email-ast@plumgrid.com>
	<20140909.103059.1330265085939107782.davem@davemloft.net>
Date: Tue, 9 Sep 2014 18:42:41 -0700
Message-ID: <CAMEtUuzObhWe7xvD5CMQCzAZ4weOdi4HZH+51WE4Fhdj4q6d=w@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 0/2] load imm64 insn and uapi/linux/bpf.h
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 10:30 AM, David Miller <davem@davemloft.net> wrote:
>
> You kept saying "LLVM is the user" but that's a bullshit argument
> because you aren't including the patches necessary to actually
> propagate native eBPF programs into the kernel.
>
> That's what, 1 or 2 patches, right?  Which is not an unreasonable
> request.

I just don't see how I could do that in 2 patches.
In V8 series the first user was appearing in patch 22 out of 28.
Last two days I spent solely hacking the series to move it sooner.
Today the first user is still in patch 15.
Will try to shorten them even more.
So blame it on my skills and not my attitude.

> Anyways, I'm just extremely frustrated with how you operate and work,
> you push things way too hard.  I hate to say this, but you are the
> kind of submitter who gets his way by being persistent rather than
> making well formed pleasant submissions that are easy to integrate.

Understood. Will try to make patches shorter and hopefully
more pleasant. I think 'being persistent' is mandatory here :)
