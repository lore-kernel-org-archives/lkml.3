Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3JBRZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:25:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:57778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab3JBRZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1019,1371106800"; 
   d="scan'208";a="404347688"
Date: Wed, 2 Oct 2013 10:25:07 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH 11/11] perf: Avoid uninitialized sample type reference in
 __perf_event__output_id_sample
Message-ID: <20131002172507.GG2125@tassilo.jf.intel.com>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-12-git-send-email-andi@firstfloor.org>
 <20131002085730.GD12926@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002085730.GD12926@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why are you doing this; also what's up with 11/11?

I was playing with a static checker, and posted some
of the fixes from looking at the warnings.
There were 11 patches in the series

Only one is perf related.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
