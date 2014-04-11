Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaDKKdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbaDKKdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:33:41 -0400
Date: Fri, 11 Apr 2014 12:33:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/3] perf bench: Set more defaults in the 'numa' suite
Message-ID: <20140411103338.GB1107@krava.brq.redhat.com>
References: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
 <1395964219-22173-2-git-send-email-artagnon@gmail.com>
 <20140409121618.GA2556@krava.brq.redhat.com>
 <CALkWK0=xjT7tAxGfzQ+6+=sjbtpu865_FKr8ai4tsLVg=CYdGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0=xjT7tAxGfzQ+6+=sjbtpu865_FKr8ai4tsLVg=CYdGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 08:31:32PM -0400, Ramkumar Ramachandra wrote:
> Jiri Olsa wrote:
> >  ###
> >  # 1 task will execute (on 1 nodes, 4 CPUs):
> >  #         -1x     1MB global  shared mem operations
> >  #         -1x     0MB process shared mem operations
> >  #         -1x     0MB thread  local  mem operations
> >  ###
> > ...
> >
> >
> > '-1x' does not seem right/intentional for default case
> 
> As you can see from print_summary(), -1 is the value of nr_loops. In
> init_params(), Ingo set nr_loops is set to -1 in his original patch --
> I haven't touched that. So, unless I'm missing something, it's quite
> an apt default case.

fair enough ;-) ok

thanks,
jirka
