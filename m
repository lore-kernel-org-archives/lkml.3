Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbaEPQe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:34:28 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:42754 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaEPQe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:34:27 -0400
Date: Fri, 16 May 2014 12:34:24 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Preeti Murthy <preeti.lkml@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] sched: remove remaining power to the CPU
In-Reply-To: <CAM4v1pNpc+dpEd4KZ3k-uTxsu01gKBtusNvppaHeMdvdzf_i+Q@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405161230460.17310@knanqh.ubzr>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org> <1400101030-17717-6-git-send-email-nicolas.pitre@linaro.org> <CAM4v1pNpc+dpEd4KZ3k-uTxsu01gKBtusNvppaHeMdvdzf_i+Q@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Preeti Murthy wrote:

> Hi Nicolas,
> You might want to change the subject.

That was a tongue-in-cheek subject. I was wondering if anyone would 
react to it.  ;-)

> s/sched: remove remaining power to the CPU/
> sched: remove remaining usage of cpu *power* .
> 
> The subject has to explicitly specify in some way
> that it is a change made to the terminology.

Sure.


Nicolas
