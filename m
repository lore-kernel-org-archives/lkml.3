Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbaFCAfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:35:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:44654 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932833AbaFCAfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:35:07 -0400
Date: Mon, 2 Jun 2014 20:35:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Joe Perches <joe@perches.com>,
        josh@joshtriplett.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602203502.7aabf707@gandalf.local.home>
In-Reply-To: <20140602162424.e95a845a62d9a80d5d0ab605@linux-foundation.org>
References: <1401729778.5770.20.camel@joe-AO725>
	<20140602174837.GA13257@cloud>
	<1401731968.7323.4.camel@joe-AO725>
	<20140602181658.GX22231@linux.vnet.ibm.com>
	<1401734669.7323.20.camel@joe-AO725>
	<20140602145020.400d4e0c@gandalf.local.home>
	<20140602185504.GA13569@cloud>
	<1401735917.7323.23.camel@joe-AO725>
	<20140602190951.GA13648@cloud>
	<1401736666.7323.25.camel@joe-AO725>
	<20140602231949.GV14410@dastard>
	<20140602162424.e95a845a62d9a80d5d0ab605@linux-foundation.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014 16:24:24 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 3 Jun 2014 09:19:49 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > Anyone using Reviewed-by without having actually applied and tested
> > the patch is mis-using the tag
> 
> I think you just described 94.7% of Reviewed-by:s.

94.8%

/me me raises his hand in shame!


Yeah, to me Reviewed-by means that I agonized over the patch to
understand it as much as if I wrote it myself. But I honestly don't
always test it, or even compile it for that matter.

-- Steve
