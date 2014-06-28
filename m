Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaF1ASP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 20:18:15 -0400
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:56055 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753593AbaF1ASO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 20:18:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3866:38
X-HE-Tag: cloud22_6453726596635
X-Filterd-Recvd-Size: 2041
Message-ID: <1403914688.9064.20.camel@joe-AO725>
Subject: Re: [PATCH RFC net-next 04/14] bpf: update MAINTAINERS entry
From: Joe Perches <joe@perches.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 27 Jun 2014 17:18:08 -0700
In-Reply-To: <1403913966-4927-5-git-send-email-ast@plumgrid.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	 <1403913966-4927-5-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS entry.

On Fri, 2014-06-27 at 17:05 -0700, Alexei Starovoitov wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -1881,6 +1881,15 @@ S:	Supported
>  F:	drivers/net/bonding/
>  F:	include/uapi/linux/if_bonding.h
>  
> +BPF

While a lot of people know what BPF is, I think it'd
be better to have something like

BPF - SOCKET FILTER (Berkeley Packet Filter like)
> +M:	Alexei Starovoitov <ast@plumgrid.com>
> +L:	netdev@vger.kernel.org
> +L:	linux-kernel@vger.kernel.org
> +S:	Supported
> +F:	kernel/bpf/
> +F:	include/uapi/linux/bpf.h
> +F:	include/linux/bpf.h


