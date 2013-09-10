Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3IJVRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:17:05 -0400
Received: from a14-78.smtp-out.amazonses.com ([54.240.14.78]:35113 "EHLO
	a14-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab3IJVRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:17:03 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2013 17:17:03 EDT
Date: Tue, 10 Sep 2013 21:11:01 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Rob Landley <rob@landley.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <1378798756.8385.24@driftwood>
Message-ID: <0000014109b69026-f9c6e053-c813-4573-bb13-1d2bb37320c2-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com> <1378798756.8385.24@driftwood>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.10-54.240.14.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Rob Landley wrote:

> On 09/05/2013 03:07:37 PM, Christoph Lameter wrote:
> > I am not sure how to call this kernel option but we need something like
> > that. I see drivers and the kernel spawning processes on the nohz cores.
> > The name kthread is not really catching the purpose.
>
> Can't you just use the CPU affinity of PID 1 for this? Since it's a process
> that's always there and already has a mask and all. No need for a new
> interface...

How would you set the affinity of pid 1 before init starts spawning
threads?

