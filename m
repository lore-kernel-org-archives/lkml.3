Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030207AbaIZPDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:03:04 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:52601 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbaIZPC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140926132330.GF4140@worktop.programming.kicks-ass.net>
References: <CA+80gGaC5tutmFiTCyL-zoBY4BcbZnh63wXhO-g5UetP+w5g4w@mail.gmail.com>
	<20140926132330.GF4140@worktop.programming.kicks-ass.net>
Date: Fri, 26 Sep 2014 08:02:57 -0700
Message-ID: <CA+80gGbieP1k2cmyOYLaK71ygSuR3=z0UeK=A-O3BDg-TVZREg@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: deferred set priority (dprio) -- rebased for
 the tip
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 6:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:

>> This is a replica of "[PATCH 1/2] dprio" (posted yesterday for 3.16.3)
>> rebased now for the current tip (3.17.0-rc6).
>>
> 2 lines of changelog for a ~1300 line patch, you must be kidding, right?
>
> What problem is it solving and why do I care?


Hi Peter,

It is described in message [PATCH 0/2]
https://lkml.org/lkml/2014/9/24/1030
and further links from it,
as well as in the man page (patch message [PATCH 2/2])
https://lkml.org/lkml/2014/9/24/1043

- Sergey
