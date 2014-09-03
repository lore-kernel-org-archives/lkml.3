Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbaICPrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:47:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaICPrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:47:43 -0400
Message-ID: <540737DF.1010801@redhat.com>
Date: Wed, 03 Sep 2014 17:46:39 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 net-next 2/4] net: filter: split filter.h and expose
 eBPF to user space
References: <1409714246-31054-1-git-send-email-ast@plumgrid.com> <1409714246-31054-3-git-send-email-ast@plumgrid.com>
In-Reply-To: <1409714246-31054-3-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 05:17 AM, Alexei Starovoitov wrote:
> allow user space to generate eBPF programs
>
> uapi/linux/bpf.h: eBPF instruction set definition
>
> linux/filter.h: the rest
>
> This patch only moves macro definitions, but practically it freezes existing
> eBPF instruction set, though new instructions can still be added in the future.
>
> These eBPF definitions cannot go into uapi/linux/filter.h, since the names
> may conflict with existing applications.
>
> Full eBPF ISA description is in Documentation/networking/filter.txt
>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>

Ok, given you post the remaining two RFCs later on this window as
you indicate, I have no objections:

Acked-by: Daniel Borkmann <dborkman@redhat.com>
