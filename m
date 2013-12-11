Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3LKSxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:53:14 -0500
Received: from one.firstfloor.org ([193.170.194.197]:42915 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3LKSxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:53:13 -0500
Date: Wed, 11 Dec 2013 19:53:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: andi@firstfloor.org, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: perf: hsw model numbers
Message-ID: <20131211185310.GJ21717@two.firstfloor.org>
References: <20131211103631.GJ13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211103631.GJ13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you add comments with each model number describing what actual part
> it is?

It would probably be confusing, they have lots of different marketing
names :/ Just think of them as some flavour of Haswell.

> 
> Also, we seem to lack snb/ivb EX part numbers, are those already known?

They are the same as respective EP (and there is no SNB-EX)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
