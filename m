Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946087Ab3FUVN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:13:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:32949 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945954Ab3FUVN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:13:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,915,1363158000"; 
   d="scan'208";a="333556069"
Message-ID: <51C4C215.2040705@linux.intel.com>
Date: Fri, 21 Jun 2013 14:13:57 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
References: <1371835898.18733.122.camel@gandalf.local.home> <1371848976.18733.130.camel@gandalf.local.home>
In-Reply-To: <1371848976.18733.130.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 02:09 PM, Steven Rostedt wrote:
> Call Trace:
>  [<ffffffff8103539d>] do_fork+0xa8/0x260
>  [<ffffffff810ca7b1>] ? trace_preempt_on+0x2a/0x2f
>  [<ffffffff812afb3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f

This bit of the call chain seems a little odd, no?

	-hpa


