Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaBNQ3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:29:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49481 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:29:00 -0500
Date: Fri, 14 Feb 2014 17:28:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140214162854.GO27965@twins.programming.kicks-ass.net>
References: <52F51E10.8050208@linux.vnet.ibm.com>
 <20140207193604.GA8833@htj.dyndns.org>
 <52F8F0FB.3080206@linux.vnet.ibm.com>
 <20140210231742.GK25350@mtj.dyndns.org>
 <52FB90C6.4010701@linux.vnet.ibm.com>
 <52FC3C83.8020303@cn.fujitsu.com>
 <52FD07B2.5080402@linux.vnet.ibm.com>
 <20140213204102.GC17608@htj.dyndns.org>
 <20140214160923.GK27965@twins.programming.kicks-ass.net>
 <20140214162556.GF31544@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214162556.GF31544@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:25:56AM -0500, Tejun Heo wrote:
> Hey, we now even keep normal kthreads across cpu down/ups. :)

Well, we keep them, but parked, they're not allowed to run.
