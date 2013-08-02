Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3HBX4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:56:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:38600 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3HBX4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:56:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,805,1367996400"; 
   d="scan'208";a="375418591"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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
In-Reply-To: <20130802203457.GR26476@sgi.com>
References: <20130802194659.GP26476@sgi.com>
 <20130802201301.A872BE0090@blue.fi.intel.com>
 <20130802203457.GR26476@sgi.com>
Subject: Re: [PATCH] Add per-process flag to control thp
Content-Transfer-Encoding: 7bit
Message-Id: <20130802235941.8392AE0090@blue.fi.intel.com>
Date: Sat,  3 Aug 2013 02:59:41 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton wrote:
> > What kind of workloads are you talking about?
> 
> Our benchmarking team has a list of several of the SPEC OMP benchmarks
> that perform significantly better when THP is disabled. I tried to get
> the list but one of our servers is acting up and I can't get to it
> right now :/

Have you track down the reason why it's slow tih THP?

-- 
 Kirill A. Shutemov
