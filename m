Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaAPRmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:42:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:63292 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750750AbaAPRmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:42:09 -0500
Date: Thu, 16 Jan 2014 12:42:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH 0/2] preempt: Track unmatched preempt_enable() to
 preempt_disable()
Message-ID: <20140116124207.2065b153@gandalf.local.home>
In-Reply-To: <20140116171824.748919700@goodmis.org>
References: <20140116171824.748919700@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 12:18:24 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Back in the original real-time patch there was a nice debug feature
> that tracked where preemption was disabled and not matched by a preempt
> enable. This information made debugging scheduling while atomic much
> easier, especially when a function was buried in a function chain
> that happened just before the schedule. For example:
> 

> Although this bug does not happen often, this feature is extremely helpful
> when it does. I decided to take Ingo's code, which was just written for
> debugging the -rt patch, and clean it up for something that is suitable
> for mainline.
> 

Hmm, I rewrote this prologue a few times, and even though patch 2 states
this, I want to make it clear that the original feature, that this is
based on, was written by Ingo Molnar. I had it clear in my original
version of the prologue, but somehow it was deleted.

-- Steve
