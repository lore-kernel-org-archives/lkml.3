Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332AbaFCXsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:48:21 -0400
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:41601
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbaFCXsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:48:20 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=FZq5xfO6 c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=stjsFTeFptUA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=dT1Wy2BCr5avlHYHrYgA:9
 a=QEXdDO2ut3YA:10
Date: Wed, 4 Jun 2014 00:48:16 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Joe Perches <joe@perches.com>
Cc: josh@joshtriplett.org, Dave Chinner <david@fromorbit.com>,
        Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140603234816.GB26144@milliways>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401754325.7323.50.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 05:12:05PM -0700, Joe Perches wrote:
> 
> "Tested-by:" tags would be more helpful if the test
> cases that were used were somehow sent along with the
> signature.
> 
 To me, that seems either a perverse, or else a bureaucratic,
interpretation of what should go where.

 Tested-by is usually used for a fix of some problem, often a
regression.  A good commit message will explain the problem.  I have
recently offered this tag in two cases - in the first case it did
not boot without the fix, in the second it did not wake up from
suspend.  In each case, only one of my boxes was affected.  Do you
think I should have insisted that some of my lspci -V information
was appended to the commit (they both affected the radeon code) if
my tag was going to be added ?

 This is _often_ not like userspace programs where you can write a
testsuite to exercise the corner cases.  Kernel problems can be
tied up with intricate details of the hardware, or equally they
might happen only for certain usage, and for those it might not be
at all obvious what is "special" about the affected usage.

ĸen
-- 
Nanny Ogg usually went to bed early. After all, she was an old lady.
Sometimes she went to bed as early as 6 a.m.
