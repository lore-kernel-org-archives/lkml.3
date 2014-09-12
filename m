Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaILHl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:41:29 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53423 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaILHlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:41:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1409111443570.16533@knanqh.ubzr>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-11-git-send-email-vincent.guittot@linaro.org>
 <20140911123412.GY3190@worktop.ger.corp.intel.com> <CAKfTPtBbjpCFifoyFSh8Hb3nBZFFTjjxdfxnpMk=CHy5aX1qpg@mail.gmail.com>
 <20140911140444.GH4783@worktop.ger.corp.intel.com> <alpine.LFD.2.11.1409111443570.16533@knanqh.ubzr>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 12 Sep 2014 09:41:01 +0200
Message-ID: <CAKfTPtAYfjp6cShrXCq2p24L5gvwxkDLZtzxiSaFQCo=iMjxbw@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] sched: get CPU's utilization statistic
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 21:17, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>>
>> Any other opinions before Vince goes and applies sed on patches? ;-)
>
> I don't mind either way, but for sure someone (possibly me) is going to
> confuse the two soon enough.
>
> Please include in the code some formal definition in the context of the
> scheduler.  A comment block right before the corresponding get_cpu_*
> accessors should be good enough.

ok

>
>
> Nicolas
