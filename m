Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3ALVZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:25:37 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64062 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754322Ab3ALVZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:25:36 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/0TjhforAZDkqEkk+/KXF0gUOrmpYQviU=
Date: Sat, 12 Jan 2013 16:25:23 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH v2 2/3] ARM: use clockevents_config_and_register()
 where possible
Message-ID: <20130112212523.GD13433@titan.lakedaemon.net>
References: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
 <1357991406-22778-3-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357991406-22778-3-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 07:50:05PM +0800, Shawn Guo wrote:
> The clockevent core is able to figure out the best mult and shift,
> calculate min_delta_ns and max_delta_ns, with the necessary info passed
> into clockevents_config_and_register().  Use this combined configure
> and register function where possible to make the codes less error prone
> and gain some positive diff stat.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Reviewed-by: Anton Vorontsov <cbouatmailru@gmail.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Tested-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: David Brown <davidb@codeaurora.org>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Acked-by: Barry Song <baohua.song@csr.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Tony Prisk <linux@prisktech.co.nz>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
...
>  arch/arm/plat-orion/time.c               |    6 +-----
...

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
