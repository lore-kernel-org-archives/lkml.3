Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaKEQ1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:27:33 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaKEQ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:27:31 -0500
Date: Wed, 5 Nov 2014 17:27:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V7 00/17] perf, x86: Haswell LBR call stack support
Message-ID: <20141105162723.GW3337@twins.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <20141105093759.GQ10501@worktop.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770165410A@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770165410A@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:22:09PM +0000, Liang, Kan wrote:
> 
> >> 
> > 
> > So if I take all except 11,13,16,17 but instead do something like the below,
> > everything will work just fine, right?
> > 
> > Or am I missing something?
> > 
> 
> Yes, it should work.  Then LBR callstack will rely on user to enable it.
> But user never get the LBR callstack data if it's available.  
> I'm not sure why you do that? 

Uhm what? If you request PERF_SAMPLE_BRANCH_CALL_STACK the user will get
the data through the regular PERF_SAMPLE_BRANCH_STACK output of
PERF_RECORD_SAMPLE, right?
