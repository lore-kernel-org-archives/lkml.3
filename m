Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3KWJpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:45:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab3KWJp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:45:29 -0500
Date: Sat, 23 Nov 2013 10:44:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 0/3] perf tools: Add data file write interface
Message-ID: <20131123094455.GA10130@krava.redhat.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <528F71DB.30603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F71DB.30603@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 08:01:47AM -0700, David Ahern wrote:
> On 11/22/13, 7:24 AM, Jiri Olsa wrote:
> >David,
> >patch 2 could colide with your mmap changes, not sure
> >what's your plan with that in near future, let me know
> >and I can rebase if needed.
> 
> The day job requires some focus for a few days. I was hoping to
> revisit the mmap output end of next week during the holidays here.
> Make mmap optional -- default to write with an option for mmap. Add
> some builtin detection to do the right thing if the user did not
> specify a preference -- system wide tracing should flip to mmap,
> system wide faults should write. Log a warning to the user if the
> requested option goes against that. If Peter or Ingo have other
> thoughts or ideas to the contrary I'd love to hear them before the
> next iteration.

so.. I understand you'll make changes anyway
and dont mind to rebase? ;-)

thanks,
jirka
