Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3KTVJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:09:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50531 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3KTVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:09:33 -0500
Date: Wed, 20 Nov 2013 22:09:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        will.deacon@arm.com, catalin.marinas@arm.com, olof@lixom.net,
        sudeep.karkadanagesha@arm.com
Subject: Re: [PATCH] drivers: clocksource: Hide arm_arch_timer eventstream
 Kconfig on non-ARM
Message-ID: <20131120210931.GA1782@amd.pavel.ucw.cz>
References: <20131120192100.GA11723@amd.pavel.ucw.cz>
 <1384977723-32344-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384977723-32344-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-11-20 12:02:03, Stephen Boyd wrote:
> Pavel Machek reports that this config is exposed on x86 where the
> ARM architected timers aren't even present. Make it depend on the
> ARM architected timers being selected so that non-ARM builds
> aren't asked about it.
> 
> Reported-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

Thanks!
								Pavel
								
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
