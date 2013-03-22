Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab3CVOsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:48:33 -0400
Received: from a192-102.smtp-out.amazonses.com ([199.255.192.102]:19041 "EHLO
	a192-102.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733Ab3CVOsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:48:32 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 10:48:32 EDT
Date: Fri, 22 Mar 2013 14:38:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
In-Reply-To: <20130321205054.GI3637@linux.vnet.ibm.com>
Message-ID: <0000013d9289cebc-e6380265-3a74-4343-b851-765f785a3754-000000@email.amazonses.com>
References: <1363636794.15703.32@driftwood> <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com> <20130318222548.GG3656@linux.vnet.ibm.com> <1363822338.6345.33.camel@gandalf.local.home> <20130320235545.GL3637@linux.vnet.ibm.com>
 <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com> <20130321171518.GW3637@linux.vnet.ibm.com> <0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com> <20130321185821.GF3637@linux.vnet.ibm.com>
 <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com> <20130321205054.GI3637@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.192.102
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Paul E. McKenney wrote:

> So, how long of busy periods are you contemplating for your SCHED_FIFO
> threads?  Is it possible to tune/adjust the offending per-CPU ktheads
> to wake up less frequently than that time?

Test programs right now run 10 seconds. 30 seconds would definitely be
enough for the worst case.

