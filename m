Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaE0OqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:46:10 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:51973 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaE0OqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:46:04 -0400
Date: Tue, 27 May 2014 10:46:01 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v2 0/6] sched: expel confusing usage of the term
 "power"
In-Reply-To: <CAKfTPtAb45b0KC==k7+DB_JZrXsSHcLFrn=oenX3wnS42eK6Xg@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405271036040.17310@knanqh.ubzr>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org> <CAKfTPtAb45b0KC==k7+DB_JZrXsSHcLFrn=oenX3wnS42eK6Xg@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Vincent Guittot wrote:

> Hi Nicolas,
> 
> There are still some use of "power" instead of "capacity" in the sched
> directory like SD_SHARE_CPUPOWER, ARCH_POWER or NONTASK_POWER. They
> should also be renamed in capacity as there are also used for capacity

I thought the first one was used to identify CPU sharing the same 
(electric) power domain.  Or maybe I confused it with 
SD_SHARE_POWERDOMAIN, illustrating the point once again for this series.

I'll create additional patches.


Nicolas
