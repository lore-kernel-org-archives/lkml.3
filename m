Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaCMIxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:53:47 -0400
Received: from [143.182.124.37] ([143.182.124.37]:9497 "EHLO mga14.intel.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753192AbaCMIxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:53:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,645,1389772800"; 
   d="scan'208";a="491107460"
Date: Thu, 13 Mar 2014 16:53:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [sched/balance] INFO: possible recursive locking detected
Message-ID: <20140313085341.GC27627@localhost>
References: <20140303142526.GA8517@localhost>
 <5321618F.3090801@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5321618F.3090801@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 03:43:11PM +0800, Alex Shi wrote:
> On 03/03/2014 10:25 PM, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > https://github.com/alexshi/power-scheduling.git single-balance.bak
> > commit 2adc591a5cb6768ad11e63be9011906aa171148d
> > Author:     Alex Shi <alex.shi@linaro.org>
> > AuthorDate: Fri Feb 28 15:25:09 2014 +0800
> > Commit:     Alex Shi <alex.shi@linaro.org>
> > CommitDate: Sun Mar 2 09:16:38 2014 +0800
> > 
> >     sched/balance: replace new_idle_balance
> >     
> >     Curren idle_balance will pull task on half of this group. That is
> >     not needed in central balance.
> 
> 
> Thanks for your testing, Fengguang!
> 
> I fixed this issue and updated to the git tree. Is the single-balance
> branch still in your performance radar? :)

Sure, however you know it's costly to queue tests for one single tree.
If your trees are directly based on -rcX kernels, that would cut the
tests required for comparison by half.

Thanks,
Fengguang
