Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaHGIlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:41:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbaHGIlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:41:50 -0400
Date: Thu, 7 Aug 2014 10:41:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 0/5 v2] x86/nmi: Print all cpu stacks from NMI
 safely
In-Reply-To: <20140626214901.596791200@goodmis.org>
Message-ID: <alpine.LNX.2.00.1408071034450.6219@pobox.suse.cz>
References: <20140626214901.596791200@goodmis.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Steven Rostedt wrote:

> This is version 2:
> 
> This is my proposal to print the NMI stack traces from an RCU stall safely.
> Here's the gist of it.

Steven, what's your plan with this patchset please? 

It has been tested by Petr here on the systems under the loads that are 
able to trigger the hangs.

It'd be nice to have this in 3.17, so that we can then start working on 
fixing all the remaining printk() calls in NMI context once this biggest 
offender (stack dumping) is done.

Thanks,

-- 
Jiri Kosina
SUSE Labs
