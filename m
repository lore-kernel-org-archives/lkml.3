Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab3EJBew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:34:52 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46191 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3EJBev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:34:51 -0400
X-AuditID: 9c93016f-b7ba0ae000004cc2-68-518c4eb9b32f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/9] perf tools: Add precise object to interface sysfs precise
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
	<1368106344-23383-3-git-send-email-jolsa@redhat.com>
Date: Fri, 10 May 2013 10:34:49 +0900
In-Reply-To: <1368106344-23383-3-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 9 May 2013 15:32:17 +0200")
Message-ID: <87bo8j7h3a.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu,  9 May 2013 15:32:17 +0200, Jiri Olsa wrote:
> Adding precise util object to get maximum value for
> perf_event_attr::precise_ip. The value is exported
> via sysfs file '/sys/devices/cpu/precise'.
>
> The interface is:
>   int perf_precise__get(void)

I think Arnaldo wants to use double underscores to separate the name of
data struct and method name.  So wouldn't it be more appropriate using
one of perf_precise_get() or perf_get_precise()?

Thanks,
Namhyung
