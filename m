Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbaFDADV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 20:03:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:56414 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933860AbaFDADT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 20:03:19 -0400
Date: Tue, 3 Jun 2014 20:03:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Joe Perches <joe@perches.com>, josh@joshtriplett.org,
        Dave Chinner <david@fromorbit.com>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140603200316.00fa3674@gandalf.local.home>
In-Reply-To: <20140603234816.GB26144@milliways>
References: <20140602181658.GX22231@linux.vnet.ibm.com>
	<1401734669.7323.20.camel@joe-AO725>
	<20140602145020.400d4e0c@gandalf.local.home>
	<20140602185504.GA13569@cloud>
	<1401735917.7323.23.camel@joe-AO725>
	<20140602190951.GA13648@cloud>
	<1401736666.7323.25.camel@joe-AO725>
	<20140602231949.GV14410@dastard>
	<20140602235915.GB14801@cloud>
	<1401754325.7323.50.camel@joe-AO725>
	<20140603234816.GB26144@milliways>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 00:48:16 +0100
Ken Moffat <zarniwhoop@ntlworld.com> wrote:

>  This is _often_ not like userspace programs where you can write a
> testsuite to exercise the corner cases.  Kernel problems can be
> tied up with intricate details of the hardware, or equally they
> might happen only for certain usage, and for those it might not be
> at all obvious what is "special" about the affected usage.

Very true. Most of the Tested-by: tags I give is for one of my older
boxes that triggers bugs that none of my other boxes do. Can't really
add a test case for that. If only I could insert my test box into the
git repository :-/

-- Steve

