Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaHML3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:29:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaHML3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:29:18 -0400
Date: Wed, 13 Aug 2014 13:28:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/4] perf tools: API probing fixes
Message-ID: <20140813112847.GC2370@krava.brq.redhat.com>
References: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 06:04:27PM +0300, Adrian Hunter wrote:
> Hi
> 
> Here are some fixes for API probing issues that I have run into,
> and a second attempt at the jump-label problem.
> 
> Patches apply to your tmp.perf/core branch.
> 
> 
> Adrian Hunter (4):
>       perf tools: Fix CLOEXEC probe for perf_event_paranoid == 2
>       perf tools: Fix one of the probe events to exclude kernel
>       perf tools: Fix probing the kernel API with cpu-wide events
>       perf tools: Prefer to use a cpu-wide event for probing CLOEXEC

for the patchset:

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
