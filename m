Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3INLaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 07:30:14 -0400
Received: from oker.escape.de ([194.120.234.254]:50215 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab3INLaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 07:30:12 -0400
Date: Sat, 14 Sep 2013 13:28:34 +0200
From: Jochen Striepe <jochen@tolot.escape.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20130914112834.GM1509@pompeji.miese-zwerge.org>
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
 <20130818180232.GL29406@linux.vnet.ibm.com>
 <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
 <20130909222751.GL3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909222751.GL3966@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello again,

On Mon, Sep 09, 2013 at 03:27:51PM -0700, Paul E. McKenney wrote:
> Several people helped track down another source of spurious stall
> warnings on large systems, please see below for the patch.
[...]
> ------------------------------------------------------------------------
> 
> rcu: Reject memory-order-induced stall-warning false positives

I run this patch on top of 3.10.11 vanilla since Wednesday, so far
without any further stalls, on light to heavy loads. Works smooth
as pie.

Tested-by: Jochen Striepe <jochen@tolot.escape.de>


Have a nice weekend and a big thank you,
Jochen.
