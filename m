Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab3KENV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:21:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45460 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3KENV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:21:56 -0500
Message-ID: <5278F0E2.9040906@canonical.com>
Date: Tue, 05 Nov 2013 14:21:38 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, airlied@gmail.com,
        walken@google.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 0/8] Move locking primitives into kernel/locking/
References: <20131105105244.666320103@infradead.org> <20131105081838.27c7fcd4@gandalf.local.home>
In-Reply-To: <20131105081838.27c7fcd4@gandalf.local.home>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 05-11-13 14:18, Steven Rostedt schreef:
> On Tue, 05 Nov 2013 13:10:44 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
>
>> Hi all,
>>
>> During Kernel Summit Dave mentioned that there wasn't a clear maintainer for
>> locking bits.
>>
>> To remedy this Ingo suggested gathering all the various locking primitives and
>> lockdep into a single place: kernel/locking/.
>>
>> I would further like to propose a MAINTAINERS entry like:
>>
>> LOCKING
>> M:      Ingo Molnar <mingo@redhat.com>
>> M:      Peter Zijlstra <peterz@infradead.org>
>> M:	Oleg Nesterov <oleg@redhat.com>
>> M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> M:	Linus Torvalds <torvalds@linux-foundation.org>
>> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking/core
>> S:      Maintained
>> F:      kernel/locking/
> I wonder if it should be called kernel/locks, as that's less to type,
> smaller path names, and tastes good on bagels.
>
> -- Steve
>
Congratulations! You're our early bikeshed winner for today. Please pick your favorite color at http://bikeshed.com
