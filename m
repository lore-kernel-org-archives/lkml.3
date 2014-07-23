Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbaGWHjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:39:10 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62929 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaGWHjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:39:08 -0400
Message-ID: <1406101143.5076.100.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Date: Wed, 23 Jul 2014 09:39:03 +0200
In-Reply-To: <20140723073518.GP3935@laptop>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	 <8761iq3bp3.fsf@tassilo.jf.intel.com>
	 <1406091303.5076.33.camel@marge.simpson.net> <20140723065736.GM3935@laptop>
	 <1406100346.5076.98.camel@marge.simpson.net> <20140723073518.GP3935@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 09:35 +0200, Peter Zijlstra wrote: 
> On Wed, Jul 23, 2014 at 09:25:46AM +0200, Mike Galbraith wrote:
> > I also resurrect mwait_idle(), as while you may consider it obsolete, I
> > still love my lovely little Q6600 box (power sucking pig) dearly :)
> 
> Yeah, I keep forgetting about that one.. we should get that fixed.

(it is an obsolete pig, and nobody else seems to mind, so I don't mind)

