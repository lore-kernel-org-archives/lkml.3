Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3BGTNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:13:53 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:57890 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016Ab3BGTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:13:51 -0500
Date: Thu, 7 Feb 2013 20:13:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
Message-ID: <20130207191345.GA28960@gmail.com>
References: <20130207094650.76302f47@riff.lan>
 <20130207185608.GA25223@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207185608.GA25223@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Yeah, that looks pretty good.
> 
> I'll give it some testing.

Found one build error so far, applied the fix below.

Thanks,

	Ingo

---
 kernel/mutex.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/kernel/mutex.c
===================================================================
--- linux.orig/kernel/mutex.c
+++ linux/kernel/mutex.c
@@ -19,6 +19,7 @@
  */
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>

