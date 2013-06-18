Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab3FROUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:20:41 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:53307 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932884Ab3FROUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:20:37 -0400
Date: Tue, 18 Jun 2013 14:20:35 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <liljegren.mats2@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Full dynticks selftests 0.0.1
In-Reply-To: <20130612151915.GD5332@somewhere>
Message-ID: <0000013f57a89d51-89f08a58-65d0-41f5-aaaa-b31d60c72a8e-000000@email.amazonses.com>
References: <20130612151915.GD5332@somewhere>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.18-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, Frederic Weisbecker wrote:

> Here it is, a very basic test that runs a userspace loop for ten seconds and dumps a trace
> of the tick, scheduler, workqueue, and other kind of kernel noise.

Excellent. Ticks are finally off here. Also has useful instructions on how
to figure out if something was wrong. The number of >1 microsecond
disturbances went down from 110 per second to 2.
