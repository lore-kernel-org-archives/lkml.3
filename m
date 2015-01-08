Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbbAHOp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:45:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbbAHOp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:45:28 -0500
Date: Thu, 8 Jan 2015 15:44:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 29/30] perf tools: Add support to configure builtin
 commands inclusion
Message-ID: <20150108144436.GD16094@krava.brq.redhat.com>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
 <1420212972-21595-30-git-send-email-jolsa@kernel.org>
 <20150108071527.GE7268@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108071527.GE7268@sejong>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 04:15:27PM +0900, Namhyung Kim wrote:

SNIP

> > +perf-$(CONFIG_BUILTIN_KVM)           += builtin-kvm.o
> > +perf-$(CONFIG_BUILTIN_INJECT)        += builtin-inject.o
> > +perf-$(CONFIG_BUILTIN_MEM)           += builtin-mem.o
> > +
> > +ifeq ($(CONFIG_AUDIT),y)
> > +perf-$(CONFIG_BUILTIN_TRACE)         += builtin-trace.o
> > +endif
> > +
> > +ifeq ($(CONFIG_LIBELF),y)
> > +perf-$(CONFIG_BUILTIN_PROBE)         += builtin-probe.o
> > +endif
> >  
> >  perf-y += bench/
> 
> I guess it also needs to be changed like below?
> 
>    perf-$(CONFIG_BUILTIN_BENCH) += bench/
> 

right, thanks

jirka
