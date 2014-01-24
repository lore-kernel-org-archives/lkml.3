Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaAXI0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:26:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55705 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaAXI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:26:47 -0500
Date: Fri, 24 Jan 2014 09:26:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v11 4/4] qrwlock: Use the mcs_spinlock helper functions
 for MCS queuing
Message-ID: <20140124082617.GC31570@twins.programming.kicks-ass.net>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <1390537731-45996-5-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390537731-45996-5-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:28:51PM -0500, Waiman Long wrote:
> There is a pending MCS lock patch series that adds generic MCS lock
> helper functions to do MCS-style locking. This patch will enable
> the queue rwlock to use that generic MCS lock/unlock primitives for
> internal queuing. This patch should only be merged after the merging
> of that generic MCS locking patch.

I would still very much like this patch to be merged into the first. It
saves having to review all the code removed again.
