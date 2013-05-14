Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3ENRyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:54:49 -0400
Received: from mail-gg0-f180.google.com ([209.85.161.180]:65531 "EHLO
	mail-gg0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3ENRyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:54:47 -0400
Date: Tue, 14 May 2013 10:54:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH V5 0/5] Queue work on power efficient wq
Message-ID: <20130514175440.GG6795@mtj.dyndns.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1366803121.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 05:12:52PM +0530, Viresh Kumar wrote:
> This patchset was called: "Create sched_select_cpu() and use it for workqueues"
> for the first three versions.

Applied to wq/for-3.11 with some updates to comments and
documentation.  Will post the applied versions.  If something is awry,
please let me know.

Thanks.

-- 
tejun
