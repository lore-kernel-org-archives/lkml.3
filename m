Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbaCQPQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:16:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35704 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452AbaCQPQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:16:15 -0400
Date: Mon, 17 Mar 2014 16:16:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140317151601.GH25546@laptop.programming.kicks-ass.net>
References: <52FB90C6.4010701@linux.vnet.ibm.com>
 <52FC3C83.8020303@cn.fujitsu.com>
 <52FD07B2.5080402@linux.vnet.ibm.com>
 <20140213204102.GC17608@htj.dyndns.org>
 <20140214160923.GK27965@twins.programming.kicks-ass.net>
 <20140214162556.GF31544@htj.dyndns.org>
 <530B5EE3.8050200@linux.vnet.ibm.com>
 <20140224183501.GC2522@htj.dyndns.org>
 <20140225103726.GJ9987@twins.programming.kicks-ass.net>
 <531DCE36.8010906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531DCE36.8010906@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:37:42AM -0400, Jason J. Herne wrote:
> 
> Did you intend for me to run with this patch or was it posted for discussion
> only? If you want it run, please tell me what to look for.
> Also, if I should run this, should I include any other patches, either the
> last one you posted in this thread or any of Tejun's?

It needs some workqueue side debugging too; I'm not entirely sure where
the moving back to the online cpu happens, but you want to check the
set_cpus_allowed_ptr() return value there.
