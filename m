Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaKLPFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:05:32 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:32906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKLPFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:05:31 -0500
Date: Wed, 12 Nov 2014 16:05:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, "acme@kernel.org" <acme@kernel.org>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf tools: Construct LBR call chain
Message-ID: <20141112150520.GE21343@twins.programming.kicks-ass.net>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
 <1415285886-16949-3-git-send-email-kan.liang@intel.com>
 <20141112085914.GC25338@krava>
 <37D7C6CF3E00A74B8858931C1DB2F07701661906@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701661906@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:37:13PM +0000, Liang, Kan wrote:
> If the user set lbr, I think he really want the lbr info. So I think if we display
> both lbr and fp, the fp chain might be meaningless and it will confuse them.
> If the user want to do compare, they can do perf record twice with 
> different --call-graph.

Or fix the tool to do both. Having both from the exact same context is
far better to compare the quality of the actual backtraces.

But that is not something we have to implement now; but the kernel
interface does allow it.
