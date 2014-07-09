Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaGIKE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:04:57 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:54672 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718AbaGIKE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:04:56 -0400
X-Spam-Flag: NO
Message-ID: <53BD1316.5090901@pavlinux.ru>
Date: Wed, 09 Jul 2014 14:01:58 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Carsten Emde <cbe@osadl.org>
Subject: Re: [ANNOUNCE] 3.14.10-rt7
References: <alpine.DEB.2.10.1407071027170.22031@nanos> <alpine.DEB.2.10.1407071633460.22031@nanos>
In-Reply-To: <alpine.DEB.2.10.1407071633460.22031@nanos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.07.2014 18:34, Thomas Gleixner пишет:
> This time with proper Subject line :)
>
> Dear RT Folks,
>
> I'm pleased to announce the 3.14.10-rt7 release. 3.14.10-rt6 is a not
> announced update to 3.14.10 without any RT changes aside of resolving
> the patch conflicts.
>
> Changes since 3.14.10-rt6:
>
>     * Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq() -
>       from Steven
>
>     * Prevent workqueue deadlock/stall observed with XFS
>
>
> A few words on the status and the future of RT:
> -----------------------------------------------
>
> The situation since last years RTLWS (https://lwn.net/Articles/572740/)
> has not improved at all, it's worse than before.
>
> While shortly after RTLWS quite some people promised to whip up proper
> funding, nothing has materialized and my personal situation is worse
> than before.

Create site, add PayPal [DOANTE] button.


-- 

                                                          Pavel.
