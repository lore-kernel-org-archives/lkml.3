Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3EXSrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 14:47:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39581 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3EXSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 14:47:50 -0400
Date: Fri, 24 May 2013 20:47:27 +0200
From: Jens Axboe <axboe@kernel.dk>
To: OS Engineering <osengineering@stec-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Padmini Balasubramaniyan <padminib@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: Re: EnhanceIO(TM) caching driver features [1/3]
Message-ID: <20130524184727.GQ29680@kernel.dk>
References: <A44CB407BBB85C498149811C52498A450872D9@MYMBX3.stec-inc.ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A44CB407BBB85C498149811C52498A450872D9@MYMBX3.stec-inc.ad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24 2013, OS Engineering wrote:
> Hi Jens and Kernel Gurus,

[snip]

Thanks for writing all of this up, but I'm afraid it misses the point
somewhat. As stated previously, we have (now) two existing competing
implementations in the kernel. I'm looking for justification on why YOUR
solution is better. A writeup and documentation on error handling
details is nice and all, but it doesn't answer the key important
questions.

Lets say somebody sends in a patch that he/she claims improves memory
management performance. To justify such a patch (or any patch, really),
the maintenance burden vs performance benefit needs to be quantified.
Such a person had better supply a set of before and after numbers, such
that the benefit can be quantified.

It's really the same with your solution. You mention "the solution has
been proven in independent testing, such as testing by Demartek.". I
have no idea what this testing is, what they ran, compared with, etc.

So, to put it bluntly, I need to see some numbers. Run relevant
workloads on EnhanceIO, bcache, dm-cache. Show why EnhanceIO is better.
Then we can decide whether it really is the superior solution. Or,
perhaps, it turns out there are inefficiencies in eg bcache/dm-cache
that could be fixed up.

Usually I'm not such a stickler for including new code. But a new driver
is different than EnhanceIO. If somebody submitted a patch to add a
newly written driver for hw that we already have a driver for, that
would be similar situation.

The executive summary: your writeup was good, but we need some relevant
numbers to look at too.

-- 
Jens Axboe

