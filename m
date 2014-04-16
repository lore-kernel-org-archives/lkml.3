Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaDPJWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:22:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56667 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaDPJWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:22:11 -0400
Date: Wed, 16 Apr 2014 11:21:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        ak@linux.intel.com, Steven Rostedt <rostedt@goodmis.org>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1857 at arch/x86/kernel/smp.c:124
Message-ID: <20140416092146.GQ11182@twins.programming.kicks-ass.net>
References: <534E49C8.7050206@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534E49C8.7050206@nod.at>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 11:13:44AM +0200, Richard Weinberger wrote:
> Hi!
> 
> On a new 8 core server I'm facing the following issue.
> After an oops a warning triggers.

I think its fair to ignore everything _after_ an OOPS ;-)
