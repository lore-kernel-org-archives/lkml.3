Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3GHIVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:21:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59187 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3GHIVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:21:16 -0400
Date: Mon, 8 Jul 2013 10:21:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
Message-ID: <20130708082106.GW23916@twins.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373179405.19316.41.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 07, 2013 at 08:43:25AM +0200, Mike Galbraith wrote:
> On Fri, 2013-07-05 at 14:16 +0800, Michael Wang wrote:
> 
> > PeterZ has suggested some optimization which I sent out yesterday, I
> > suppose they haven't been included into this test yet, correct?
> 
> No, that was with both v3 patches applied.  hackbench -l 1000 delta
> tracked to next pull/build fwiw, but I don't see anything noteworthy
> elsewhere, so I'm filing it under "tasks/core ~= zillion ~= hohum".

OK, I'll apply the patches, we'll see what happens. If there significant
fallout we'll immediately have more information anyway ;-)
