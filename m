Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaDBAIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:08:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550AbaDBAII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:08:08 -0400
Date: Tue, 1 Apr 2014 20:07:58 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140402000758.GA1440@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140401150849.GA14757@redhat.com>
 <20140401153032.GT4284@linux.vnet.ibm.com>
 <20140401172244.GA10363@redhat.com>
 <20140401175545.GV4284@linux.vnet.ibm.com>
 <20140401180414.GA12326@redhat.com>
 <20140401183245.GA12473@linux.vnet.ibm.com>
 <20140401221616.GA961@redhat.com>
 <20140401231822.GC4284@linux.vnet.ibm.com>
 <20140401233130.GA25030@redhat.com>
 <20140401235724.GD4284@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401235724.GD4284@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 04:57:24PM -0700, Paul E. McKenney wrote:
 
 > > [  917.790265] INFO: rcu_preempt detected stalls on CPUs/tasks:
 > > [  917.791189] 	(detected by 0, t=6502 jiffies, g=21390, c=21389, q=0)
 > 
 > But the hang didn't happen until grace period #21390.  Sigh!  That means
 > that the trace doesn't tell me about the current grace period.
 > 
 > Thank you for getting this info, but it is beginning to look like
 > bisection is necessary here.  :-(

ok, I was hoping that wouldn't be the case, but let's see what it turns up.

	Dave

