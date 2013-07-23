Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab3GWVL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:11:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab3GWVLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:11:25 -0400
Date: Tue, 23 Jul 2013 23:04:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2] tracing: Check f_dentry before accessing
	event_file/call in inode->i_private
Message-ID: <20130723210457.GA9095@redhat.com>
References: <20130709075519.2583.96462.stgit@mhiramat-M0-7522> <20130715181659.GA18505@redhat.com> <51E5FD33.4040604@hitachi.com> <20130717145148.GB7358@redhat.com> <51E750F4.5070200@hitachi.com> <20130718145137.GA6014@redhat.com> <51E8CCC0.7030404@hitachi.com> <20130719133327.GA21278@redhat.com> <51ED0227.6020204@hitachi.com> <20130722170442.GA27002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722170442.GA27002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Oleg Nesterov wrote:
>
> On 07/22, Masami Hiramatsu wrote:
> >
> > (2013/07/19 22:33), Oleg Nesterov wrote:
>
> > >> OK, let me confirm that, would you mean we still need 2/4 - 4/4?
> > >
> > > Yes, yes.
> >
> > And those are depends on 1/4...
>
> Not at all or I missed something (quite possible). Just 2/4 should
> not check ->flags, of course. 3/4 looks "obviously fine", 4/4 was
> already merged.

Sorry for confusion, I meant that your a232e270dcb is already merged.

4/4 is still needed. But again, _afaics_ 2-4 can go on top of the
"tracing: open/delete fixes" series I sent, only 2/4 needs the small
update.

Oleg.

