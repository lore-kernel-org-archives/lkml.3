Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3CVMht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:37:49 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35466 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab3CVMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130321215235.546600507@linutronix.de>
References: <20130321214930.752934102@linutronix.de>
	<20130321215235.546600507@linutronix.de>
Date: Fri, 22 Mar 2013 16:37:45 +0400
Message-ID: <CAMo8BfLQSieZpUvWL=yLDh4KgM1LboWRy79_MKbOW38nw_Q8tw@mail.gmail.com>
Subject: Re: [patch 34/34] xtensa: Use generic idle loop
From: Max Filippov <jcmvbkbc@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 1:53 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Unfortunately this arch does not compile at all :(

Hi Thomas,

according to KISSKB http://kisskb.ellerman.id.au/kisskb/compiler/19/
it does, you probably don't need to build allmodconfig.

With this patch I see WARN coming from the kernel/cpu/idle.c:94,
xtensa __platform_idle returns with interrupts enabled.
Interestingly, even the default arch_cpu_idle does so.

-- 
Thanks.
-- Max
