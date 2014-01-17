Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaAQFKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:10:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQFKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:10:05 -0500
Date: Thu, 16 Jan 2014 21:12:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH] preempt: Debug for possible missed preemption
 checks
Message-Id: <20140116211214.581197e5.akpm@linux-foundation.org>
In-Reply-To: <20140116235751.084728c8@gandalf.local.home>
References: <20140116235751.084728c8@gandalf.local.home>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 23:57:51 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> When PROVE_LOCKING and PREEMPT is configured, the preempt state
> tracking is active. Testing this out, I added a module that did the
> following:

So I assume your kernel at least has no instances of this bug, so we
don't need the patch ;) It *is* a fairly daft thing to do.

Maybe stick it in -next for a few months, see if anyone hits it?
