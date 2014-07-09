Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaGIRN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:13:58 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:38066 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756556AbaGIRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:13:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2916:3138:3139:3140:3141
X-HE-Tag: class19_4d0661943706
X-Filterd-Recvd-Size: 1986
Message-ID: <1404926030.932.122.camel@joe-AO725>
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
From: Joe Perches <joe@perches.com>
To: josh@joshtriplett.org
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Date: Wed, 09 Jul 2014 10:13:50 -0700
In-Reply-To: <20140709170039.GA15426@cloud>
References: <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140708080908.GN19379@twins.programming.kicks-ass.net>
	 <1404842784.932.22.camel@joe-AO725>
	 <20140708204124.GW4603@linux.vnet.ibm.com>
	 <1404853264.932.52.camel@joe-AO725>
	 <20140708215229.GA4603@linux.vnet.ibm.com>
	 <1404857116.932.68.camel@joe-AO725>
	 <20140708222557.GF4603@linux.vnet.ibm.com>
	 <1404878965.932.87.camel@joe-AO725> <20140709170039.GA15426@cloud>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 10:00 -0700, josh@joshtriplett.org wrote:
> On Tue, Jul 08, 2014 at 09:09:25PM -0700, Joe Perches wrote:
[]
> > I wrote a script to find which maintainer addresses that
> > haven't signed or authored a commit in the last 2 years.
> 
> Did you count Acked-by or Reviewed-by lines as maintainer activity as
> well?

Yes.

Anything other than a cc: line counted as activity.


