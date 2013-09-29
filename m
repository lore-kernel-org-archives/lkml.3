Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3I2Vde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 17:33:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:19509 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab3I2Vdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 17:33:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1006,1371106800"; 
   d="scan'208";a="367335179"
Date: Sun, 29 Sep 2013 14:33:29 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130929213329.GA2125@tassilo.jf.intel.com>
References: <20130928180327.GA5000@gmail.com>
 <20130929114700.GB282@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929114700.GB282@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> breaks "perf top" on my machine. I just see a gray screen with no text
> at all. Sometimes the following error messages are printed:
>  *** Error in `perf': invalid fastbin entry (free): 0x00000000029b18c0 ***
>  *** Error in `perf': malloc(): memory corruption (fast): 0x0000000000ee0b10 ***

Hmm, works for me. In fact I wrote it to fix a perf top issue.

What does valgrind say?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
