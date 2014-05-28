Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaE1RsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:48:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:38231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaE1Rr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,929,1392192000"; 
   d="scan'208";a="519174431"
Date: Wed, 28 May 2014 10:47:58 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528174758.GO29957@tassilo.jf.intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <20140528153548.GY11096@twins.programming.kicks-ass.net>
 <20140528160847.GJ29957@tassilo.jf.intel.com>
 <20140528170531.GT30445@twins.programming.kicks-ass.net>
 <20140528172540.GM29957@tassilo.jf.intel.com>
 <CABPqkBSJGu67NMw5YRA6f0W5JqP8OC4Y6W4mgbasAM+N458yqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSJGu67NMw5YRA6f0W5JqP8OC4Y6W4mgbasAM+N458yqA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's a plausible scenario if you consider two distinct sessions of a tool,
> i.e., two users running perf top or perf record some precise events.

Then they will start at different times (if they are not on different cores), 
so it's still not synchronized and unlikely to meet.

|----< 1000+ > -----|
A
         |------< 1000+> ------|
         B

-Andi
