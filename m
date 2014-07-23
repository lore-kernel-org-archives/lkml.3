Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbaGWHw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:52:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:35762 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbaGWHwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:52:23 -0400
Date: Wed, 23 Jul 2014 09:52:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Message-ID: <20140723075219.GQ3935@laptop>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
 <8761iq3bp3.fsf@tassilo.jf.intel.com>
 <1406091303.5076.33.camel@marge.simpson.net>
 <20140723065736.GM3935@laptop>
 <1406100346.5076.98.camel@marge.simpson.net>
 <20140723073518.GP3935@laptop>
 <1406101143.5076.100.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406101143.5076.100.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:39:03AM +0200, Mike Galbraith wrote:
> On Wed, 2014-07-23 at 09:35 +0200, Peter Zijlstra wrote: 
> > On Wed, Jul 23, 2014 at 09:25:46AM +0200, Mike Galbraith wrote:
> > > I also resurrect mwait_idle(), as while you may consider it obsolete, I
> > > still love my lovely little Q6600 box (power sucking pig) dearly :)
> > 
> > Yeah, I keep forgetting about that one.. we should get that fixed.
> 
> (it is an obsolete pig, and nobody else seems to mind, so I don't mind)

Hey, I fixed early P4 topology setup yesterday, core2 is like brand
spanking new compared :-)
