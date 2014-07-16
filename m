Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaGPT7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:59:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:27587 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750919AbaGPT7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:59:49 -0400
Date: Wed, 16 Jul 2014 15:59:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] tracing: change apply_subsystem_event_filter()
 paths to check file->system == dir
Message-ID: <20140716155945.081dceb7@gandalf.local.home>
In-Reply-To: <20140716191248.GA6854@redhat.com>
References: <20140715184753.GA20470@redhat.com>
	<20140715184829.GA20516@redhat.com>
	<20140716143219.4fa2b72e@gandalf.local.home>
	<20140716191248.GA6854@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 21:12:48 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 07/16, Steven Rostedt wrote:
> >
> > On Tue, 15 Jul 2014 20:48:29 +0200
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > filter_free_subsystem_preds(), filter_free_subsystem_filters() and
> > > replace_system_preds() can simply check file->system->subsystem and
> > > avoid strcmp(call->class->system).
> > >
> > > Better yet, we can pass "struct ftrace_subsystem_dir *dir" instead of
> > > event_subsystem and just check file->system == dir.
> > >
> > > Thanks to Namhyung Kim who pointed out that replace_system_preds() can
> > > be changed too.
> >
> > What? No thanks to me for suggesting the file->system == dir idea?
> >
> > /me pouts like a baby
> 
> OOPS, sorry, Iactually forgot to add "as suggested by" ;)
> 
> But, otoh... who cares about rostedt when it comes to tracing area?
> 

As Paul McKenney would say...


 ;-) ;-) ;-)


-- Steve
