Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbaEIRKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:10:39 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:40240 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757231AbaEIRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:10:35 -0400
Date: Fri, 9 May 2014 18:09:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: James Hogan <james.hogan@imgtec.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "umgwanakikbuti@gmail.com" <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC][PATCH 6/8] sched,idle: Avoid spurious wakeup IPIs
Message-ID: <20140509170946.GN7950@arm.com>
References: <20140411134243.160989490@infradead.org>
 <20140411135218.478299389@infradead.org>
 <CAAG0J9_q1KsUx10-XAb7AJnxv2ehctg6q1KME7ahsk1OZV8vZQ@mail.gmail.com>
 <20140509141520.GV2844@laptop.programming.kicks-ass.net>
 <20140509144034.GF7950@arm.com>
 <20140509145002.GW2844@laptop.programming.kicks-ass.net>
 <20140509145745.GI7950@arm.com>
 <20140509170234.GZ30445@twins.programming.kicks-ass.net>
 <20140509170649.GG13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509170649.GG13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 06:06:49PM +0100, Peter Zijlstra wrote:
> Subject: arm64: Remove TIF_POLLING_NRFLAG
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri May  9 19:04:00 CEST 2014
> 
> The only idle method for arm64 is WFI and it therefore
> unconditionally requires the reschedule interrupt when idle.
> 
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

There's a tag with my name already but just in case you need another:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.
