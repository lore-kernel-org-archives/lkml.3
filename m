Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbaJ2M6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:58:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:37207 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932806AbaJ2M63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:58:29 -0400
Date: Wed, 29 Oct 2014 10:58:24 -0200
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@au1.ibm.com>,
        Arun Sharma <asharma@fb.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Wang Nan <wangnan0@huawei.com>
Subject: Re: [GIT PULL 00/32] perf/core improvements and fixes
Message-ID: <20141029125824.GC19829@kernel.org>
References: <1414503146-22789-1-git-send-email-acme@kernel.org>
 <20141029091148.GA9000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029091148.GA9000@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 29, 2014 at 10:11:48AM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > * 'perf probe' --demangle typo fix and a new --quiet option (Masami Hiramatsu)
 
> So the fix part would be nice to have for perf/urgent I suspect?
 
> > * Fix report -F (abort, in_tx, mispredict, etc) segfaults for sample.data files
> >   without branch info (Jiri Olsa)
 
> Ditto.
 
> > * Don't open the DWARF info multiple times, keeping instead a dwfl handle
> >   in struct dso, greatly speeding up 'perf report' on powerpc. (Sukadev Bhattiprolu)

> > * Add patch that should have went in a previous patchkit to use global cache
> >   provided by libunwind (Namhyung Kim)

> Given that this is already upstream, is this a required fix for 
> perf/urgent or can it wait and go into perf/core?
 
> And then the remaining bits should be based on the urgent tree.

Ok, did the split, I thought that those were lower prio for corner cases
and it all going via the next release, but sure, if you think it can go
this time, lets do it :-)

- Arnaldo
