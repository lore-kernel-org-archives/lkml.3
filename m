Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3JYLen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:34:43 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:37645 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab3JYLel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:34:41 -0400
Date: Fri, 25 Oct 2013 13:34:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jovi.zhangwei@huawei.com,
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
Subject: Re: ktap inclusion in drivers/staging/?
Message-ID: <20131025113436.GA6125@gmail.com>
References: <20131024075813.GA26929@gmail.com>
 <CAOJsxLHBZgUB1dSyF=qx2jfMHGs2sfgO5AEgV9h1KSuxejoEXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLHBZgUB1dSyF=qx2jfMHGs2sfgO5AEgV9h1KSuxejoEXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Oct 24, 2013 at 9:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >  - In a similar fashion, it would be nice to see it integrated with
> >    'perf probe' or 'perf ktap', so that users can create probes from
> >    a single place, with coherent syntax and integrated analysis
> >    capabilities. I.e. there's no reason to not make this a
> >    relatively pain-less yet very useful transition.
> 
> I really hope we don't end up wit 'perf ktap'. As a user, I really 
> don't want to know what the underlying mechanism is nor learn the 
> command line idiosyncrasies, I just want to 'perf trace'.

Agreed.

Thanks,

	Ingo
