Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaJWVmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:42:45 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41686 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaJWVmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:42:44 -0400
Date: Thu, 23 Oct 2014 14:38:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023213850.GH4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141013173504.GA27955@redhat.com>
 <20141023183232.GW4977@linux.vnet.ibm.com>
 <20141023191319.GA5137@redhat.com>
 <20141023193807.GZ4977@linux.vnet.ibm.com>
 <20141023195337.GA7768@redhat.com>
 <20141023202443.GE4977@linux.vnet.ibm.com>
 <20141023211304.GA10813@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023211304.GA10813@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102321-0029-0000-0000-000000DCE137
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 11:13:04PM +0200, Oleg Nesterov wrote:
> On 10/23, Paul E. McKenney wrote:
> >
> > Your code, your rules.  ;-)
> 
> Heh, no. I do not trust my (perverted) taste, I never-never
> argue with cosmetic issues ;)
> 
> Cough... and at the same time I have a small nit.

;-) ;-) ;-)

> > But given this structure, why not use a for() loop replace the
> > "goto retry" with an inverted condition and a "return error"?
> > Maybe something like the following patch?
> 
> Thanks,
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>

Got it, thank you!

							Thanx, Paul

