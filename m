Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3EXLe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:34:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51877 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3EXLey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:34:54 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-39-519f505d2413
Date: Fri, 24 May 2013 13:34:42 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "Rafael J. Wysocky" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
Message-id: <20130524133442.7e065145@amdc308.digital.local>
In-reply-to: <CAKohpom+wsGj=1nurNtoiRaZCD7KRbx0BO+tNXpoqO+FmmzehA@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
 <20130522122700.104ca5cd@amdc308.digital.local>
 <CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
 <20130522164453.29cd3a7d@amdc308.digital.local>
 <20130524075640.0a5b80ff@amdc308.digital.local>
 <CAKohpoksymD76rDvg_+PwU7r3JXp1oydHBbJE4-y6TBHOomZHg@mail.gmail.com>
 <20130524103007.7bb206ee@amdc308.digital.local>
 <CAKohponbX7u_k9ZYQ7KyBeyKh93Qu+niGZj60t9c1n+AmaA6pg@mail.gmail.com>
 <519F2D89.5030602@linaro.org>
 <CAKohpom+wsGj=1nurNtoiRaZCD7KRbx0BO+tNXpoqO+FmmzehA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jAd3YgPmBBgv+KVk8bfrBbjHvs6xF
	59knzBZvHnFbXN41h83ic+8RRovbjSvYLPoX9jJZdBz5xmyx8auHA5fHnWt72DzWTXvL7NG3
	ZRWjx6PFLYwenzfJBbBGcdmkpOZklqUW6dslcGWcnf+NtWCaQMXfCawNjOd4uhg5OSQETCQW
	/5vLBmGLSVy4tx7I5uIQEljEKPHycTeU084kMfHsRiaQKhYBVYmjd7Yxg9hsAnoSn+8+BYpz
	cIgIaEm8vJkKUs8scIFJ4uC2zYwgNcIC6RL/tnWB9fIKWEv8P7meBcTmFAiW+L7sNivEgsms
	EnOe7QFr4BeQlGj/94MZ4iQ7iXOfNrBDNAtK/Jh8D6yZGWjZ5m1NrBC2vMTmNW+ZJzAKzkJS
	NgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfFM6kdjCsbLA4xCnAwKvHw
	ztCZFyjEmlhWXJl7iFGCg1lJhHcW3/xAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTS
	E0tSs1NTC1KLYLJMHJxSDYyOhtvrF5/u2if7wk11dkOldr7gorM2z27wPvVacfvAw+aGl2/k
	7b+4xs6cu/nVlZIZjj7Td3tOyre5WF1XapD67p2jieX09v1tj+yM+FK39L3RjZeSSjrwRJl/
	yf8JMyfzVJ/hlZ05S2XH0Sz5JublLWpcbmuW3uO7Y7JykZXgLhuLVw1vQxmVWIozEg21mIuK
	EwHpA5NThwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 24 May 2013 14:36, Daniel Lezcano <daniel.lezcano@linaro.org>
> wrote:
> > I agree with Viresh, a new governor is not necessary here for that.
> 
> Their patchset had two parts.. One is LAB and other is overclocking.
> We are trying to solve overclocking for which they never wanted a
> new governor. :)

Overclocking can be uses as a standalone feature. However it is crucial
for effective LAB operation.

> 
> > There is the /sys/devices/system/cpufreq/boost option existing for
> > x86 platform, why do not reuse it ? It is supposed to do exactly
> > what you want to achieve.
> 
> The problem is that it was added at the wrong place.. It should have
> been at cpu/cpuX/cpufreq/boost...
> 
> Consider how will we achieve it for big LITTLE.. We know we can
> go to overdrive only for a single core in big but for two cores in
> LITTLE at the same time.. So, we need that in the location I just
> mentioned...

I think that power/thermal envelope here is a key. We can overclock as
many cores as we want if we don't exceed limits :-)

Scheduler assignment of tasks to cores and core type decision on which
it would run is a different story for b.L. 

> 
> Over that.. I believe it is governor specific too.. It shouldn't be
> part of conservative as it should be conservative rather then
> aggressive :)
> 
> > IMO, the logic of boosting one core when the other are idle should
> > be in the driver itself and certainly not setup by the user, except
> > if we consider acceptable the user can burn its board ... :)

Sysfs entry can be read only and governor code can be responsible for
enabling overclocking.

Overclocking patch provides API implemented at cpufreq.h file to allow
in-kernel overclocking.

> 
> I didn't get it completely.. So, with the options I gave user can only
> say.. boost if required and only when few cores are active. User
> can't just set max freq continuously if he wishes..



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
