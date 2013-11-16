Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3KPBVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 20:21:30 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:42683 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3KPBVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 20:21:23 -0500
Date: Fri, 15 Nov 2013 17:21:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 01/28] rcutorture: Add KVM-based test
 framework
Message-ID: <20131116012116.GZ4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131116010528.GA9112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131116010528.GA9112@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111601-3532-0000-0000-000003114CFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 05:05:28PM -0800, Greg KH wrote:
> On Fri, Nov 15, 2013 at 04:35:14PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > This commit adds the test framework that I used to test RCU under KVM.
> > This consists of a group of scripts and Kconfig fragments.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Greg KH <gregkh@linuxfoundation.org>
> 
> Yeah!  Thanks for following through on this, it will help me out a lot
> in testing stable kernels.

Glad you like it!  ;-)

> Oh, one very minor comment on the patches, you should delete the address
> of the FSF from your file headers, unless you want to track the office
> movements of them for the next 40+ years.  We've been removing them from
> kernel code where we notice them, as half of them are wrong, and I don't
> want to have to go back and fix them again when they move again.

I had no idea that they tend to move!  Thank you, I will remove them.

							Thanx, Paul

