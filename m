Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3I1GvD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 02:51:03 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59941 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3I1Gu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 02:50:59 -0400
Date: Sat, 28 Sep 2013 08:50:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Anil Kumar <anilk4.v@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [GIT PULL] arm/context_tracking build fix
Message-ID: <20130928065055.GD16660@gmail.com>
References: <1380302159-10376-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380302159-10376-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the context_tracking/fixes branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	context_tracking/fixes
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (1):
>       arm: Fix build error with context tracking calls
> 
> 
>  arch/arm/kernel/entry-header.S |  8 ++++----
>  kernel/context_tracking.c      | 12 ++++++++++++
>  2 files changed, 16 insertions(+), 4 deletions(-)

Pulled into tip:sched/urgent, thanks Frederic!

	Ingo
