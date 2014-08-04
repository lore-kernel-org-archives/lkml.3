Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaHDV6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:58:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:56452 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbaHDV6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:58:22 -0400
Date: Mon, 4 Aug 2014 18:58:16 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 00/31] perf tools: Yet more preparation for call graph
 from Intel BTS
Message-ID: <20140804215816.GG13375@kernel.org>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 31, 2014 at 09:00:43AM +0300, Adrian Hunter escreveu:
> Hi
> 
> Here is the next selection of patches based on tip/perf/core.
> 
> They can also be found here:
> 
> 	http://git.infradead.org/users/ahunter/linux-perf.git/shortlog/refs/heads/for-acme

Just FYI, did some processing today, what I picked I stashed on my
tmp.perf/core branch, will continue.

But having something that actually uses all this stuff in 'perf test' is
something I'm missing...

Things like using that set_tracking new API on a evlist with the
sched_switch, using it to track, then switching it off after moving the
tracking event to another event in the list, etc. 

- Arnaldo
