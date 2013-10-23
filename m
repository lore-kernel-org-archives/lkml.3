Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3JWCPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:15:33 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41985 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3JWCPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:15:32 -0400
Date: Wed, 23 Oct 2013 04:15:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        mingo@kernel.org
Subject: Re: [PATCH 06/11] asmlinkage: Make trace_hardirq visible
Message-ID: <20131023021531.GH29695@two.firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
 <1382458346-24811-7-git-send-email-andi@firstfloor.org>
 <20131022201848.GC2490@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022201848.GC2490@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> $sub talks about asmlinkage, yet here you insert __visible; 'sup?

I use __visible for anything with arguments, because asmlinkage
changes the ABI from register to stack on i386.

I still used "asmlinkage" as the generic patch group name as that is more
descriptive, and "asmlinkage/visible" would look too ugly.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
