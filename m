Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3HLQCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:02:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:7231 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab3HLQCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:02:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,863,1367996400"; 
   d="scan'208";a="345181763"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home>
	<20130812091707.GB27162@twins.programming.kicks-ass.net>
	<5208F78A.3000708@linux.intel.com>
Date: Mon, 12 Aug 2013 09:02:02 -0700
In-Reply-To: <5208F78A.3000708@linux.intel.com> (H. Peter Anvin's message of
	"Mon, 12 Aug 2013 07:56:10 -0700")
Message-ID: <878v06oq2t.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@linux.intel.com> writes:

> However, I would really like to
> understand what the value is.

Probably very little. When I last looked at it, the main overhead in
perf currently seems to be backtraces and the ring buffer, not this
code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
