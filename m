Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaF3N2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:28:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:18304 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750771AbaF3N2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:28:46 -0400
Date: Mon, 30 Jun 2014 09:28:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] tracing/uprobes fixes
Message-ID: <20140630092844.7b83e8de@gandalf.local.home>
In-Reply-To: <20140627170116.GA18298@redhat.com>
References: <20140627170116.GA18298@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 19:01:16 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Hello,
> 
> It took me several hours to realize that the strange bug I hit was
> caused by the change I have nacked in the past ;)
> 
> But it appears that I should take the blame. I was cc'ed, but I missed
> that email or forgot to reply, so another attempt to push this "trivial"
> change was successful.
> 
> I think that 1/4 should go to stable. 2-4 are "while at it" fixes.
> 
> Oleg.
> 
>  kernel/events/uprobes.c     |    6 ++--
>  kernel/trace/trace_uprobe.c |   46 +++++++++++++++++++++++++-----------------
>  2 files changed, 30 insertions(+), 22 deletions(-)

I pulled these into my urgent branch and I'm testing them now.

Thanks Oleg!

-- Steve
