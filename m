Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3I3Sya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:54:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:39082 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab3I3Sy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:54:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1009,1371106800"; 
   d="scan'208";a="411984722"
Date: Mon, 30 Sep 2013 11:54:28 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130930185428.GE2125@tassilo.jf.intel.com>
References: <20130928180327.GA5000@gmail.com>
 <20130929114700.GB282@x4>
 <20130929213329.GA2125@tassilo.jf.intel.com>
 <20130930062735.GA13482@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930062735.GA13482@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The blurb you wrote in the changelog:
> 
> | The libbfd C++ demangler doesn't seem to deal with cloned functions, 
> | like symbol.clone.NUM.
> |
> | Just strip the dot part before demangling and add it back later.
> 
> Only alludes to a C++ symbol resolution annoyance and thus isn't very 
> informative.

The issue was that I saw a long unreadable line noise string in report/top,
instead of a demangled function. After I stripped the postfix I got the demangled
symbol as expected.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
