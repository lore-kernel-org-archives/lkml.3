Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaFEVeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:34:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:56620 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaFEVeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,983,1392192000"; 
   d="scan'208";a="550451118"
Date: Thu, 5 Jun 2014 14:33:54 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 4/9] perf/x86: add cross-HT counter exclusion
 infrastructure
Message-ID: <20140605213354.GD16855@tassilo.jf.intel.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-5-git-send-email-eranian@google.com>
 <20140605082935.GI3213@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605082935.GI3213@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This hard assumes theres only ever 2 threads, which is true and I
> suppose more in arch/x86 will come apart the moment Intel makes a chip
> with more, still, do we have topology_thread_id() or so to cure this?


Xeon Phi already has 4 threads today.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
