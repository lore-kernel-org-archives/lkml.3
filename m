Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3HTDWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:22:37 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38776 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab3HTDWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:22:36 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 19 Aug 2013 20:22:22 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Update RTFP documentation
Message-ID: <20130820032222.GB4416@leaf>
References: <20130820023717.GA29357@linux.vnet.ibm.com>
 <1376966267-29949-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376966267-29949-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376966267-29949-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 07:37:46PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Note that this commit also updates the formatting of serveral of the
> bibtex entries to conform to that of my .bib files.  I started
> accumulating entries back in the 1980s, back when bibtex insisted
> that comma (",") was a separator, not a terminator.  This rule forced
> commas to the fronts of lines.  25 years later, bibtex allows commas
> to be terminators, but I am too lazy to rework all my .bib files.
> Keeping the same format as my .bib files allows my to simply
> incorporate my RCU.bib file into Documentation/RCU/RTFP.txt, which
> is much easier than my earlier practice of keeping track of what
> had changed and adding individual entries.  (I sometimes find relevant
> papers that were published some years back, for example.)
> 
> In addition, this change adds entries for papers published in the
> last year or so.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
