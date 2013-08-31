Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3HaPm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 11:42:26 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36053 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab3HaPmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 11:42:25 -0400
Date: Sat, 31 Aug 2013 17:42:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        mingo@kernel.org, acme@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] perf, x86: Avoid checkpointed counters causing
 excessive TSX aborts v4
Message-ID: <20130831154223.GD19750@two.firstfloor.org>
References: <1377128846-977-1-git-send-email-andi@firstfloor.org>
 <1377128846-977-2-git-send-email-andi@firstfloor.org>
 <20130830160215.GU31370@twins.programming.kicks-ass.net>
 <20130830204445.GF16724@tassilo.jf.intel.com>
 <20130831150755.GY31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831150755.GY31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So can just drop the XXX comment. Ok?
> 
> How about hiding the entire thing in a hsw function. I'm fairly sure
> that eventually we'll need to check all counters for this nonsense.

AFAIK there are no plans to do so.

> 
> Something like so perhaps?

It's ok for me, except it's not for TSX (that's intx), but only for
intx_checkpointed.

Should I send a new patch?

-Andi
