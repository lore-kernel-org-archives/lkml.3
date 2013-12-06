Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab3LFOyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:54:49 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56260 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab3LFOyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:54:47 -0500
Date: Fri, 6 Dec 2013 06:54:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20131206145441.GA24148@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
 <20130818180232.GL29406@linux.vnet.ibm.com>
 <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
 <20130909222751.GL3966@linux.vnet.ibm.com>
 <20130914112834.GM1509@pompeji.miese-zwerge.org>
 <20130923164931.GC2322@pompeji.miese-zwerge.org>
 <20131206002614.GD15492@linux.vnet.ibm.com>
 <20131206135804.GI2208@pompeji.miese-zwerge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206135804.GI2208@pompeji.miese-zwerge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120614-3532-0000-0000-0000039CB27B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 02:58:04PM +0100, Jochen Striepe wrote:
> 	Hi again,
> 
> On Thu, Dec 05, 2013 at 04:26:14PM -0800, Paul E. McKenney wrote:
> > Hmmm...  Does the following patch help?
> [...]
> > rcu: Kick CPU halfway to RCU CPU stall warning
> 
> The stall didn't appear at all since my last email, running 3.12.x
> kernels since release. But I will test your patch later today. I assume
> applying on top of 3.12.3 is correct?

3.12.3 should take that patch just fine.

							Thanx, Paul

