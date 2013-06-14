Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3FNRGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:06:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3FNRGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:06:43 -0400
Date: Fri, 14 Jun 2013 19:02:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ftrace multibuffer && rcu (Was: tracing/uprobes: Support
	ftrace_event_file base multibuffer)
Message-ID: <20130614170224.GA23890@redhat.com>
References: <51BA7578.4080108@huawei.com> <20130614144442.GA1943@redhat.com> <20130614160456.GA14726@redhat.com> <1371227208.9844.333.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371227208.9844.333.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Steven Rostedt wrote:
>
> On Fri, 2013-06-14 at 18:04 +0200, Oleg Nesterov wrote:
> >
> > But the main problem is, synchronize_sched() is slow and it is called
> > under the global event_mutex.
>
> But is that really an issue? event_mutex is used to add or remove
> events, and this happens only when we load or unload a module, or add or
> remove a probe. These are mostly user operations that take a relatively
> long time to complete (but not relative to humans).

OK, please ignore then.

Oleg.

