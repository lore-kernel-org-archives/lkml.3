Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaFCVqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:46:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:17830 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750734AbaFCVqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:46:34 -0400
Date: Tue, 3 Jun 2014 17:46:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, josh@joshtriplett.org,
        Joe Perches <joe@perches.com>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140603174631.2de89352@gandalf.local.home>
In-Reply-To: <20140603205253.GC25483@thunk.org>
References: <20140602185504.GA13569@cloud>
	<1401735917.7323.23.camel@joe-AO725>
	<20140602190951.GA13648@cloud>
	<1401736666.7323.25.camel@joe-AO725>
	<20140602231949.GV14410@dastard>
	<20140602235915.GB14801@cloud>
	<20140603011125.GW14410@dastard>
	<20140602213045.26219ddb@gandalf.local.home>
	<20140603071654.GC14410@dastard>
	<20140603134347.6e39f946@gandalf.local.home>
	<20140603205253.GC25483@thunk.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 16:52:53 -0400
Theodore Ts'o <tytso@mit.edu> wrote:


> The important thing to note here is that we do not have consensus
> across all subsystems what Reviewed-by: means, and I think that's OK.
> The Reviewed-by: is mostly of interest to the maintainer before the
> patch is submitted to mainline.  The value of keeping it in the git
> commit logs after the fact seems to be a bit variable, although if
> there are companies blindly using it as a performance metric and this
> is driving down the quality of reviews, perhaps one could even argue
> that including these tags in the git commit logs is actually adding
> negative value.  But I don't really care about that issue, because
> like most maintainers, I know the reviewers by reputation, and whether
> someone actually says "you can add my Reviewed-by" is actually not so
> important as their comments on the patch, one way or another.

I prefer the Reviewed-by tags in the git commit. If something is
screwed up in a commit, I can blame the reviewers just as much as I can
blame the author :-)


-- Steve
