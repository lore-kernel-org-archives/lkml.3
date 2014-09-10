Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaIJITe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaIJITb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:19:31 -0400
Message-ID: <54100975.6030809@redhat.com>
Date: Wed, 10 Sep 2014 10:19:01 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 net-next 00/12] eBPF syscall, verifier, testsuite
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com>
In-Reply-To: <1410325808-3657-1-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 07:09 AM, Alexei Starovoitov wrote:
...
> As requested by Andy and others, here is the man page:
>
> BPF(2)                     Linux Programmer's Manual                    BPF(2)
...
>         In the future maps can have different types: hash, array, bloom filter,
>         radix-tree, but currently only hash type is supported:
>         enum bpf_map_type {
>            BPF_MAP_TYPE_UNSPEC,
>            BPF_MAP_TYPE_HASH,
>         };

If we mention them here in the man page, users are going to request
them, naturally. ;) So I'd just mention what we have, not what we do
not yet have. But I'm wondering how much library boiler plate only
for BPF we want to add in future, hopefully not most of what's in
Corman ... ? ;)
