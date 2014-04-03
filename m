Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaDCWhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:37:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaDCWhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:37:11 -0400
Date: Thu, 3 Apr 2014 18:37:00 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140403223700.GA18353@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140401153032.GT4284@linux.vnet.ibm.com>
 <20140401172244.GA10363@redhat.com>
 <20140401175545.GV4284@linux.vnet.ibm.com>
 <20140401180414.GA12326@redhat.com>
 <20140401183245.GA12473@linux.vnet.ibm.com>
 <20140402162043.GA11090@linux.vnet.ibm.com>
 <20140402224840.GA5385@redhat.com>
 <20140403200143.GA8119@redhat.com>
 <20140403204656.GI4284@linux.vnet.ibm.com>
 <20140403214430.GA20249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403214430.GA20249@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 05:44:30PM -0400, Dave Jones wrote:
 > On Thu, Apr 03, 2014 at 01:46:56PM -0700, Paul E. McKenney wrote:
 >  > 	git merge anti-fixes
 >  > 
 >  > Then bisect through these reverts.
 >  > 
 >  > I am assuming, perhaps naively, that changes under Documentation and
 >  > to torture testing should not be affecting you.
 >  > 
 >  > Does this make sense?
 > 
 > I tried reverting every one of those and could still hit it, which
 > seems to indicate the bug is elsewhere, and rcu is just a victim of it.
 > I'm going to start trying to revert the lockdep changes, given this seems
 > to happen after that has warned..

And that was also without any success.
Tomorrow I'll try a bisect on just arch/x86.

	Dave

