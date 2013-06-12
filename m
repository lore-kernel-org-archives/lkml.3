Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3FLPe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:34:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab3FLPe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:34:57 -0400
Date: Wed, 12 Jun 2013 11:34:07 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: rcu_preempt running flat out on idle desktop.
Message-ID: <20130612153407.GA21842@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>
References: <20130508203042.GA18895@redhat.com>
 <CAFTL4hwB3XZG+C9pQ0JD4h=n_ObNH6mCBRfLW3JaxohwwRDWRA@mail.gmail.com>
 <20130509211026.GA22723@redhat.com>
 <20130514012105.GB12749@somewhere>
 <20130606153136.GA12823@redhat.com>
 <20130606154311.GA5688@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606154311.GA5688@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 05:43:13PM +0200, Frederic Weisbecker wrote:

 > > Every process 200% or 0%.
 > 
 > I see, would you mind testing this branch?
 > 
 > git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
 > 	timers/urgent
 > 
 > It might help, I specially think about 45eacc692771bd2b1ea3d384e6345cab3da10861
 > ("vtime: Use consistent clocks among nohz accounting") which fixes an issue
 > with cputime accounting that resulted in similar symptoms.

So that patch has been in 'urgent' for a month. Can someone move it
to really-urgent or whatever is necessary to get it into Linus' tree ?

	DAve
