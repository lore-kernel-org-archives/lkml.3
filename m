Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaJGQaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:30:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaJGQaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:30:03 -0400
Date: Tue, 7 Oct 2014 18:29:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 11/16] perf, core: Pass perf_sample_data to
 perf_callchain()
Message-ID: <20141007162956.GB6652@twins.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-12-git-send-email-kan.liang@intel.com>
 <20140924141507.GF2805@worktop.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770160F98C@SHSMSX103.ccr.corp.intel.com>
 <20141007152412.GC5850@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077016110CE@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077016110CE@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 03:50:45PM +0000, Liang, Kan wrote:
> The data is originally from br_stack which is LBR format.

Right, its read from the LBR, therefore this must be.

> What the patch did is to convert it to CALLCHAIN output format in kernel.

I saw that.

> So you'd like to let the kernel pass the LBR output format data to user space
> perf tool,  and let perf tool to generate the callchain information?

Right, then we can also compare the two when they're both available.
