Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbaAHIiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:38:12 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51971 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbaAHIiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:38:02 -0500
Message-ID: <52CD0E5D.6070008@linaro.org>
Date: Wed, 08 Jan 2014 16:37:49 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC] sched: CPU topology try
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net> <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org> <52B87149.4010801@arm.com> <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com> <20140106163123.GN31570@twins.programming.kicks-ass.net> <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com> <20140107132220.GZ31570@twins.programming.kicks-ass.net> <CAKfTPtCE3gy_656EfcrfjZ-15CTxAqk91O6qR1Jz3BCABvDNCg@mail.gmail.com> <20140107153715.GG2936@e103034-lin>
In-Reply-To: <20140107153715.GG2936@e103034-lin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 11:37 PM, Morten Rasmussen wrote:
>>> > >
>>> > > So something like:
>>> > >
>>> > >   avg = runnable + p(i) * blocked; where p(i) \e [0,1]
>>> > >
>>> > > could maybe be used to replace the cpu_load array and still represent
>>> > > the concept of looking at a bigger picture for larger sets. Leaving open
>>> > > the details of the map p.
> Figuring out p is the difficult bit. AFAIK, with blocked load in its
> current form we don't have any clue when a task will reappear.

Yes, that's why we can not find a suitable way to consider the blocked
load in load balance.


-- 
Thanks
    Alex
