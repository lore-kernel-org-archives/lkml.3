Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891Ab3CHMix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:38:53 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34086 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3CHMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:38:52 -0500
MIME-Version: 1.0
In-Reply-To: <1362742582-26327-1-git-send-email-james.hogan@imgtec.com>
References: <1362742582-26327-1-git-send-email-james.hogan@imgtec.com>
Date: Fri, 8 Mar 2013 13:38:50 +0100
Message-ID: <CAFTL4hwdu2Xd2xjYcFU9npCDtCvMSi9j_84Z_pShxZ06QP+tow@mail.gmail.com>
Subject: Re: [PATCH 1/1] irq_work.h: fix warning when CONFIG_IRQ_WORK=n
From: Frederic Weisbecker <fweisbec@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/8 James Hogan <james.hogan@imgtec.com>:
> A randconfig caught repeated compiler warnings when CONFIG_IRQ_WORK=n
> due to the definition of a non-inline static function in
> <linux/irq_work.h>:
>
> include/linux/irq_work.h +40 : warning: 'irq_work_needs_cpu' defined but not used
>
> Make it inline to supress the warning. This is caused by the following
> commit:
>
> Commit 00b42959106a9ca1c2899e591ae4e9a83ad6af05 ("irq_work: Don't stop
> the tick with pending works") merged in v3.9-rc1.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied, thanks!
