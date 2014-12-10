Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbaLJXvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:51:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:33455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073AbaLJXvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:51:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,554,1413270000"; 
   d="scan'208";a="621884207"
Date: Wed, 10 Dec 2014 15:51:16 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Vince Weaver <vince@deater.net>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/2] perf/x86/intel/uncore: Make sure only uncore events
 are collected
Message-ID: <20141210235116.GL10824@tassilo.jf.intel.com>
References: <1418243031-20367-1-git-send-email-jolsa@kernel.org>
 <1418243031-20367-2-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418243031-20367-2-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 09:23:50PM +0100, Jiri Olsa wrote:
> The uncore_collect_events functions assumes that event group
> might contain only uncore events which is wrong, because it
> might contain any type of events.
> 
> This bug leads to uncore framework touching 'not' uncore events,
> which could end up all sorts of bugs.

Thanks for tracking that down. Looks good to me.

-Andi
