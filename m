Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaIJNNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:13:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:50311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaIJNNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:13:05 -0400
Date: Wed, 10 Sep 2014 15:12:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andreea-Cristina Bernat <bernat.ada@gmail.com>, paulus@samba.org,
        mingo@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: events: core: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140910131251.GZ4783@worktop.ger.corp.intel.com>
References: <20140822132605.GA20130@ada>
 <20140909094235.GD19379@twins.programming.kicks-ass.net>
 <20140909161648.GE4704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909161648.GE4704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 09:16:48AM -0700, Paul E. McKenney wrote:
> On Tue, Sep 09, 2014 at 11:42:35AM +0200, Peter Zijlstra wrote:

> > Paul, why not do something like the below and do away with all this
> > nonsense?
> 
> We used to do that, but the compilers became uncooperative, despite
> Stephen Hemminger's best efforts.

Happen to have a link handy to that thread so I can educate myself?
