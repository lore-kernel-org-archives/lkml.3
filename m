Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaAYEb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 23:31:28 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:43486 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaAYEbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 23:31:25 -0500
Message-ID: <52E33DFC.6010706@hp.com>
Date: Fri, 24 Jan 2014 23:30:52 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
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
        Tim Chen <tim.c.chen@linux.intel.com>, "" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v11 4/4] qrwlock: Use the mcs_spinlock helper functions
 for MCS queuing
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com> <1390537731-45996-5-git-send-email-Waiman.Long@hp.com> <20140124082617.GC31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140124082617.GC31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 03:26 AM, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 11:28:51PM -0500, Waiman Long wrote:
>> There is a pending MCS lock patch series that adds generic MCS lock
>> helper functions to do MCS-style locking. This patch will enable
>> the queue rwlock to use that generic MCS lock/unlock primitives for
>> internal queuing. This patch should only be merged after the merging
>> of that generic MCS locking patch.
> I would still very much like this patch to be merged into the first. It
> saves having to review all the code removed again.

I will merge it to the first one once the once the MCS patches are in 
the mainline or the tip branch.

-Longman
