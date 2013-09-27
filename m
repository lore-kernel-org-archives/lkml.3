Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab3I0FuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:50:08 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33152 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3I0FuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:50:01 -0400
Date: Fri, 27 Sep 2013 07:49:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL 3.12-rc2 fixes] clocksource: Several fixes for 3.12-rc2
Message-ID: <20130927054957.GC6597@gmail.com>
References: <524381D2.7050604@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524381D2.7050604@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> Hi Thomas,
> 
> this pull request contains several fixes for the clocksource/clockevent
> drivers:
> 
>  - Jean Pihet fixed a missing Kconfig option preventing the Armada370/XP
> to boot up.
> 
>  - Magnus Damm fixed the cpumask on the em_sti driver to have the
> broadcast timer working on a SMP system
> 
>  - Sebastian Hesselbarth skipped the initialization of a timer for
> uninitialized DT nodes
> 
>  - Tomasz Figa fixed the irq affinity failing on non online cpus
> 
> Thanks
>   -- Daniel
> 
> -----------------------------------------------------------------------------
> 
> The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:
> 
>   Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)
> 
> are available in the git repository at:
> 
> 
> ssh://daniel.lezcano@git.linaro.org//srv/git.linaro.org/git/people/dlezcano/linux.git
> clockevents/3.12-rc2-fixes

If you want me to pull this you'll need to send along your SSH password as 
well!

Thanks,

	Ingo
