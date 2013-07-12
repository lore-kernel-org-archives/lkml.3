Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263Ab3GLR7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:59:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112Ab3GLR7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:59:16 -0400
Date: Fri, 12 Jul 2013 19:53:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between
	opening probe event files and deleting probe
Message-ID: <20130712175309.GA26140@redhat.com>
References: <20130704033347.807661713@goodmis.org> <51E0001E.3050108@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E0001E.3050108@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12, Masami Hiramatsu wrote:
>
> Steve, Oleg, could you also take a look on my additional 2 patches too?

Sorry, sorry, I was a bit busy.

Masami, I am not sure I can help, but so far I _feel_ that perhaps we
should do something else. I'll try to recheck and report on Monday.

But "Wait for disabling all running kprobe handlers" looks "obviously
fine" to me.

Oleg.

