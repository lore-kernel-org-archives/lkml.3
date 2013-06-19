Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852Ab3FSOaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:30:55 -0400
Received: from a10-63.smtp-out.amazonses.com ([54.240.10.63]:36590 "EHLO
	a10-63.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934417Ab3FSOay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:30:54 -0400
X-Greylist: delayed 706 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jun 2013 10:30:54 EDT
Date: Wed, 19 Jun 2013 14:19:06 +0000
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <liljegren.mats2@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Full dynticks selftests 0.0.1
In-Reply-To: <20130618181733.GS5146@linux.vnet.ibm.com>
Message-ID: <0000013f5ccd9d66-616fef8f-7cf1-45ec-bd20-b1fed9264cbe-000000@email.amazonses.com>
References: <20130612151915.GD5332@somewhere> <0000013f57a89d51-89f08a58-65d0-41f5-aaaa-b31d60c72a8e-000000@email.amazonses.com> <20130618151520.GP5146@linux.vnet.ibm.com> <20130618162256.GH17619@somewhere.redhat.com>
 <20130618181733.GS5146@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.19-54.240.10.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Paul E. McKenney wrote:

> +online to handle timekeeping tasks in order to ensure that system
> +calls like gettimeofday() returns accurate values on adaptive-tick CPUs.
> +(This is not an issue for CONFIG_NO_HZ_IDLE=y because there are no running
> +user processes to observe slight drifts in clock rate.)  Therefore, the
> +boot CPU is prohibited from entering adaptive-ticks mode.  Specifying a
> +"nohz_full=" mask that includes the boot CPU will result in a boot-time
> +error message, and the boot CPU will be removed from the mask.  Note that
> +this means that your system must have at least two CPUs in order for
> +CONFIG_NO_HZ_FULL=y to do anything for you.

These are some important point here. Very good. Thanks.

