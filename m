Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbaGWRho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:37:44 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:60976 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665AbaGWRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <1405657206-12060-3-git-send-email-ast@plumgrid.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
	<1405657206-12060-3-git-send-email-ast@plumgrid.com>
Date: Wed, 23 Jul 2014 10:37:40 -0700
X-Google-Sender-Auth: NWkpvTO-HL3Ygtl_vwJps-j2Px0
Message-ID: <CAGXu5j+mGDEPx5rCdVXzAdxR9SwQQ4ERM-Brxt4TmmncdPjzzg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 02/16] bpf: update MAINTAINERS entry
From: Kees Cook <keescook@chromium.org>
To: Alexei Starovoitov <ast@plumgrid.com>
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

On Thu, Jul 17, 2014 at 9:19 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
>  MAINTAINERS |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ae8cd00215b2..32e24ff46da3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1912,6 +1912,13 @@ S:       Supported
>  F:     drivers/net/bonding/
>  F:     include/uapi/linux/if_bonding.h
>
> +BPF (Safe dynamic programs and tools)

bikeshed: I feel like this shouldn't be an acronym. Maybe instead:

BERKELEY PACKET FILTER (BPF: Safe dynamic programs and tools)

-Kees

> +M:     Alexei Starovoitov <ast@kernel.org>
> +L:     netdev@vger.kernel.org
> +L:     linux-kernel@vger.kernel.org
> +S:     Supported
> +F:     kernel/bpf/
> +
>  BROADCOM B44 10/100 ETHERNET DRIVER
>  M:     Gary Zambrano <zambrano@broadcom.com>
>  L:     netdev@vger.kernel.org
> --
> 1.7.9.5
>



-- 
Kees Cook
Chrome OS Security
