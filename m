Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3GLIxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:53:40 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42851 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab3GLIxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:53:37 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-12-51dfc40fe3c6
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCHv2 0/5] perf tools: Remove event types data
References: <1373556513-3000-1-git-send-email-jolsa@redhat.com>
Date: Fri, 12 Jul 2013 17:53:35 +0900
In-Reply-To: <1373556513-3000-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 11 Jul 2013 17:28:28 +0200")
Message-ID: <87txk0w44w.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 11 Jul 2013 17:28:28 +0200, Jiri Olsa wrote:
> hi,
> following up on the 'perf timechart' FIXME note and changing
> its tracepoint match not to use event types data.
>
> Original RFC sent here:
> http://marc.info/?l=linux-kernel&m=137344263513417&w=2
>
> v2 changes:
>   - using tracepoints haler callbacks to get power data
>     in timechart command (patch 2)
>   - separating enum removal of 'enum trace_flag_type'
>     (patch 1)
>
> Again, timechart (and perf.data)  tests look ok, but would
> appreciate another tester ;-).
>
> It's reachable here:
> git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> perf/et2

For the whole patchset:

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
