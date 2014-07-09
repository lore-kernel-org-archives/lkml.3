Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbaGIT3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:29:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:36777 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaGIT3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:29:30 -0400
Date: Wed, 9 Jul 2014 16:29:26 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]  perf script: Add callchain to generic and
 tracepoint events
Message-ID: <20140709192926.GF5721@kernel.org>
References: <87wqd5f7j5.fsf@sejong.aot.lge.com>
 <538F0BF2.1010806@tu-dresden.de>
 <20140707171706.GA20752@krava.redhat.com>
 <53BCF1F2.70100@tu-dresden.de>
 <20140709112721.GC1814@krava.redhat.com>
 <53BD2AD6.6020309@tu-dresden.de>
 <20140709114903.GA5767@krava.redhat.com>
 <53BD4EC1.1060907@tu-dresden.de>
 <20140709190921.GD5721@kernel.org>
 <20140709191223.GE5721@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709191223.GE5721@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 09, 2014 at 04:12:23PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Jul 09, 2014 at 04:09:21PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Wed, Jul 09, 2014 at 04:16:33PM +0200, Joseph Schuchart escreveu:

> > This one is not applying, I'm checking the reason for its malformation
> > as stated in:

> > [acme@ssdandy linux]$ patch -p1 < /wb/1.patch 
> > patching file tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
> > Hunk #1 FAILED at 107.
> > 1 out of 1 hunk FAILED -- saving rejects to file tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py.rej
> > patching file tools/perf/scripts/python/check-perf-trace.py
> > Hunk #1 succeeded at 27 with fuzz 1.
> > Hunk #2 succeeded at 37 with fuzz 2 (offset -1 lines).
> > patching file tools/perf/scripts/python/failed-syscalls-by-pid.py
> > Hunk #1 FAILED at 39.
> > 1 out of 1 hunk FAILED -- saving rejects to file tools/perf/scripts/python/failed-syscalls-by-pid.py.rej
> > patching file tools/perf/scripts/python/futex-contention.py
> > patch: **** malformed patch at line 154: ain,
 
> It is full of:
 
>                 self.cpu =3D common_cpu

Ok, I applied the first patch on this series, please see my perf/core
branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git

You can have it with:

  git remote add acme git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
  git checkout -b perf/core acme/perf/core

Then please create the patches and follow the instructions about
Thunderbird at:

https://www.kernel.org/pub/software/scm/git/docs/git-format-patch.html

So that it doesn't mangles the patch and resend, ok?

- Arnaldo
