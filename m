Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaCSJ6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:58:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56355 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254AbaCSJ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:58:49 -0400
Date: Wed, 19 Mar 2014 10:58:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH 2/4] hrtimer: export __hrtimer_start_range_ns
Message-ID: <20140319095829.GG27632@laptop.programming.kicks-ass.net>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
 <1395133004-23205-2-git-send-email-zheng.z.yan@intel.com>
 <20140319084710.GD27632@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.02.1403191053220.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403191053220.18573@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 10:53:34AM +0100, Thomas Gleixner wrote:
> On Wed, 19 Mar 2014, Peter Zijlstra wrote:
> 
> > On Tue, Mar 18, 2014 at 04:56:42PM +0800, Yan, Zheng wrote:
> > > export __hrtimer_start_range_ns() to allow building perf Intel uncore
> > > driver as module
> > 
> > Bah; you didn't cc the hrtimer maintainer.
> > 
> > Thomas, ack on this?
> 
> Yup.

Thanks!
