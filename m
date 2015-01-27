Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbbA0BSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:18:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46532 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbbA0BSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:18:53 -0500
Date: Mon, 26 Jan 2015 17:18:51 -0800 (PST)
Message-Id: <20150126.171851.467276201415777614.davem@davemloft.net>
To: john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        richardcochran@gmail.com, prarit@redhat.com, sboyd@codeaurora.org,
        mingo@kernel.org, peterz@infradead.org
Subject: Re: [PATCH 11/12] sparc: Convert to using clocksource_register_hz()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421971767-17707-12-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
	<1421971767-17707-12-git-send-email-john.stultz@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Jan 2015 17:18:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>
Date: Thu, 22 Jan 2015 16:09:26 -0800

> While cleaning up some clocksource code, I noticed the
> time_32 impelementation uses the hz2mult helper, but
> doesn't use the clocksource_register_hz() method.
> 
> I don't believe the sparc clocksource is a default
> clocksource, so we shouldn't need to self-define
> the mult/shift pair.
> 
> So convert the time_32.c implementation to use
> clocksource_register_hz().
> 
> Untested.
> 
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Acked-by: David S. Miller <davem@davemloft.net>
