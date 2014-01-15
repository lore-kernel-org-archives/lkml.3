Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaAOMto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:49:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36378 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaAOMtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:49:41 -0500
Date: Wed, 15 Jan 2014 13:49:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [sched] d50dde5a1: LTP sched_setparam* TFAILs
Message-ID: <20140115124921.GE31570@twins.programming.kicks-ass.net>
References: <20140115124739.GB19419@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115124739.GB19419@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 08:47:39PM +0800, Fengguang Wu wrote:
> Hi Dario,
> 
> We notice the below LTP failures since commit d50dde5a1 ("sched: Add
> new scheduler syscalls to support an extended scheduling parameters
> ABI") in tip tree's sched/core branch:
> 
> ltp.sched_setparam02.1.TFAIL
> ltp.sched_setparam02.2.TFAIL
> ltp.sched_setparam02.3.TFAIL
> ltp.sched_setparam03.1.TFAIL
> 
> It seems that the LKP test failures are somehow expected due to the
> change of ABI. However it does mean that these test cases will need to
> be updated.

Nah, the old API should keep working. Lemme find where this LTP stuff
lives.
