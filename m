Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaA3Rqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:46:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaA3Rqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:46:40 -0500
Message-ID: <52EA8FAA.8080803@redhat.com>
Date: Thu, 30 Jan 2014 12:45:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 2/2] qspinlock, x86: Enable x86-64 to use queue spinlock
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com> <1390933151-1797-3-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1390933151-1797-3-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 01:19 PM, Waiman Long wrote:
> This patch makes the necessary changes at the x86 architecture
> specific layer to enable the use of queue spinlock for x86-64. As
> x86-32 machines are typically not multi-socket. The benefit of queue
> spinlock may not be apparent. So queue spinlock is not enabled.
>
> Currently, there is some incompatibilities between the para-virtualized
> spinlock code (which hard-codes the use of ticket spinlock) and the
> queue spinlock. Therefore, the use of queue spinlock is disabled when
> the para-virtualized spinlock is enabled.
>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Acked-by: Rik van Riel <riel@redhat.com>

