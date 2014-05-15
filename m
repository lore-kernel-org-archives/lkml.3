Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaEOH21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:28:27 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:56691 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaEOH20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:28:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140515072105.GY30445@twins.programming.kicks-ass.net>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org>
 <1400101030-17717-3-git-send-email-nicolas.pitre@linaro.org> <20140515072105.GY30445@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 15 May 2014 09:28:05 +0200
Message-ID: <CAKfTPtCGXVWMD9YhzorFzbEk31h27PRGzv2+ZAvzwHrSrr==2Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] sched/fair.c: change "has_capacity" to "has_free_capacity"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2014 09:21, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, May 14, 2014 at 04:57:06PM -0400, Nicolas Pitre wrote:
>> The capacity of a CPU/group should be some intrinsic value that doesn't
>> change with task placement.  It is like a container which capacity is
>> stable regardless of the amount of liquid in it... unless the container
>> itself is crushed that is, but that's another story.
>>
>> Therefore let's rename "has_capacity" to "has_free_capacity" in order to
>> better convey the wanted meaning.
>>
>
> Yeah, not really, the whole capacity thing is bollocks, but sure we can
> rename it for as long as it still lives ;-)

Hi,

Yes, I'm preparing an update of my rework around cpu_power and this
field will disappear

Vincent
