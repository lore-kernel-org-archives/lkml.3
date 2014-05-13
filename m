Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbaEMOIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:08:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:27643 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120AbaEMOIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:08:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1044,1389772800"; 
   d="scan'208";a="538279308"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v2
References: <1399935686-26940-1-git-send-email-andi@firstfloor.org>
	<20140513092748.GT30445@twins.programming.kicks-ass.net>
Date: Tue, 13 May 2014 07:08:24 -0700
In-Reply-To: <20140513092748.GT30445@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Tue, 13 May 2014 11:27:48 +0200")
Message-ID: <87ppjh4vqf.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> Hmm, my first looking at the spark thingies interpreted them as a
> histogram. But they're not really.

It's a histogram of variance.

> Would it be possible to make it a histogram of -2sigma,2sigma around the
> avg value? That way you can plot all data and get a good idea of the
> distribution. I'd suggest using 9 buckets for it.

I doubt that would work well with only ~8 values.
This would need multiple lines or a real plotter,
otherwise you would have all kinds of odd corner cases.

Sparklines are much better for limited space.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
