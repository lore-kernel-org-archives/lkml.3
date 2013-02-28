Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3B1I3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:29:33 -0500
Received: from mout.gmx.net ([212.227.15.15]:51968 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab3B1I3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:29:32 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2013 03:29:32 EST
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/3sHYdlsn3AL1BAKzZsjz1V7AE4ITK4Zl1Bh+PPr
	DIkyiGPcgFczT7
Message-ID: <1362039862.4460.132.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: wakeup buddy
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 28 Feb 2013 09:24:22 +0100
In-Reply-To: <512F11E6.8060807@linux.vnet.ibm.com>
References: <512EFB4B.5040204@linux.vnet.ibm.com>
	 <1362035917.4460.105.camel@marge.simpson.net>
	 <512F09D4.1020307@linux.vnet.ibm.com>
	 <1362038652.4460.124.camel@marge.simpson.net>
	 <512F11E6.8060807@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 16:14 +0800, Michael Wang wrote: 
> On 02/28/2013 04:04 PM, Mike Galbraith wrote:

> > It would be nice if it _were_ a promise, but it is not, it's a hint.
> 
> Bad to know :(
> 
> Should we fix it or this is by designed? The comments after WF_SYNC
> cheated me...

You can't fix it, because it's not busted.  You can say "Ok guys, I'm
off for a nap RSN" all you want, but that won't guarantee that nobody
pokes you, and hands you something more useful to do than snoozing.

-Mike  

