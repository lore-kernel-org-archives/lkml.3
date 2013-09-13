Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3IMRsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:48:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:49608 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3IMRsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:48:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,899,1371106800"; 
   d="scan'208";a="401279838"
Date: Fri, 13 Sep 2013 10:48:02 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vince@deater.net>, acme@infradead.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        torvalds@linux-foundation.org, trinity@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Message-ID: <20130913174802.GU11427@tassilo.jf.intel.com>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
 <20130912165733.GA23698@gmail.com>
 <20130912173617.GI18242@two.firstfloor.org>
 <20130913085654.GI31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913085654.GI31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Typically PMU drivers are per arch and all the format stuff is per pmu
> driver so I'd not worry about that just yet.

That's a good point. So hard coded numbers would be fine for now.

> Yes, that is an unfortunate situation. I (and either Acme or Jolsa)
> tried wrapping the bitfield in an anonymous union to create a named
> variable for the entire u64 but older GCC completely fails with that.

In theory it's possible by parsing readelf output.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
