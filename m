Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3IKKpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:45:15 -0400
Received: from oker.escape.de ([194.120.234.254]:46906 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab3IKKpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:45:12 -0400
Date: Wed, 11 Sep 2013 12:34:31 +0200
From: Jochen Striepe <jochen@tolot.escape.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20130911103430.GA1509@pompeji.miese-zwerge.org>
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
 <20130818180232.GL29406@linux.vnet.ibm.com>
 <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
 <20130909222751.GL3966@linux.vnet.ibm.com>
 <20130910074550.GE17483@pompeji.miese-zwerge.org>
 <20130910175453.GQ3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910175453.GQ3966@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

On Tue, Sep 10, 2013 at 10:54:53AM -0700, Paul E. McKenney wrote:
> Their stall was due to old-style creation of sysfs entries for memory.
> Yours might be having a similar issue with the creation of /dev entries,
> so it would be worth trying it.

OK, compiling 3.10.11 with your patch right now.

> One thing to try would be to insert delays into the code involved in
> creating the /dev entries.  These delays will need to be busy-waits
> rather than sleeps.

Uh, I will have a look. But I'm no kernel developer. :)


Best greetings,
Jochen.
