Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3GHIuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:50:12 -0400
Received: from mout.gmx.net ([212.227.17.20]:62967 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab3GHIuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:50:11 -0400
Message-ID: <1373273368.30325.7.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Mon, 08 Jul 2013 10:49:28 +0200
In-Reply-To: <20130708082106.GW23916@twins.programming.kicks-ass.net>
References: <51D29EE5.8080307@linux.vnet.ibm.com>
	 <20130704091339.GK18898@dyad.programming.kicks-ass.net>
	 <51D5428D.7080805@linux.vnet.ibm.com>
	 <1372934013.9046.16.camel@marge.simpson.net>
	 <51D633DB.5010508@linux.vnet.ibm.com>
	 <1372997318.7315.23.camel@marge.simpson.net>
	 <51D64C84.5080100@linux.vnet.ibm.com>
	 <1373002865.8318.11.camel@marge.simpson.net>
	 <51D664B9.7010407@linux.vnet.ibm.com>
	 <1373179405.19316.41.camel@marge.simpson.net>
	 <20130708082106.GW23916@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:NUtLpfRQ2rceNcyoPImeGX50znykMsNO1YRWVuMkdtssGTryF3S
 Y7dhg1r1G9tC0/eCMTjKOvLgXovunb4FhY/mDclTMBSRtnemmRU9xSkKNy4GIVy07SJBlkg
 1f/0SSbOufNHbcNYbPGV96xXgBJWTMmL7kg5aE7Yhssj3EEag4mZqb7nVpCDjE64qzHtj2I
 hQZnfAYAm2c6N7KMprFNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 10:21 +0200, Peter Zijlstra wrote: 
> On Sun, Jul 07, 2013 at 08:43:25AM +0200, Mike Galbraith wrote:
> > On Fri, 2013-07-05 at 14:16 +0800, Michael Wang wrote:
> > 
> > > PeterZ has suggested some optimization which I sent out yesterday, I
> > > suppose they haven't been included into this test yet, correct?
> > 
> > No, that was with both v3 patches applied.  hackbench -l 1000 delta
> > tracked to next pull/build fwiw, but I don't see anything noteworthy
> > elsewhere, so I'm filing it under "tasks/core ~= zillion ~= hohum".
> 
> OK, I'll apply the patches, we'll see what happens. If there significant
> fallout we'll immediately have more information anyway ;-)

Yup.  It's a repeatable oddity on my box, but it doesn't even track to
itself when using different hackbench parameters.  All I can really
conclude from test results is "golly, changing stuff affects stuff" :) 

-Mike

