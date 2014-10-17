Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaJQSWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:22:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:39371 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbaJQSWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:22:16 -0400
Date: Fri, 17 Oct 2014 15:22:08 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 8/9] perf script: Add period data column
Message-ID: <20141017182208.GA3198@kernel.org>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-9-git-send-email-jolsa@kernel.org>
 <53FDEC51.3070301@gmail.com>
 <20141017161006.GA19692@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017161006.GA19692@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 17, 2014 at 06:10:06PM +0200, Jiri Olsa escreveu:
> On Wed, Aug 27, 2014 at 08:33:53AM -0600, David Ahern wrote:
> > On 8/25/14, 8:45 AM, Jiri Olsa wrote:
> > >Adding period data column to be displayed in perf script.
> > >It's possible to get period values using -f option, like:
> > >
> > >   $ perf script -f comm,tid,time,period,ip,sym,dso
> > >           :26019 26019 52414.329088:       3707  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
> > >           :26019 26019 52414.329088:         44  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
> > >           :26019 26019 52414.329093:       1987  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
> > >           :26019 26019 52414.329093:          6  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
> > >               ls 26019 52414.329442:     537558        3407c0639c _dl_map_object_from_fd (/usr/lib64/ld-2.17.so)
> > >               ls 26019 52414.329442:       2099        3407c0639c _dl_map_object_from_fd (/usr/lib64/ld-2.17.so)
> > >               ls 26019 52414.330181:    1242100        34080917bb get_next_seq (/usr/lib64/libc-2.17.so)
> > >               ls 26019 52414.330181:       3774        34080917bb get_next_seq (/usr/lib64/libc-2.17.so)
> > >               ls 26019 52414.331427:    1083662  ffffffff810c7dc2 update_curr ([kernel.kallsyms])
> > >               ls 26019 52414.331427:        360  ffffffff810c7dc2 update_curr ([kernel.kallsyms])
> > >
> > >Cc: Andi Kleen <andi@firstfloor.org>
> > >Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> > >Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > >Cc: David Ahern <dsahern@gmail.com>
> > >Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > >Cc: Ingo Molnar <mingo@kernel.org>
> > >Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
> > >Cc: Namhyung Kim <namhyung@kernel.org>
> > >Cc: Paul Mackerras <paulus@samba.org>
> > >Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >Cc: Stephane Eranian <eranian@google.com>
> > >Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > >---
> > >  tools/perf/Documentation/perf-script.txt |  2 +-
> > >  tools/perf/builtin-script.c              | 12 +++++++++++-
> > >  2 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > Acked-by: David Ahern <dsahern@gmail.com>
> 
> Arnaldo,
> could you please pick this one and patch 9/9?
> just realized this was left behind ;-)

Applied both.
