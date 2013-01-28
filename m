Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab3A1QFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:05:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab3A1QFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:05:46 -0500
Date: Mon, 28 Jan 2013 17:04:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Josh Stone <jistone@redhat.com>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [GIT PULL] uprobes: pre-filtering
Message-ID: <20130128160425.GA16586@redhat.com>
References: <20130113185916.GA25831@redhat.com> <20130124121720.GA3104@gmail.com> <20130124154018.GA8580@redhat.com> <20130124154159.GB32071@gmail.com> <20130124170612.GA14823@redhat.com> <20130125064629.GD23723@linux.vnet.ibm.com> <20130125075437.GB21036@gmail.com> <20130125161728.GA11630@redhat.com> <20130128121943.GD29865@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128121943.GD29865@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2013-01-25 17:17:28]:
>
> > This is what I am going to (try to) do, but I am not sure if this makes
> > sense...
> >
> > For the start, can't we teach 'uprobe_events' file to accept, say,
> >
> > 	'p file:0x1234 pid=1 other-opts'
>
>
> I think this would be a very good start

Good.

So will you agree with 3/4 and 3/4 ?

> The only downside, I see is we would have add and remove to change the
> filter. Something like perf record will not be able to dynamically
> change the filter parameter.

Yes, this is only the first step.

Oleg.

