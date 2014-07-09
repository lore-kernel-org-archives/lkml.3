Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaGIL1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbaGIL1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:27:44 -0400
Date: Wed, 9 Jul 2014 13:27:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]  perf script: Add callchain to generic and
 tracepoint events
Message-ID: <20140709112721.GC1814@krava.redhat.com>
References: <53031D2C.2050009@tu-dresden.de>
 <20140307141857.GA3153@ghostprotocols.net>
 <533D2283.3090703@tu-dresden.de>
 <87wqd5f7j5.fsf@sejong.aot.lge.com>
 <538F0BF2.1010806@tu-dresden.de>
 <20140707171706.GA20752@krava.redhat.com>
 <53BCF1F2.70100@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BCF1F2.70100@tu-dresden.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:40:34AM +0200, Joseph Schuchart wrote:
> [PATCH 2/3]  perf script: Add callchain to generic and tracepoint events.  Since
>  this alters the interface for the python scripts, also adjust the script 
>  generation and the provided scripts.

still having issues to apply 2nd patch on tip/perf/core (8b5b584)

Applying: perf script: Add missing calls to Py_DECREF for return values
Applying: perf script: Add callchain to generic and tracepoint events
error: patch failed: tools/perf/util/scripting-engines/trace-event-python.c:237
error: tools/perf/util/scripting-engines/trace-event-python.c: patch does not apply
Patch failed at 0002 perf script: Add callchain to generic and tracepoint events
The copy of the patch that failed is found in:
   /home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch
When you have resolved this problem, run "git am --resolved".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".


thanks,
jirka
