Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaIJWSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 18:18:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37399 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaIJWSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 18:18:34 -0400
Date: Wed, 10 Sep 2014 15:18:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
Message-ID: <20140910221828.GO4704@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140903144349.GT5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031043540.24085@gentwo.org>
 <20140903171409.GZ5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031226001.24691@gentwo.org>
 <20140903181931.GB5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409040944220.4565@gentwo.org>
 <20140904161629.GF5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409041303250.14314@gentwo.org>
 <20140904193248.GK5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409081317050.29829@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409081317050.29829@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091022-1542-0000-0000-000004B558EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 01:20:30PM -0500, Christoph Lameter wrote:
> 
> On Thu, 4 Sep 2014, Paul E. McKenney wrote:
> 
> > The lglocks use should be of particular interest to you.  See above to
> > find the others.
> 
> Well the other seem to be in drivers.

OK...

> > Understood, but no hasty changes to that part of RCU.
> 
> At our age I think we have learned to be very deliberate and slow.

And rcutorture needs some upgrades for this case.

> > rcu: Use DEFINE_PER_CPU_SHARED_ALIGNED for rcu_data
> 
> Reviewed-by: Christoph Lameter <cl@linux.com>

Thank you, recorded.

							Thanx, Paul

