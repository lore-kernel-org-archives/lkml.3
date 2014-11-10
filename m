Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaKJNyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:54:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:19748 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaKJNyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:54:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,353,1413270000"; 
   d="scan'208";a="605302997"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V8 00/14] perf, x86: Haswell LBR call stack support
 (kernel)
Thread-Topic: [PATCH V8 00/14] perf, x86: Haswell LBR call stack support
 (kernel)
Thread-Index: AQHP+dOAakN2aUkU0E2SrfkfmVvbBpxZJCyAgADA3+A=
Date: Mon, 10 Nov 2014 13:54:03 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770165E272@SHSMSX103.ccr.corp.intel.com>
References: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
 <20141110101327.GG3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141110101327.GG3337@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> On Thu, Nov 06, 2014 at 09:54:17AM -0500, Kan Liang wrote:
> > Yan, Zheng (13):
> >   perf, x86: Reduce lbr_sel_map size
> >   perf, core: introduce pmu context switch callback
> >   perf, x86: use context switch callback to flush LBR stack
> >   perf, x86: Basic Haswell LBR call stack support
> >   perf, core: pmu specific data for perf task context
> >   perf, core: always switch pmu specific data during context switch
> >   perf, x86: allocate space for storing LBR stack
> >   perf, x86: track number of events that use LBR callstack
> >   perf, x86: Save/resotre LBR stack during context switch
> >   perf, core: simplify need branch stack check
> >   perf, x86: re-organize code that implicitly enables LBR/PEBS
> >   perf, x86: disable FREEZE_LBRS_ON_PMI when LBR operates in callstack
> >       mode
> >   perf, x86: Discard zero length call entries in LBR call stack
> >
> > Peter Zijlstra (Intel) (1):
> >   perf, x86: expose LBR callstack to user space tool
> 
> So are these the exact same patches I already had, or did you change
> anything else? Its not immediately clear, lemme try and figure out.

Yes, Zheng's patches are exact same patches as you already had. I only
remove 11, 13,16, 17 from previous patch set and add your new patch (no
change). The significant changes are in user tool part, I sent them out as
a separate patch set.

Thanks,
Kan
