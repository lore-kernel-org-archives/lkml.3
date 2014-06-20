Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaFTPip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:38:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48844 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbaFTPio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:38:44 -0400
Date: Fri, 20 Jun 2014 08:38:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: josh@joshtriplett.org, Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140620153839.GB4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140619014200.GO8178@tassilo.jf.intel.com>
 <alpine.DEB.2.11.1406190941180.2785@gentwo.org>
 <20140619180916.GE4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191531020.4002@gentwo.org>
 <20140619204220.GJ4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191612000.5484@gentwo.org>
 <alpine.DEB.2.11.1406191614270.5484@gentwo.org>
 <20140619213203.GA16747@cloud>
 <20140619230732.GX4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406201019430.10810@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406201019430.10810@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062015-1344-0000-0000-00000252F101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:20:36AM -0500, Christoph Lameter wrote:
> On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> 
> > I am putting together patches based on Eric Dumazet's suggestion and on a
> > variant of the above approach.  However, I do expect the distros to starve
> > to death between those two bales of hay.  But perhaps the actual patches
> > will inspire a bit of light to go with this thread's heat and smoke.
> 
> Yep. Note that the large systems are only a few and the smaller systems
> are many. You are penalizing the overwhelming majority for support of a
> few systems.

And the fraction of the small systems that care that much about latency
is also quite small.

Of course, if you have performance results that show otherwise, please
share them.

							Thanx, Paul

