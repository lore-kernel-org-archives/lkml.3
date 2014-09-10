Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaIJKNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:13:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaIJKND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:13:03 -0400
Date: Wed, 10 Sep 2014 12:12:59 +0200
From: Jan Kara <jack@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 0/5 v2] x86/nmi: Print all cpu stacks from NMI safely
Message-ID: <20140910101259.GA27702@quack.suse.cz>
References: <20140626214901.596791200@goodmis.org>
 <alpine.LNX.2.00.1408071034450.6219@pobox.suse.cz>
 <20140808144412.1357dd05@gandalf.local.home>
 <alpine.LNX.2.00.1409101006000.5523@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1409101006000.5523@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-09-14 10:08:02, Jiri Kosina wrote:
> On Fri, 8 Aug 2014, Steven Rostedt wrote:
> 
> > > > This is my proposal to print the NMI stack traces from an RCU stall safely.
> > > > Here's the gist of it.
> > > 
> > > Steven, what's your plan with this patchset please? 
> > 
> > Has there been consensus on this approach?
> 
> From what I heard, the kernel summit workshop seems to have reached that 
> conclusion; I was unfortunately unable to attend it due to another 
> discussion I was interested in happening at the same time -- Jan Kara was 
> there, so I believe he can provide all the details if necessary.
  Yes, we briefly talked about printk from NMI and noone was objecting to
Steven's solution.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
