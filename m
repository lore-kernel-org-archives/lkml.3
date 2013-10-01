Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3JAIEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:04:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3JAIEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:04:33 -0400
Date: Tue, 1 Oct 2013 10:04:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acma@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        jolsa@redhat.com
Subject: Re: perf, x86: Add last TSX PMU code for Haswell v3
Message-ID: <20131001080412.GK3081@twins.programming.kicks-ass.net>
References: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
 <20131001072203.GJ3081@twins.programming.kicks-ass.net>
 <20131001073124.GF6931@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001073124.GF6931@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 09:31:24AM +0200, Andi Kleen wrote:
> Sorry I missed that.  No change other than acks/rebase,
> so the previous version should be fine. Thanks.

Yeah, I didn't mail out and it hasn't landed it -tip yet. So you
couldn't have known.

> Outstanding TSX patches i have now (unless someone merged them):
> 
> perf stat -T 
> 
> https://lkml.org/lkml/2013/8/21/667
> 
> Was acked by Arnaldo
> 
> 64bit comparison fix without that the abort code reporting with 
> the abort code in the high 32bit doesn't work.
> 
> https://lkml.org/lkml/2013/9/27/569
> 
> Acked by Namyoung.

Both are tools patches; I'll see if I can get acme to pick them up; if
not I'll pick them up.
