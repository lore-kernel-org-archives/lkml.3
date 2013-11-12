Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3KLOyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:54:04 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37413 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3KLOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:00 -0500
Message-ID: <528240EF.5030600@hp.com>
Date: Tue, 12 Nov 2013 09:53:35 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, "" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v6 1/3] qrwlock: A queue read/write lock implementation
References: <1384267735-43213-1-git-send-email-Waiman.Long@hp.com> <1384267735-43213-3-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1384267735-43213-3-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 09:48 AM, Waiman Long wrote:
> This patch introduces a new read/write lock implementation that put
> waiting readers and writers into a queue instead of actively contending
> the lock like the current read/write lock implementation. This will
> improve performance in highly contended situation by reducing the
> cache line bouncing effect.
>
>

Sorry, it is a fat finger. Please ignore this v6 1/3 patch. It is an old 
one.

-Longman
