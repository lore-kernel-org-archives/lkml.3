Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaKFKp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:45:26 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKFKpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:45:22 -0500
Date: Thu, 6 Nov 2014 11:45:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, fengguang.wu@intel.com,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>, pjt@google.com,
        bsegall@google.com, rafael.j.wysocki@intel.com
Subject: Re: [LKP] [sched] kernel BUG at kernel/smpboot.c:134!
Message-ID: <20141106104513.GS10501@worktop.programming.kicks-ass.net>
References: <20141104042922.GM27038@yliu-dev.sh.intel.com>
 <20141105180758.GA19218@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105180758.GA19218@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 02:07:58AM +0800, Yuyang Du wrote:
> Hi Peter and Thomas,
> 
> LKP found a bug, and it was bisected to my rewrite patch:
> http://article.gmane.org/gmane.linux.kernel/1818393/
> 
> But I really don't have a clue about why the patch can introduce
> such a bug, as the patch does not modify anything related. Or maybe
> the bug could be indirectly triggerd, just don't know how.
> 
> To confirm it is not a false positive, we are rebasing the patch to
> 3.18-rc3 to try to reproduce it, it is now ongoing.
> 
> In addition, I noticed this thread about the same symptom:
> http://thread.gmane.org/gmane.linux.kernel/1819348.
> 
> Thomas should already have a fix to this. Right?

Not quite; see https://lkml.org/lkml/2014/6/26/554

Let me read that thread though, maybe I can make sense of it.
