Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaAVMhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:37:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54024 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaAVMhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:37:01 -0500
Date: Wed, 22 Jan 2014 13:36:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: tip/master show soft lockup while running multiple
 VM
Message-ID: <20140122123643.GO31570@twins.programming.kicks-ass.net>
References: <52DF8101.6020903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DF8101.6020903@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 04:27:45PM +0800, Michael wang wrote:
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set

Could you try the patch here:

  lkml.kernel.org/r/20140122102435.GH31570@twins.programming.kicks-ass.net

I suspect its the same issue.
