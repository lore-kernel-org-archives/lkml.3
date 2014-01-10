Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbaAJPey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:34:54 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:45181 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaAJPew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:34:52 -0500
Message-ID: <52D01300.60408@hp.com>
Date: Fri, 10 Jan 2014 10:34:24 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, "" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v8 0/4] qrwlock: Introducing a queue read/write lock implementation
References: <1389200376-62792-1-git-send-email-Waiman.Long@hp.com> <20140110064236.GV10038@linux.vnet.ibm.com>
In-Reply-To: <20140110064236.GV10038@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 01:42 AM, Paul E. McKenney wrote:
> On Wed, Jan 08, 2014 at 11:59:32AM -0500, Waiman Long wrote:
>> v7->v8:
>>   - Use atomic_t functions (which are implemented in all arch's) to
>>     modify reader counts.
>>   - Use smp_load_acquire()&  smp_store_release() for barriers.
>>   - Further tuning in slowpath performance.
> This version looks good to me.  You now have my Reviewed-by on all
> the patches.
>
> 							Thanx, Paul

Thank for your review!

-Longman
