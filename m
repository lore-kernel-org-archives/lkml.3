Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaJQQLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:11:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaJQQLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:11:52 -0400
Date: Fri, 17 Oct 2014 18:11:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 9/9] perf script: Add period as a default output column
Message-ID: <20141017161102.GB19692@krava.redhat.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-10-git-send-email-jolsa@kernel.org>
 <53FDEDF1.6010803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FDEDF1.6010803@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 08:40:49AM -0600, David Ahern wrote:
> On 8/25/14, 8:45 AM, Jiri Olsa wrote:
> >Adding period as a default output column in script command
> >fo hardware, software and raw events.
> >
> >If PERF_SAMPLE_PERIOD sample type is defined in perf.data,
> >following will be displayed in perf script output:
> >
> >   $ perf script
> >               ls  8034 57477.887209:     250000 task-clock:  ffffffff81361d72 memset ([kernel.kallsyms])
> >               ls  8034 57477.887464:     250000 task-clock:  ffffffff816f6d92 _raw_spin_unlock_irqrestore ([kernel.kallsyms])
> >               ls  8034 57477.887708:     250000 task-clock:  ffffffff811a94f0 do_munmap ([kernel.kallsyms])
> >               ls  8034 57477.887959:     250000 task-clock:        34080916c6 get_next_seq (/usr/lib64/libc-2.17.so)
> >               ls  8034 57477.888208:     250000 task-clock:        3408079230 _IO_doallocbuf (/usr/lib64/libc-2.17.so)
> >               ls  8034 57477.888717:     250000 task-clock:  ffffffff814242c8 n_tty_write ([kernel.kallsyms])
> >               ls  8034 57477.889285:     250000 task-clock:        3408076402 fwrite_unlocked (/usr/lib64/libc-2.17.so)
> >
> >Cc: Andi Kleen<andi@firstfloor.org>
> >Cc: Arnaldo Carvalho de Melo<acme@kernel.org>
> >Cc: Corey Ashford<cjashfor@linux.vnet.ibm.com>
> >Cc: David Ahern<dsahern@gmail.com>
> >Cc: Frederic Weisbecker<fweisbec@gmail.com>
> >Cc: Ingo Molnar<mingo@kernel.org>
> >Cc: Jen-Cheng(Tommy) Huang<tommy24@gatech.edu>
> >Cc: Namhyung Kim<namhyung@kernel.org>
> >Cc: Paul Mackerras<paulus@samba.org>
> >Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> >Cc: Stephane Eranian<eranian@google.com>
> >Signed-off-by: Jiri Olsa<jolsa@kernel.org>
> 
> 
> Acked-by: David Ahern <dsahern@gmail.com>

this one (referenced by earlier email) ;-)

thanks,
jirka
