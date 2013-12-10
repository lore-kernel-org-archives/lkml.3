Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3LJMU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:20:58 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41966 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3LJMUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:20:54 -0500
Date: Tue, 10 Dec 2013 13:20:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] clocksource/clockevents fixes for 3.13
Message-ID: <20131210122051.GD30001@gmail.com>
References: <52A0AC37.5010006@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A0AC37.5010006@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> 
> Hi Thomas,
> 
> here are the fixes for 3.13 based on timers/urgent

Please generally also post the patches to make it easier to review 
them.

>  * Axel Lin removed the bcm_timer_ids which are no longer used due
> to the conversion to clksrc-of and added a missing dependency on
> CLKSRC_MMIO in the Kconfig for the time-efm32.

Is the ID removal a necessary regression fix? If not then it has no 
place in the urgent queue.

Thanks,

	Ingo
