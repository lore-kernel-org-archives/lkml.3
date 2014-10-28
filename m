Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaJ1U0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:26:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43726 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbaJ1U0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:26:46 -0400
Date: Tue, 28 Oct 2014 13:22:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: hung tasks in 3.18.0-rc1-00221-gc3351df
Message-ID: <20141028202251.GZ5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.11.1410231619340.11555@adalberg.ut.ee>
 <20141024001822.GK4977@linux.vnet.ibm.com>
 <alpine.LRH.2.11.1410241057270.15464@adalberg.ut.ee>
 <20141024145509.GO4977@linux.vnet.ibm.com>
 <20141027174424.GB27568@linux.vnet.ibm.com>
 <alpine.LRH.2.11.1410281014530.6536@adalberg.ut.ee>
 <20141028124942.GN5718@linux.vnet.ibm.com>
 <alpine.LRH.2.11.1410282147310.19428@adalberg.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1410282147310.19428@adalberg.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102820-0029-0000-0000-000000F499C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:48:21PM +0200, Meelis Roos wrote:
> > > > rcu: Make rcu_barrier() understand about missing rcuo kthreads
> > > 
> > > I can not trigger the previous problem at will so my testing is not very 
> > > useful. I tested the previous patch that you sent but the problem did 
> > > not trigger, and yesterday applied this one and it still does not 
> > > trigger, but I an using remote sessions only for now (no desktop).
> > > 
> > > At least it's not clearly broken :)
> > 
> > A couple of other people had more reproducible test setups and confirmed
> > that it fixed them.
> > 
> > But yes, there are no doubt other RCU bugs waiting to be found.  ;-)
> 
> I reproduced the problem on Thinkpad T400 with Core2Duo and Chromium 
> startup failing, and your patch fixes that.
> 
> Tested-by: Meelis Roos <mroos@linux.ee>

Got it, thank you!!!

							Thanx, Paul

