Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3BFSMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:12:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab3BFSM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:12:26 -0500
Date: Wed, 6 Feb 2013 19:10:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] uprobes/perf: pre-filtering
Message-ID: <20130206181044.GA3752@redhat.com>
References: <20130204190225.GA10840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204190225.GA10840@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Oleg Nesterov wrote:
>
> Based on git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core,
> on top of "[PATCH 0/5] uprobes: kill uprobe_trace_consumer and other cleanups"
> series.
>
> With this series 'perf record -e uprobe ...' does not install the breakpoints
> into the processes it doesn't want to probe.
>
> Probably this all needs more testing (the last patch for sure) but please
> review. I'll try to do more testing tomorrow.

Well, everything seems to work....

And nobody cares^Wobjects. I am going to add this to "oleg/misc uprobes/core"
and ask Ingo to pull.

> A special note about 1/7. It was actually needed for initial implementation,
> this version doesn't need it. Still I am sending it at least for review, it
> looks "natural" and potentially useful, and I would like to know if it is
> correct or not.

But since 1/7 wasn't reviewed, I'll drop it.




Btw, during the testing I noticed a minor problem (or problems) in tools/perf/,
I'll try to investigate...

Oleg.

