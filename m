Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3L0SJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 13:09:06 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47074 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3L0SJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 13:09:03 -0500
Date: Fri, 27 Dec 2013 10:08:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20131227180850.GF19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130909222751.GL3966@linux.vnet.ibm.com>
 <20130914112834.GM1509@pompeji.miese-zwerge.org>
 <20130923164931.GC2322@pompeji.miese-zwerge.org>
 <20131206002614.GD15492@linux.vnet.ibm.com>
 <20131206135804.GI2208@pompeji.miese-zwerge.org>
 <20131206145441.GA24148@linux.vnet.ibm.com>
 <20131210112257.GJ2208@pompeji.miese-zwerge.org>
 <20131216224006.GA5919@linux.vnet.ibm.com>
 <20131222022523.GD26013@pompeji.miese-zwerge.org>
 <20131227171507.GE26013@pompeji.miese-zwerge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131227171507.GE26013@pompeji.miese-zwerge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122718-1344-0000-0000-000004791079
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 06:15:07PM +0100, Jochen Striepe wrote:
> 	Hi,
> 
> On Sun, Dec 22, 2013 at 03:25:23AM +0100, Jochen Striepe wrote:
> > Applies, compiles, and runs smoothly on top of 3.12.6. I'll send word
> > if anything odd shows up.
> 
> Tested with various loads, everything nice and working so far.

Thank you for your testing efforts!

							Thanx, Paul

