Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaJTW5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:57:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:48034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaJTW5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:57:30 -0400
Date: Tue, 21 Oct 2014 00:57:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141020225725.GE3219@twins.programming.kicks-ass.net>
References: <1413800145.19914.23.camel@tkhai>
 <20141020144757.GA10939@redhat.com>
 <20141020165614.GA16373@redhat.com>
 <20141020182748.GA20424@redhat.com>
 <54456E26.2000103@yandex.ru>
 <20141020205006.GA2500@redhat.com>
 <54457918.8090006@yandex.ru>
 <20141020213429.GA5245@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020213429.GA5245@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:34:29PM +0200, Oleg Nesterov wrote:
> So please make a patch after we know what Peter thinks.

Peter thinks its about time to go sleep ;-) Sorry I was hiding today, I
wanted to get that speculative fault crap posted. I'll go look at this
when I wake up again. Zzzz...
