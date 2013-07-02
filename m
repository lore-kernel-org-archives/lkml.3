Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3GBFyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:54:54 -0400
Received: from mout.gmx.net ([212.227.15.19]:62486 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab3GBFyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:54:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX198XwsYRoF82wT4XSUUHztqO82dvNby9zKZbiW50v
	6iZXacrUeS7qzF
Message-ID: <1372744486.7363.133.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Tue, 02 Jul 2013 07:54:46 +0200
In-Reply-To: <51D25A80.8090406@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51D25A80.8090406@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 12:43 +0800, Michael Wang wrote: 
> Since RFC:
> 	Tested again with the latest tip 3.10.0-rc7.
> 
> wake-affine stuff is always trying to pull wakee close to waker, by theory,
> this will bring benefit if waker's cpu cached hot data for wakee, or the
> extreme ping-pong case.
> 
> And testing show it could benefit hackbench 15% at most.

How much does this still help with Alex's patches integrated?

aside: were I a maintainer, I'd be a little concerned that what this
helps with collides somewhat with the ongoing numa work.

-Mike

