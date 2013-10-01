Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3JAHb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 03:31:27 -0400
Received: from one.firstfloor.org ([193.170.194.197]:55947 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3JAHb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 03:31:26 -0400
Date: Tue, 1 Oct 2013 09:31:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, acma@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, jolsa@redhat.com
Subject: Re: perf, x86: Add last TSX PMU code for Haswell v3
Message-ID: <20131001073124.GF6931@two.firstfloor.org>
References: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
 <20131001072203.GJ3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001072203.GJ3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 09:22:03AM +0200, Peter Zijlstra wrote:
> On Mon, Sep 30, 2013 at 02:58:57PM -0700, Andi Kleen wrote:
> > [This has kernel and user parts.
> > Both sides have been reviewed now, so hopefully it's good
> > to merge.]
> > [v2: Address Peter's feedback for the kernel parts]
> > [v3: Rebased to current tip. Added Ack/Reviewed-by for user tools code]
> 
> I merged your previous version yesterday; and did the rebase to current
> tip as that was a trivial one; I added Jolsa's ack.
> 
> Did I miss anything?

Sorry I missed that.  No change other than acks/rebase,
so the previous version should be fine. Thanks.

Outstanding TSX patches i have now (unless someone merged them):

perf stat -T 

https://lkml.org/lkml/2013/8/21/667

Was acked by Arnaldo

64bit comparison fix without that the abort code reporting with 
the abort code in the high 32bit doesn't work.

https://lkml.org/lkml/2013/9/27/569

Acked by Namyoung.

If someone could take care of those that would be great.

Thanks.


-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
