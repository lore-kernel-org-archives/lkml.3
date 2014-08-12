Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaHLORX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:17:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbaHLORW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:17:22 -0400
Date: Tue, 12 Aug 2014 16:17:19 +0200 (CEST)
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
In-Reply-To: <20140808144412.1357dd05@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1408121615220.15220@pobox.suse.cz>
References: <20140626214901.596791200@goodmis.org> <alpine.LNX.2.00.1408071034450.6219@pobox.suse.cz> <20140808144412.1357dd05@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014, Steven Rostedt wrote:

> > > This is version 2:
> > > 
> > > This is my proposal to print the NMI stack traces from an RCU stall safely.
> > > Here's the gist of it.
> > 
> > Steven, what's your plan with this patchset please? 
> 
> Has there been consensus on this approach?

Well, I don't think any better proposals have been brought up so far, all 
the other aproaches (including the one we brought up) were more intrusive, 
and the hang-in-NMI it fixes is real and simply has to be fixed.

Thanks,

-- 
Jiri Kosina
SUSE Labs
