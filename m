Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab3GGGns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 02:43:48 -0400
Received: from mout.gmx.net ([212.227.17.21]:56368 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab3GGGnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 02:43:47 -0400
Message-ID: <1373179405.19316.41.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Sun, 07 Jul 2013 08:43:25 +0200
In-Reply-To: <51D664B9.7010407@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51D25A80.8090406@linux.vnet.ibm.com>
	 <20130702085202.GA23916@twins.programming.kicks-ass.net>
	 <51D29EE5.8080307@linux.vnet.ibm.com>
	 <20130704091339.GK18898@dyad.programming.kicks-ass.net>
	 <51D5428D.7080805@linux.vnet.ibm.com>
	 <1372934013.9046.16.camel@marge.simpson.net>
	 <51D633DB.5010508@linux.vnet.ibm.com>
	 <1372997318.7315.23.camel@marge.simpson.net>
	 <51D64C84.5080100@linux.vnet.ibm.com>
	 <1373002865.8318.11.camel@marge.simpson.net>
	 <51D664B9.7010407@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:njLwq4yHLNrIu7sRjEFIv2AT92HBUtXI4eixOEvrWkP76YA1ez2
 yO0nJ7LNg1+UQLpfDzOVr6EPNUOv7/oMf/Ny2eQ5LiVwz4V7oPBKKtwYQnypFgTSRdFgTVm
 g5Sbjo6s3MkBZ93VfU/hWdrBGtHRiQ6XgJbFB7fo3EySIZQbwltfRnMa3Ug3cvi2gUJH2VK
 aTZhMtDEnOgjqxyCaQOOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-05 at 14:16 +0800, Michael Wang wrote:

> PeterZ has suggested some optimization which I sent out yesterday, I
> suppose they haven't been included into this test yet, correct?

No, that was with both v3 patches applied.  hackbench -l 1000 delta
tracked to next pull/build fwiw, but I don't see anything noteworthy
elsewhere, so I'm filing it under "tasks/core ~= zillion ~= hohum".

-Mike

