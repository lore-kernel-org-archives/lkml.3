Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3GWIis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:38:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35299 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3GWIip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:38:45 -0400
Date: Tue, 23 Jul 2013 10:38:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, eranian@google.com
Subject: Re: [PATCH] perf, x86: Enable PEBS mode automatically for
 mem-{loads,stores} v3
Message-ID: <20130723083834.GS27075@twins.programming.kicks-ass.net>
References: <1374188619-19220-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374188619-19220-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 04:03:39PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> [The patch to enable this in the user tools has been sent separately]
> 
> With the earlier patches to automatically try cpu// and add
> a precise sys attribute, we can now enable PEBS for the mem-loads,
> mem-stores events everywhere.
> 
> This allows to use
> 
> perf record -e mem-loads ...
> 
> instead of
> 
> perf record -e cpu/mem-loads/p ...
> 
> Always use precise=2 even though it is costly pre-Haswell

This Changelog fails to give a reason _why_ we'd want to do this.
