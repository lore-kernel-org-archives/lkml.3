Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3JDIal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:30:41 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57095 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3JDIai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:30:38 -0400
Date: Fri, 4 Oct 2013 10:30:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [pchecks v2 0/2] percpu v3: Implement Preemption checks for
 __this_cpu operations
Message-ID: <20131004083033.GA1658@gmail.com>
References: <000001417f93f8eb-802d2cf9-29b6-46b7-975e-b909a5c17783-000000@email.amazonses.com>
 <20131004081807.GF3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004081807.GF3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> User-Agent: quilt/0.50-1
> 
> You might want to upgrade your quilt the latest version is 0.60-1 and
> there's talk of actually releasing something newer.

Another technical problem with the submission is the lack of 'PATCH' tags 
for the patches - it's the standard and ther are folks search lkml based 
on that pattern.

See Documentation/SubmittingPatches:

 | 11) Include PATCH in the subject
 |
 | Due to high e-mail traffic to Linus, and to linux-kernel, it is common 
 | convention to prefix your subject line with [PATCH].  This lets Linus 
 | and other kernel developers more easily distinguish patches from other 
 | e-mail discussions.

Note that all of the technical problems we noted need to be fixed before 
the next resubmission, not just some.

Thanks,

	Ingo
