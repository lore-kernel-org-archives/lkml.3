Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaFCAMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:12:15 -0400
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:33730 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753207AbaFCAML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:12:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:282
X-HE-Tag: map25_2f8847cb46648
X-Filterd-Recvd-Size: 2081
Message-ID: <1401754325.7323.50.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: josh@joshtriplett.org
Cc: Dave Chinner <david@fromorbit.com>, Steven Rostedt <rostedt@goodmis.org>,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 17:12:05 -0700
In-Reply-To: <20140602235915.GB14801@cloud>
References: <20140602174837.GA13257@cloud>
	 <1401731968.7323.4.camel@joe-AO725>
	 <20140602181658.GX22231@linux.vnet.ibm.com>
	 <1401734669.7323.20.camel@joe-AO725>
	 <20140602145020.400d4e0c@gandalf.local.home> <20140602185504.GA13569@cloud>
	 <1401735917.7323.23.camel@joe-AO725> <20140602190951.GA13648@cloud>
	 <1401736666.7323.25.camel@joe-AO725> <20140602231949.GV14410@dastard>
	 <20140602235915.GB14801@cloud>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 16:59 -0700, josh@joshtriplett.org wrote:
> Acked-by and Reviewed-by mean two different things (Reviewed-by being a
> superset of Acked-by), and the difference is not "I've applied and
> tested this"; that's Tested-by.

I think the standards for every signature tag other
than Signed-off-by: should be _much_ higher than they
are and that most all uses of "Acked-by:" and
"Reviewed-by:" tags are for vanity.

"Tested-by:" tags would be more helpful if the test
cases that were used were somehow sent along with the
signature.


