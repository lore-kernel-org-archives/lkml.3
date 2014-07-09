Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbaGITJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:09:28 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:65209 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGITJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:09:26 -0400
Date: Wed, 9 Jul 2014 16:09:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]  perf script: Add callchain to generic and
 tracepoint events
Message-ID: <20140709190921.GD5721@kernel.org>
References: <20140307141857.GA3153@ghostprotocols.net>
 <533D2283.3090703@tu-dresden.de>
 <87wqd5f7j5.fsf@sejong.aot.lge.com>
 <538F0BF2.1010806@tu-dresden.de>
 <20140707171706.GA20752@krava.redhat.com>
 <53BCF1F2.70100@tu-dresden.de>
 <20140709112721.GC1814@krava.redhat.com>
 <53BD2AD6.6020309@tu-dresden.de>
 <20140709114903.GA5767@krava.redhat.com>
 <53BD4EC1.1060907@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD4EC1.1060907@tu-dresden.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 09, 2014 at 04:16:33PM +0200, Joseph Schuchart escreveu:
> 
>  perf script: Add callchain to generic and tracepoint events.  Since
>  this alters the interface for the python scripts, also adjust the script 
>  generation and the provided scripts.
> 
> Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
> Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>

This one is not applying, I'm checking the reason for its malformation
as stated in:


[acme@ssdandy linux]$ patch -p1 < /wb/1.patch 
patching file tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
Hunk #1 FAILED at 107.
1 out of 1 hunk FAILED -- saving rejects to file tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py.rej
patching file tools/perf/scripts/python/check-perf-trace.py
Hunk #1 succeeded at 27 with fuzz 1.
Hunk #2 succeeded at 37 with fuzz 2 (offset -1 lines).
patching file tools/perf/scripts/python/failed-syscalls-by-pid.py
Hunk #1 FAILED at 39.
1 out of 1 hunk FAILED -- saving rejects to file tools/perf/scripts/python/failed-syscalls-by-pid.py.rej
patching file tools/perf/scripts/python/futex-contention.py
patch: **** malformed patch at line 154: ain,

[acme@ssdandy linux]$
