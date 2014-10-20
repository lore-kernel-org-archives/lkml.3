Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaJTViG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaJTViD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:38:03 -0400
Date: Mon, 20 Oct 2014 23:34:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in
	task_numa_assign()
Message-ID: <20141020213429.GA5245@redhat.com>
References: <1413800145.19914.23.camel@tkhai> <20141020144757.GA10939@redhat.com> <20141020165614.GA16373@redhat.com> <20141020182748.GA20424@redhat.com> <54456E26.2000103@yandex.ru> <20141020205006.GA2500@redhat.com> <54457918.8090006@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54457918.8090006@yandex.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill,

You should be as rude as you can if you send an email to lkml! You
are breaking the well-known rules, and now I have to mimic your wrong
behaviour.

On 10/21, Kirill Tkhai wrote:
>
> No, I won't send. Please do this. Your idea and your patch is almost
> ready. Thanks :)

Come on. You have found the nontrivial problem. This is much more
important than a simple fix.

And if we prefer a less-trivial fix which plays with ->curr recheck,
then it will be based on your idea, not mine.

So please make a patch after we know what Peter thinks.

Oleg.

