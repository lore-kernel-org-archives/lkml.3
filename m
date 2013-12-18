Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3LROdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:33:14 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:50324 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3LROdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:33:13 -0500
MIME-Version: 1.0
In-Reply-To: <87r49al12j.fsf@linaro.org>
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
	<20131211132212.GA7862@localhost.localdomain>
	<CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
	<87wqj34eqs.fsf@linaro.org>
	<CAKohpo=Btb8ChRJ4Be9gbDE-nOxSaCVkQ_Qg5g7AVRxOMbXEQQ@mail.gmail.com>
	<87r49al12j.fsf@linaro.org>
Date: Wed, 18 Dec 2013 20:03:12 +0530
Message-ID: <CAKohpokDBga18BhZm=r+EOoY40=+E7Ndtfooq9rXbqc=wUg2Ng@mail.gmail.com>
Subject: Re: [LNG] Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 December 2013 19:21, Kevin Hilman <khilman@linaro.org> wrote:
> Ah, I see.  So you're basically asking why we can't evaluate whether to
> turn off the tick more often, for example right after the workqueues are
> done.  I suppose Frederic may have some views on that, but there's
> likely additional overhead from those checks as well as that workqueues
> may not be the only thing keeping us out of NO_HZ.

I see that sched_switch is called at the end most of the times so an check
there might be useful ?
