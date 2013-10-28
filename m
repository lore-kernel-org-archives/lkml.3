Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab3J1MUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:20:05 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:35293 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab3J1MUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:20:03 -0400
Date: Mon, 28 Oct 2013 13:19:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: Re: ktap inclusion in drivers/staging/?
Message-ID: <20131028121958.GA8641@gmail.com>
References: <20131024075813.GA26929@gmail.com>
 <CAGdX0WFu=sxWUckkZiUQMTxo_tOFbxX-paqU2p_5YR8NaN6gSA@mail.gmail.com>
 <20131025101511.GB3439@gmail.com>
 <CAGdX0WGrGbb-eJvS4HHg9umk7X3-vrzyrJCuhAJrfGvOriKHSQ@mail.gmail.com>
 <20131026085955.GD14237@gmail.com>
 <526E54BA.4040507@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526E54BA.4040507@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/10/26 17:59), Ingo Molnar wrote:
> > 
> > * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
> > 
> >> Thanks. An addition question I want to discuss in here is the ktap 
> >> code structure layout in first patch series, this don't need to 
> >> dig out any ktap design detail, so we can make agreement on this 
> >> point, and ease for me to prepare patch series.
> >>
> >> Do I need to prepare patchset target on staging tree or "real" 
> >> part of kernel? [...]
> > 
> > I'd suggest adding it to the core, i.e. kernel/tracing/ and 
> > kernel/trace/trace_events_filter.c in particular which includes the 
> > current filter script interpreter.
> 
> It means we'll need to put Lua compiler in the kernel...

How big is a reasonable implementation right now?

> Would you mean the bytecode should be decodable? or loaded with 
> source code in the kernel?

Loaded with the source code into the kernel - like OpenGL shader 
source code is loaded. (except that there's no bin-only exception.)

These are small scripts most of whom are (much) smaller than a 
single page.

Thanks,

	Ingo
