Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaIHSUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:20:44 -0400
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:45707 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbaIHSUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:20:43 -0400
Date: Mon, 8 Sep 2014 13:20:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
In-Reply-To: <20140904193248.GK5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409081317050.29829@gentwo.org>
References: <20140903021152.GA14069@linux.vnet.ibm.com> <alpine.DEB.2.11.1409030846310.9372@gentwo.org> <20140903144349.GT5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409031043540.24085@gentwo.org> <20140903171409.GZ5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031226001.24691@gentwo.org> <20140903181931.GB5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409040944220.4565@gentwo.org> <20140904161629.GF5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409041303250.14314@gentwo.org>
 <20140904193248.GK5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Sep 2014, Paul E. McKenney wrote:

> The lglocks use should be of particular interest to you.  See above to
> find the others.

Well the other seem to be in drivers.

> Understood, but no hasty changes to that part of RCU.

At our age I think we have learned to be very deliberate and slow.

> rcu: Use DEFINE_PER_CPU_SHARED_ALIGNED for rcu_data

Reviewed-by: Christoph Lameter <cl@linux.com>
