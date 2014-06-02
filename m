Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaFBNZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:25:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38243 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754399AbaFBNZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:25:01 -0400
Date: Mon, 2 Jun 2014 09:24:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] split BPF out of core networking
Message-ID: <20140602092456.2114440a@gandalf.local.home>
In-Reply-To: <20140602081545.7baf4a91@lwn.net>
References: <1401692506-7796-1-git-send-email-ast@plumgrid.com>
	<20140602081545.7baf4a91@lwn.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014 08:15:45 -0500
Jonathan Corbet <corbet@lwn.net> wrote:

> On Mon,  2 Jun 2014 00:01:44 -0700
> Alexei Starovoitov <ast@plumgrid.com> wrote:
> 
> > This patch set splits BPF out of core networking into generic component
> 
> Quick, probably dumb question: if you're going to split it out, why not
> split it out entirely, into kernel/ or (perhaps better) lib/?  The
> whole point seems to be that BPF is outgrowing its networking home, so
> it seems like it might be better to make it truly generic.

I believe this is what Ingo suggested as well. If it is become generic,
it belongs in lib/

-- Steve
