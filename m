Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3JWLPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:15:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:48386 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752248Ab3JWLPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:15:15 -0400
Message-ID: <1382526910.5283.5.camel@pippen.local.home>
Subject: Re: [PATCH] kernel: context_tracking: use extern function instead
 of static inline function for user_enter/exit()
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, khilman@linaro.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Oct 2013 07:15:10 -0400
In-Reply-To: <5267AC7C.2040803@asianux.com>
References: <5267A72B.7060808@asianux.com>
	 <1382525244.5283.3.camel@pippen.local.home> <5267AC7C.2040803@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-23 at 19:01 +0800, Chen Gang wrote:

> > void arch_user_enter(void)
> > {
> > 	user_enter();
> > }
> > 
> 
> OK, thanks. That sounds reasonable to me. I will send related patch to
> arm guys. :-)

If you do so, don't call it "arch_user_enter()", maybe call it
"asm_user_enter()", as "arch_*" is something used to be called by the
generic code.  My mistake in using that as an example.

-- Steve


