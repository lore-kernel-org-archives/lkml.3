Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3HECgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:36:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:32319 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab3HECgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:36:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,815,1367996400"; 
   d="scan'208";a="381230906"
From: Andi Kleen <andi@firstfloor.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] Add per-process flag to control thp
References: <20130802194659.GP26476@sgi.com>
	<20130802201301.A872BE0090@blue.fi.intel.com>
	<20130802203457.GR26476@sgi.com>
Date: Sun, 04 Aug 2013 19:36:07 -0700
In-Reply-To: <20130802203457.GR26476@sgi.com> (Alex Thorlton's message of
	"Fri, 2 Aug 2013 15:34:57 -0500")
Message-ID: <87wqo050fc.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton <athorlton@sgi.com> writes:

>> What kind of workloads are you talking about?
>
> Our benchmarking team has a list of several of the SPEC OMP benchmarks
> that perform significantly better when THP is disabled. I tried to get
> the list but one of our servers is acting up and I can't get to it
> right now :/

Please try it with the vclear patches.

https://lkml.org/lkml/2012/7/20/165
et.al.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
