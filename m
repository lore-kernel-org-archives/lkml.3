Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab3ECOkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:40:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:62581 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933652Ab3ECOfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:35:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,605,1363158000"; 
   d="scan'208";a="297105456"
Date: Fri, 3 May 2013 07:35:07 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 1/3] perf, x86: Blacklist all MEM_*_RETIRED events for IVB
Message-ID: <20130503143507.GP19487@tassilo.jf.intel.com>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.083340271@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503121256.083340271@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 02:11:23PM +0200, Peter Zijlstra wrote:
> Errata BV98 states that all MEM_*_RETIRED events corrupt the counter
> value of the SMT sibling's counters. Blacklist these events

I disagree with this patch. This is just overkill and not needed
at all.

-Andi
