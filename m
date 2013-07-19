Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3GSThW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab3GSThU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:37:20 -0400
Message-ID: <51E9954C.9000405@redhat.com>
Date: Fri, 19 Jul 2013 15:36:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Waiman Long <Waiman.Long@hp.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: Fix mutex_can_spin_on_owner
References: <20130719183101.GA20909@twins.programming.kicks-ass.net>
In-Reply-To: <20130719183101.GA20909@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 02:31 PM, Peter Zijlstra wrote:
>
> mutex_can_spin_on_owner() is broken in that it would allow the compiler
> to load lock->owner twice, seeing a pointer first time and a MULL
> pointer the second time.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
