Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3KEVYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:24:46 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48531 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab3KEVYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:24:45 -0500
MIME-Version: 1.0
In-Reply-To: <20131105212029.GT28601@twins.programming.kicks-ass.net>
References: <20131105105244.666320103@infradead.org>
	<20131105110026.878790658@infradead.org>
	<CANN689EVEQUXUm9Nwu=-Gzr85tkMPVOEFWX=8dQQ3WbqfyZy5w@mail.gmail.com>
	<20131105212029.GT28601@twins.programming.kicks-ass.net>
Date: Tue, 5 Nov 2013 13:24:44 -0800
Message-ID: <CANN689FKEy3cc9EGOViY-kev1hJ-8DR1RB_4hya0jkJfahSQug@mail.gmail.com>
Subject: Re: [RFC 1/8] locking: Move mutex into kernel/locking/
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 1:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> This is probably a stupid question, but I haven't been able to find
>> one kernel version that this applies cleanly over ???
>
> Oh my bad, it appears I made it against a working tree, not an actual
> published tree. That said, I don't think the rejects should be super
> hard to fix.
>
> If people don't object to the idea I'll respin against something
> published and testable.

Yes please.

The reason I want to apply this is because code moves cause noisy
patches, and the easiest way I know to fully figure them out is to
diff them against a private tree where I have moved the same files
(yeah, there really ought to be a better way, ....)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
