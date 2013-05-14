Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3ENR6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:58:10 -0400
Received: from mail-gh0-f170.google.com ([209.85.160.170]:44509 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3ENR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:58:06 -0400
Date: Tue, 14 May 2013 10:57:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH V5 5/5] fbcon: queue work on power efficient wq
Message-ID: <20130514175759.GK6795@mtj.dyndns.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
 <89924f001e3ddd66ab41a16500569a976ea846fd.1366803121.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89924f001e3ddd66ab41a16500569a976ea846fd.1366803121.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 05:12:57PM +0530, Viresh Kumar wrote:
> fbcon uses workqueues and it has no real dependency of scheduling these on the
> cpu which scheduled them.
> 
> On a idle system, it is observed that and idle cpu wakes up many times just to
> service this work. It would be better if we can schedule it on a cpu which the
> scheduler believes to be the most appropriate one.
> 
> This patch replaces system_wq with system_power_efficient_wq.
> 
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: linux-fbdev@vger.kernel.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Dave, applied this to wq/for-3.11.  Please holler if you want this to
be routed differently.

Thanks!

-- 
tejun
