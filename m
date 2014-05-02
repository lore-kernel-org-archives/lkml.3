Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaEBSGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:06:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:7530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaEBSGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:06:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="533773555"
Subject: Re: [PATCH] rwsem: Comments to explain the meaning of the rwsem's
 count field
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Shi <alex.shi@linaro.org>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1398969532.4884.1.camel@buesod1.americas.hpqcorp.net>
References: <1398966637.2970.129.camel@schen9-DESK>
	 <1398969532.4884.1.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 May 2014 11:05:59 -0700
Message-ID: <1399053959.2970.145.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-01 at 11:38 -0700, Davidlohr Bueso wrote:
> On Thu, 2014-05-01 at 10:50 -0700, Tim Chen wrote:
> > It takes me a while to understand how rwsem's count field mainifest
> > itself in different scenarios.  I'm adding comments to provide a quick
> > reference on the the rwsem's count field for each scenario where readers
> > and writers are contending/holding the lock.  Hopefully it will be useful
> > for future maintenance of the code and for people to get up to speed on
> > how the logic in the code works.
> 
> Agreed, this is nice to have. I'm planning on sending a minor set of
> patches for rwsem once the optistic spinning stuff is taken. To simplify
> things, I can take this in the series and resend along with the others.

I'm fine with whichever way is more convenient for Peter or Ingo.

Thanks.

Tim



