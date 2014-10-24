Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbaJXJLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:11:50 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:47933 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaJXJLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:11:48 -0400
Date: Fri, 24 Oct 2014 10:11:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] futex: Mention key referencing differences between
 shared and private futexes
Message-ID: <20141024091137.GB20534@e104818-lin.cambridge.arm.com>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
 <1414121220.817.0.camel@linux-t7sj.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414121220.817.0.camel@linux-t7sj.site>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 04:27:00AM +0100, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@stgolabs.net>
> 
> Update our documentation as of fix 76835b0ebf8 (futex: Ensure
> get_futex_key_refs() always implies a barrier). Explicitly
> state that we don't do key referencing for private futexes.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Looks fine to me.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.
