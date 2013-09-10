Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3IJIAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:00:15 -0400
Received: from oker.escape.de ([194.120.234.254]:48378 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab3IJIAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:00:13 -0400
Date: Tue, 10 Sep 2013 09:45:50 +0200
From: Jochen Striepe <jochen@tolot.escape.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20130910074550.GE17483@pompeji.miese-zwerge.org>
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

	Hello,

On Mon, Sep 09, 2013 at 03:27:51PM -0700, Paul E. McKenney wrote:
> On Mon, Sep 09, 2013 at 11:58:36PM +0200, Jochen Striepe wrote:
> > I just got this on 3.10.11 on the same machine. Could that be
> > related?
> 
> Several people helped track down another source of spurious stall
> warnings on large systems, please see below for the patch.
[...]
> This is quite rare, but apparently occurs deterministically
> on systems with about 6TB of memory.

Hmm. My system is an ASUS Eee PC netbook with a total of 2G memory.
The latest stall was just when booting, while /dev was to be filled
by udev (and taking a really long time on that). So I think this
patch should not help at my machine, right?

I tried to reproduce the stall, but without success. Is there anything
that could help reproducing?

Best greetings,
Jochen.
