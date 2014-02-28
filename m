Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaB1FHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:07:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52475 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaB1FH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:07:27 -0500
Message-ID: <1393563998.6018.19.camel@marge.simpson.net>
Subject: Re: [GIT PULL timers] Timer-wheel bandaids^Wcommits for 3.15
From: Mike Galbraith <bitbucket@online.de>
To: paulmck@linux.vnet.ibm.com
Cc: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, peterz@infradead.org, oleg@redhat.com,
        rostedt@goodmis.org
Date: Fri, 28 Feb 2014 06:06:38 +0100
In-Reply-To: <20140228012704.GA20805@linux.vnet.ibm.com>
References: <20140228012704.GA20805@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:8FXQpK4Eyda2KGJwPN/4hgC+2/GfmvS+ratD6djBiRB
 EaATN2gaMlcPpEfijlZCJF9b8azhqN16p1zzn5s7iryAigxTtZ
 oTzyGdg5WpZ9pkctWAYueyM5wzToX4MueeubnreVaXjqRZM+1y
 qP+ZAazw+8g+6UYHCpOEwIqMjiyvh7FbbM0UrHipIWWvulY7di
 /sID9hqX8ALIeWgFtSFr5oDEKwggAzB4R6HZ12hLj8x1egsr07
 1n8wnxcfMUAIw5V2sUrmXLuwW/303/37NLjz/nCPiH63P6nLFJ
 Ic/+bG/4Utba2MRbQN5gQtujKb56tn7mX+3gJ4wxMlujHCGWzh
 XTEMo2ZKdm1QsdWZa6LqzLiTEXlQ370+PBVsd7rVt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 17:27 -0800, Paul E. McKenney wrote: 
> Hello, Thomas and Ingo,
> 
> This pull request contains latency bandaids^Woptimizations to the
> timer-wheel code that are useful in conjunction with NO_HZ_FULL Kconfig
> option.  These optimizations reduce the jiffy-by-jiffy looping in cases
> where there is either zero or one timers in the timer wheel, which is
> a common case for NO_HZ_FULL "worker" CPUs that run almost entirely
> in usermode for a single task.

FWIW, these have seen quite a bit of runtime on various boxen, both in
day to day and piddle about -rt kernels, with zero attention grabbers.

-Mike

