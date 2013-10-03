Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3JCH0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:26:09 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:35808 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3JCH0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:26:08 -0400
Date: Thu, 3 Oct 2013 09:26:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131003072603.GB5775@gmail.com>
References: <20130924154159.855373283@linux.com>
 <0000014150a21408-2d759c49-6a9e-4553-956f-2d4b53e710f8-000000@email.amazonses.com>
 <20130924171029.GB10261@gmail.com>
 <0000014155fdd6cf-d54da8b8-2198-40ce-8831-4559971e69f0-000000@email.amazonses.com>
 <20130925181146.GA16693@gmail.com>
 <000001415fb34afc-79a24112-5d3f-431c-b90c-d6cfa1caf27a-000000@email.amazonses.com>
 <20130928083952.GB26167@gmail.com>
 <0000014179b908eb-29821dc1-7b08-4dd5-b86b-a88c00864249-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014179b908eb-29821dc1-7b08-4dd5-b86b-a88c00864249-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> > > That is exactly what this patch does. There will only be warning if 
> > > the user enabled them.
> >
> > You didn't understand me apparently: all warnings that trigger with 
> > the debug CONFIG option enabled must be fixed before this can be sent 
> > upstream.
> 
> This patchset is required to determine the warnings that will be 
> triggered and to get the work to address these issues done. The feedback 
> so far indicates that there may be lots of discussions regarding the 
> warnings that have been discovered so far. Its not realistic to do this 
> in one go.

Please submit them once you had the time to ensure that they are ready and 
produce no warnings on your system(s) with debugging enabled.

To help out I can stage them for you in a branch within the scheduler tree 
if you think there are spurious warnings - as long as you fix and address 
any bug reports and review feedback received in a timely fashion. I'll 
send it upstream once the debug code has settled down and doesn't produce 
false warnings.

Also, just to make it clear, as I mentioned it in my previous mail: until 
the debug code becomes upstream worthy and converge, consider all your 
__this_cpu patches NAK-ed by me.

Thanks,

	Ingo
