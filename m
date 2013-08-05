Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab3HETFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:05:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:62671 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab3HETFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,820,1367996400"; 
   d="scan'208";a="342041233"
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home>
Date: Mon, 05 Aug 2013 12:04:57 -0700
In-Reply-To: <1375721715.22073.80.camel@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 05 Aug 2013 12:55:15 -0400")
Message-ID: <87siyo3qna.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

Can't you just use -freorder-blocks-and-partition?

This should already partition unlikely blocks into a
different section. Just a single one of course.

FWIW the disadvantage is that multiple code sections tends
to break various older dwarf unwinders, as it needs
dwarf3 latest'n'greatest.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
