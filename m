Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaBEJOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:14:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaBEJOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:14:48 -0500
Date: Wed, 5 Feb 2014 10:14:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 04/22] perf tools: Add --list report option
Message-ID: <20140205091428.GC1201@krava.brq.redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
 <1391377150-23920-5-git-send-email-jolsa@redhat.com>
 <87iosu1g5v.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iosu1g5v.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:50:36AM +0900, Namhyung Kim wrote:
> On Sun,  2 Feb 2014 22:38:52 +0100, Jiri Olsa wrote:
> > Adding --list report option to display entries sequentialy:
> >
> >   $ perf report --list --stdio
> >   ...
> >        0.00%       13151.543527 +000000.000000       ls  [kernel.kallsyms]  [k] native_write_msr_safe
> >        0.00%       13151.543530 +000000.000003       ls  [kernel.kallsyms]  [k] native_write_msr_safe
> >        0.00%       13151.543532 +000000.000005       ls  [kernel.kallsyms]  [k] native_write_msr_safe
> >        0.00%       13151.543534 +000000.000007       ls  [kernel.kallsyms]  [k] native_write_msr_safe
> >        0.05%       13151.543536 +000000.000009       ls  [kernel.kallsyms]  [k] native_write_msr_safe
> >        0.92%       13151.543538 +000000.000011       ls  [kernel.kallsyms]  [k] perf_event_comm
> >       14.52%       13151.543560 +000000.000033       ls  [kernel.kallsyms]  [k] uprobe_mmap
> >       30.10%       13151.543878 +000000.000351       ls  ld-2.17.so         [.] _dl_setup_hash
> >       29.30%       13151.544531 +000000.001004       ls  ls                 [.] gobble_file.constprop.49
> >       25.09%       13151.545613 +000000.002086       ls  [kernel.kallsyms]  [k] _cond_resched
> 
> Hmm.. it seems what this --list option does is very similar to
> what "perf script -f time,comm,dso,sym,ip" tries to do, no?

correct.. it's just byproduct which I need for lock browser
I'm working on.. but this basic output seemed usefull and
actually missing from report portfolio ;-)

but as I said, it's a byproduct and I can leave it for
the lock change patchset

thanks,
jirka
