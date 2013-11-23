Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3KWGxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 01:53:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:6903 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab3KWGxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 01:53:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,757,1378882800"; 
   d="scan'208";a="432532557"
Message-ID: <1385189573.29354.198.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH 1/5] futex: Misc cleanups
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Date: Fri, 22 Nov 2013 22:52:53 -0800
In-Reply-To: <1385168197-8612-2-git-send-email-davidlohr@hp.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385168197-8612-2-git-send-email-davidlohr@hp.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 16:56 -0800, Davidlohr Bueso wrote:
> From: Jason Low <jason.low2@hp.com>
> 
> - Remove unnecessary head variables.
> - Delete unused parameter in queue_unlock().
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Scott Norton <scott.norton@hp.com>
> Cc: Tom Vaden <tom.vaden@hp.com>
> Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> Cc: Waiman Long <Waiman.Long@hp.com>
> Signed-off-by: Jason Low <jason.low2@hp.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

My concern was that we saved off head for a reason, but the hb lock is
held in these cases, and the call is safe against removal, so I don't
see a problem. Thanks.

Reviewed-by: Darren Hart <dvhart@linux.intel.com>

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


