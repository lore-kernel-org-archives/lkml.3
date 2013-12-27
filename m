Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3L0UFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:05:48 -0500
Received: from mail-gg0-f171.google.com ([209.85.161.171]:63110 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3L0UFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:05:47 -0500
Date: Fri, 27 Dec 2013 17:05:38 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 00/35] perf/core improvements and fixes
Message-ID: <20131227200538.GD13381@ghostprotocols.net>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 20, 2013 at 04:08:35PM -0300, Arnaldo Carvalho de Melo escreveu:
> User visible changes:
> 
> Improvements:
> 
> . Do not show stats if workload fails in 'stat' (David Ahern)

Hi Ingo,

	Please hold on, as reported elsewhere, the above change broke
'perf stat valid-workload', so I removed it from my tree.

	I'll resubmit soon with a bunch more,

Thanks,

- Arnaldo
