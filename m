Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3LJPx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:53:56 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49092 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab3LJPxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:53:53 -0500
Date: Tue, 10 Dec 2013 16:53:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: dinguyen@altera.com
Cc: dinh.linux@gmail.com, daniel.lezcano@linaro.org, tglx@linutronix.de,
        jamie@jamieiles.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de
Subject: Re: [PATCHv4] clocksource: dw_apb_timer_of: Fix read_sched_clock
Message-ID: <20131210155349.GC1995@gmail.com>
References: <1386690395-27182-1-git-send-email-dinguyen@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386690395-27182-1-git-send-email-dinguyen@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* dinguyen@altera.com <dinguyen@altera.com> wrote:

> From: Dinh Nguyen <dinguyen@altera.com>
> 
> The read_sched_clock should return the ~value because the clock is a
> countdown implementation. read_sched_clock() should be the same as
> __apbt_read_clocksource().
> 
> Maintain backwards compatibility for "dw-apb-timer-sp" and
> "dw-apb-timer-osc".

Are these two independent fixes? If yes then they should be in 
separate patches. In general we want to apply minimized, obvious, 
single-purpose fix patches.

Thanks,

	Ingo
