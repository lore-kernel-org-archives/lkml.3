Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaG1PXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:23:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:59575 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaG1PXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:23:34 -0400
Date: Mon, 28 Jul 2014 12:23:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] Revert "perf tools: Fix jump label always changing
 during tracing"
Message-ID: <20140728152329.GN7831@kernel.org>
References: <1406559662-4376-1-git-send-email-jolsa@kernel.org>
 <1406559662-4376-3-git-send-email-jolsa@kernel.org>
 <20140728150433.GQ19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728150433.GQ19379@twins.programming.kicks-ass.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 28, 2014 at 05:04:33PM +0200, Peter Zijlstra escreveu:
> On Mon, Jul 28, 2014 at 05:01:02PM +0200, Jiri Olsa wrote:
> > This reverts commit deaff8b659cf4d34181c087b8cdf74f1eb17b02b.
> > 
> > This commit makes CLOEXEC feature undetected for normal users,
> > because per-cpu events are priviledged.
> > 
> > Reported-by: Peter Zijlstra <peterz@infradead.org>
> 
> Thanks Jiri!

Thanks++

:-)

- Arnaldo
