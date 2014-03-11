Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaCKDrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 23:47:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:22154 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753845AbaCKDrN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 23:47:13 -0400
Date: Mon, 10 Mar 2014 23:47:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fernando Luis =?UTF-8?B?VsOhenF1ZXo=?= Cao 
	<fernando_b1@lab.ntt.co.jp>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/clock: prevent tracing recursion in
 sched_clock_cpu()
Message-ID: <20140310234706.3faf282b@gandalf.local.home>
In-Reply-To: <531D66FE.20703@lab.ntt.co.jp>
References: <1394083528.4524.3.camel@nexus>
	<20140306055113.2306397d@gandalf.local.home>
	<531D66FE.20703@lab.ntt.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 16:17:18 +0900
Fernando Luis Vázquez Cao <fernando_b1@lab.ntt.co.jp> wrote:


> Thank you four your review, Peter, Steven.
> 
> By the way, who is going to pick this patch? Do you want
> me to resend with Steven's Acked-by added?

I don't think you have to. I believe Peter got it. I know there's a
bunch of patches he's trying to get pushed forward.

-- Steve
