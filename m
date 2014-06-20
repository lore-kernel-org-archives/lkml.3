Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880AbaFTQaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:30:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60675 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbaFTQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:30:28 -0400
Date: Fri, 20 Jun 2014 09:30:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: josh@joshtriplett.org, Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140620163023.GE4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140619180916.GE4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191531020.4002@gentwo.org>
 <20140619204220.GJ4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191612000.5484@gentwo.org>
 <alpine.DEB.2.11.1406191614270.5484@gentwo.org>
 <20140619213203.GA16747@cloud>
 <20140619230732.GX4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406201019430.10810@gentwo.org>
 <20140620153839.GB4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406201106010.11238@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406201106010.11238@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062016-1542-0000-0000-000002B5E55F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:07:13AM -0500, Christoph Lameter wrote:
> On Fri, 20 Jun 2014, Paul E. McKenney wrote:
> 
> > And the fraction of the small systems that care that much about latency
> > is also quite small.
> 
> This also impacts general performance of course not only latency.
> 
> > Of course, if you have performance results that show otherwise, please
> > share them.
> 
> We are discussing a performance problem right here.

We are engaging in a lot of -speculation- about an -alleged- performance
problem.  I have posted a fix to the actual performance problem, but the
guy reporting the original report of that problem has not yet reported
the performance of the fix.  Which is fine, as I am getting ready to
post an updated fix, and besides which he might well have higher-priority
tasks requiring his attention.  But without that performance information,
we are all just engaging in baseless speculation.

							Thanx, Paul

