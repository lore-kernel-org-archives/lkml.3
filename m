Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaIKMVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:21:04 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41735 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaIKMVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:21:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140911111736.GV3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org> <20140911111736.GV3190@worktop.ger.corp.intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 11 Sep 2014 14:20:41 +0200
Message-ID: <CAKfTPtBMNLmvkfvwc3Ggv42ADLWw2GdFSDmWKWizPb+gLUULgQ@mail.gmail.com>
Subject: Re: [PATCH v5 09/12] sched: add usage_load_avg
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 13:17, Peter Zijlstra <peterz@infradead.org> wrote:

>>  };
>>
>
> Man, I should go look at Yuyang's rewrite of this all again. I just
> tried to figure out the decay stuff and my head hurts ;-)

Regarding Yuyang's rewrite, i had a patch above his patches to add the
running figure that i haven't sent yet
