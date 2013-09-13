Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3IMVmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:42:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35364 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3IMVmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:42:36 -0400
Date: Fri, 13 Sep 2013 23:42:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
Message-ID: <20130913214225.GJ21832@twins.programming.kicks-ass.net>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net>
 <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
 <alpine.DEB.2.02.1309131728260.4174@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309131728260.4174@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 05:31:26PM -0400, Vince Weaver wrote:
> So in Adrian Hunter's posted patches the PERF_RECORD_MMAP documentation
> is also patched like all the others, with 
> 
>     struct sample_id                sample_id;
> 
> But in this tip message (and in the current linus-git kernel) somehow the
> PERF_RECORD_MMAP line of the patch was dropped.
> 
> Was that intentional?

No, no idea what happened..

---
Subject: perf: Update ABI comment
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri Sep 13 23:39:17 CEST 2013

For some mysterious reason the sample_id field of PERF_RECORD_MMAP
went AWOL.

Reported-by: Vince Weaver <vince@deater.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/uapi/linux/perf_event.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -528,6 +528,7 @@ enum perf_event_type {
 	 *	u64				len;
 	 *	u64				pgoff;
 	 *	char				filename[];
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_MMAP			= 1,
