Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3HPRx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:53:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:6199 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3HPRxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:53:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,896,1367996400"; 
   d="scan'208";a="388343533"
Message-ID: <520E672C.3080102@intel.com>
Date: Fri, 16 Aug 2013 10:53:48 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alex Thorlton <athorlton@sgi.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 1/8] THP: Use real address for NUMA policy
References: <87wqo050fc.fsf@tassilo.jf.intel.com> <1376663644-153546-1-git-send-email-athorlton@sgi.com> <1376663644-153546-2-git-send-email-athorlton@sgi.com>
In-Reply-To: <1376663644-153546-2-git-send-email-athorlton@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 07:33 AM, Alex Thorlton wrote:
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a92012a..55ec681 100644

Could you add some actual descriptions to these patches that say why you
are doing this, and why this particular patch is needed and implemented
this way?

You mention that THP is slow for you, then go on to implement some
non-cached page zero'ing, but you never quite connect the dots.
