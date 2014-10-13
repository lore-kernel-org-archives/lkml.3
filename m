Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaJMRWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:22:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbaJMRWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:22:21 -0400
Message-ID: <543C0A2D.5040908@redhat.com>
Date: Mon, 13 Oct 2014 19:21:49 +0200
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
References: <1409714246-31054-1-git-send-email-ast@plumgrid.com> <1409714246-31054-3-git-send-email-ast@plumgrid.com> <540737DF.1010801@redhat.com>
In-Reply-To: <540737DF.1010801@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 05:46 PM, Daniel Borkmann wrote:
...
> Ok, given you post the remaining two RFCs later on this window as
> you indicate, I have no objections:
>
> Acked-by: Daniel Borkmann <dborkman@redhat.com>

Ping, Alexei, are you still sending the patch for bpf_common.h or
do you want me to take care of this?

Cheers,
Daniel
