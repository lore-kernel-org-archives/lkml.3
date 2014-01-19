Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaASBI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 20:08:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:31876 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751539AbaASBIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 20:08:24 -0500
Date: Sat, 18 Jan 2014 20:08:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH] preempt: Debug for possible missed preemption
 checks
Message-ID: <20140118200822.5d41ffce@gandalf.local.home>
In-Reply-To: <20140119115253.d6974d9c188c6d9e88d04b80@canb.auug.org.au>
References: <20140116235751.084728c8@gandalf.local.home>
	<20140116211214.581197e5.akpm@linux-foundation.org>
	<20140118184401.48b32cb3@gandalf.local.home>
	<20140119115253.d6974d9c188c6d9e88d04b80@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jan 2014 11:52:53 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Given that the merge window will probably open today or tomorrow, I would
> prefer any new code not intended for 3.14 not be added to linux-next
> until after v3.14-rc1 to avoid unneeded conflicts.  If, however, Andrew
> thinks it is still worth the (maybe minimal) pain, then fine.

I'm not sure this is even intended for 3.15 either ;-)

I'm fine with waiting, to keep from adding any extra pain just before a
merge window. I guess the question is, is it OK to keep it in
linux-next for 3.15 even though it may not even go into 3.15?  Depends
on how useful it proves to be. Perhaps it may require staying in
linux-next till 3.16.

Perhaps in order to keep merge windows from being an issue, I can add it
at each -rc1, and remove it at -rc6, if it didn't catch any bugs. But as
soon as it does catch a bug, we can say it's worth going into mainline.

Does that sound fine with you?

-- Steve
