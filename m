Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaBXPCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:02:03 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40003 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbaBXPCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:02:01 -0500
Message-ID: <530B5EE3.8050200@linux.vnet.ibm.com>
Date: Mon, 24 Feb 2014 10:01:55 -0500
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Subject: Warning in workqueue.c
References: <20140207165113.GD3304@htj.dyndns.org> <52F51E10.8050208@linux.vnet.ibm.com> <20140207193604.GA8833@htj.dyndns.org> <52F8F0FB.3080206@linux.vnet.ibm.com> <20140210231742.GK25350@mtj.dyndns.org> <52FB90C6.4010701@linux.vnet.ibm.com> <52FC3C83.8020303@cn.fujitsu.com> <52FD07B2.5080402@linux.vnet.ibm.com> <20140213204102.GC17608@htj.dyndns.org> <20140214160923.GK27965@twins.programming.kicks-ass.net> <20140214162556.GF31544@htj.dyndns.org>
In-Reply-To: <20140214162556.GF31544@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022415-0320-0000-0000-00000288A1A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 11:25 AM, Tejun Heo wrote:
> ...
> Hmmm... weird, p's rq shouldn't have changed without its cpus_allowed
> busted.  Anyways, let's wait for Jason's test results and see whether
> this is a regression at all.

I was unable to determine exactly when this behavior was introduced. The 
reason for this is because I keep hitting other bugs that prevent the 
test case from running, the most notable of which causes an immediate 
system hang. I also hit other warnings and bug messages and I'm not sure 
if they are related or if they will influence the probability of hitting 
the problem we are trying to solve here.  What I did find is the following:

We hit this problem as far back as v3.10.
The warning was introduced after v3.5 but before v3.6.

-- 
-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

