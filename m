Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaIZFLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:11:35 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52978 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaIZFLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140926.004024.1179261758092351350.davem@davemloft.net>
References: <1411344411-3824-1-git-send-email-ast@plumgrid.com>
	<1411344411-3824-11-git-send-email-ast@plumgrid.com>
	<20140926.004024.1179261758092351350.davem@davemloft.net>
Date: Thu, 25 Sep 2014 22:11:30 -0700
Message-ID: <CAMEtUuzMepq5KkEc0APbMXpY-tZnv0U0xGMFzhc_uT4YeJETtw@mail.gmail.com>
Subject: Re: [PATCH v14 net-next 10/11] bpf: verifier (add verifier core)
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
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

On Thu, Sep 25, 2014 at 9:40 PM, David Miller <davem@davemloft.net> wrote:
> From: Alexei Starovoitov <ast@plumgrid.com>
> Date: Sun, 21 Sep 2014 17:06:50 -0700
>
>> +#define _(OP) ({ int ret = (OP); if (ret < 0) return ret; })
>
> Please do not hide program control flow inside of a macro.

ok.
I'm pretty sure it will be less readable, but I'll get rid off it.
I'm assuming you considered my arguments about it here:
https://lkml.org/lkml/2014/7/2/656
No problem. It's a minor thing.
