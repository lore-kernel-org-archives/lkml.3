Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbaGPTOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:14:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760558AbaGPTO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:14:27 -0400
Date: Wed, 16 Jul 2014 21:12:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] tracing: change apply_subsystem_event_filter()
	paths to check file->system == dir
Message-ID: <20140716191248.GA6854@redhat.com>
References: <20140715184753.GA20470@redhat.com> <20140715184829.GA20516@redhat.com> <20140716143219.4fa2b72e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716143219.4fa2b72e@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16, Steven Rostedt wrote:
>
> On Tue, 15 Jul 2014 20:48:29 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > filter_free_subsystem_preds(), filter_free_subsystem_filters() and
> > replace_system_preds() can simply check file->system->subsystem and
> > avoid strcmp(call->class->system).
> >
> > Better yet, we can pass "struct ftrace_subsystem_dir *dir" instead of
> > event_subsystem and just check file->system == dir.
> >
> > Thanks to Namhyung Kim who pointed out that replace_system_preds() can
> > be changed too.
>
> What? No thanks to me for suggesting the file->system == dir idea?
>
> /me pouts like a baby

OOPS, sorry, Iactually forgot to add "as suggested by" ;)

But, otoh... who cares about rostedt when it comes to tracing area?

Oleg.

