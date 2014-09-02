Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaIBRRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:17:06 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51077 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaIBRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:17:03 -0400
Date: Tue, 2 Sep 2014 10:16:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [percpu] BUG: unable to handle kernel NULL pointer dereference
 at (null)
Message-ID: <20140902171657.GG5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140902045830.GA11321@localhost>
 <20140902153403.GY5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021052400.10607@gentwo.org>
 <20140902162110.GB5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021155410.10607@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409021155410.10607@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090217-6688-0000-0000-00000474F3C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:55:58AM -0500, Christoph Lameter wrote:
> On Tue, 2 Sep 2014, Paul E. McKenney wrote:
> 
> > Added by ac1bea85781e (sched,rcu: Make cond_resched() report RCU quiescent
> > states), removed by 4a81e8328d379 (rcu: Reduce overhead of cond_resched()
> > checks for RCU).  So, as you say, no effect on contemporary kernels.
> 
> Well not sure what to make out of all of this....

Yep, still confused as to how the patch adding the definition could have
caused a failure.  Fengguang, any thoughts?

							Thanx, Paul

