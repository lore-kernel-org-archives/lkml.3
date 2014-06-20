Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaFTPUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:20:40 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:44269
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbaFTPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:20:39 -0400
Date: Fri, 20 Jun 2014 10:20:36 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: josh@joshtriplett.org, Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
In-Reply-To: <20140619230732.GX4904@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406201019430.10810@gentwo.org>
References: <20140618203052.GT4669@linux.vnet.ibm.com> <20140618235131.GA25946@linux.vnet.ibm.com> <20140619014200.GO8178@tassilo.jf.intel.com> <alpine.DEB.2.11.1406190941180.2785@gentwo.org> <20140619180916.GE4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191531020.4002@gentwo.org> <20140619204220.GJ4904@linux.vnet.ibm.com> <alpine.DEB.2.11.1406191612000.5484@gentwo.org> <alpine.DEB.2.11.1406191614270.5484@gentwo.org> <20140619213203.GA16747@cloud>
 <20140619230732.GX4904@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Paul E. McKenney wrote:

> I am putting together patches based on Eric Dumazet's suggestion and on a
> variant of the above approach.  However, I do expect the distros to starve
> to death between those two bales of hay.  But perhaps the actual patches
> will inspire a bit of light to go with this thread's heat and smoke.

Yep. Note that the large systems are only a few and the smaller systems
are many. You are penalizing the overwhelming majority for support of a
few systems.

