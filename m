Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaIDPky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:40:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaIDPkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:40:52 -0400
Date: Thu, 4 Sep 2014 17:40:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: mingo@redhat.com, Kirill Tkhai <tkhai@yandex.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>
Subject: Re: [RFC] smt-aware rt load balancer
Message-ID: <20140904154050.GG346@worktop.programming.kicks-ass.net>
References: <77161409833206@webcorp01h.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77161409833206@webcorp01h.yandex-team.ru>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 04:20:06PM +0400, Roman Gushchin wrote:
> Hello!
> 
> We had an earlier discussion about using real-time policies on modern CPUs
> for cpu-bound tasks with "near real-time" execution time expectations (like front-end servers):
> https://lkml.org/lkml/2014/4/24/602 .
> 
> I sad, that I had a prototype of real-time load balancer (called smart), that performs well in this case.
> 
> Now it's ready to be published.
> 
> The patch set on top of the 3.10.x branch can be found here:
> https://github.com/yandex/smart .
> 
> It's stable.
> We use them in production for a couple of months on more than thousand machines.
> We get noticeable performance increase for many projects with different load patterns
> (up to 10-15% in both RPS and latency).
> 
> Any feedback, comments, questions are welcome!

-ENOPATCH
