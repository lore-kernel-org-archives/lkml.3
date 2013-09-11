Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3IKPWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:22:06 -0400
Received: from mail.renton.name ([90.155.165.44]:52550 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3IKPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:22:04 -0400
Date: Wed, 11 Sep 2013 19:18:14 +0400
From: Alexey Vlasov <renton@renton.name>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel migration eat CPUs
Message-ID: <20130911151813.GH13294@beaver>
References: <20130823151711.f4c1f596b4c7aa1eecccc9a6@linux-foundation.org>
 <20130825142837.GD31370@twins.programming.kicks-ass.net>
 <20130904185315.GB13294@beaver>
 <20130905111252.GA23362@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130905111252.GA23362@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:12:52PM +0200, Ingo Molnar wrote:
> 
> Could you try the latest -tip tree at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> 
> In particular this fix:
> 
>    5a8e01f8fa51 sched/cputime: Do not scale when utime == 0
> 
> Could perhaps fix the phantom CPU overhead you are seeing?

This kernel solved problems.
Thank you.

-- 
BRGDS. Alexey Vlasov.
