Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3LJPsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:48:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab3LJPsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:48:37 -0500
Date: Tue, 10 Dec 2013 16:47:33 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Ben Cheng <bccheng@google.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
Message-ID: <20131210154733.GF8108@krava.brq.redhat.com>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
 <20131210110759.GA26659@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210110759.GA26659@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 12:07:59PM +0100, Ingo Molnar wrote:
> 

SNIP

> 
> Pulled, thanks Arnaldo!
> 
> There's one detail I noticed about the recent trace-plugin changes:
> 
> comet:~/tip/tools/perf> make install
>   BUILD:   Doing 'make -j12' parallel build
>   SUBDIR   Documentation
>   INSTALL  Documentation-man
>   INSTALL  GTK UI
>   SUBDIR   /home/mingo/tip/tools/lib/traceevent/
>   INSTALL  binaries
>   INSTALL  plugin_jbd2.so
>   INSTALL  plugin_hrtimer.so
>   INSTALL  plugin_kmem.so
>   INSTALL  plugin_kvm.so
>   INSTALL  plugin_mac80211.so
>   INSTALL  plugin_sched_switch.so
>   INSTALL  plugin_function.so
>   INSTALL  plugin_xen.so
>   INSTALL  plugin_scsi.so
>   INSTALL  plugin_cfg80211.so
>   INSTALL  libexec
>   INSTALL  perf-archive
>   INSTALL  perl-scripts
>   INSTALL  python-scripts
>   INSTALL  perf_completion-script
>   INSTALL  tests
> 
> those plugin installs are way too verbose, they should really be in a 
> single summarized line, only saying something like:
> 
>   INSTALL  plugins
> 
> Just like we already sum up 'binaries', 'libexec', 'tests', etc.

ok, TODO updated ;-)

thanks,
jirka
