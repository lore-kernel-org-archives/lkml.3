Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbbAEQZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:25:10 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49917 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011AbbAEQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:25:08 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Tag5yGjIGPrF35ilqjnP3
Date: Mon, 5 Jan 2015 08:21:12 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>, nm@ti.com, khilman@linaro.org
Subject: Re: [PATCH v11 1/9] ARM: OMAP2+: use common l2cache initialization
 code
Message-ID: <20150105162111.GA4081@atomide.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
 <1420460348-20302-2-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420460348-20302-2-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Szyprowski <m.szyprowski@samsung.com> [150105 04:22]:
> This patch implements generic DT L2C initialisation (the one from
> init_IRQ in arch/arm/kernel/irq.c) for Omap4 and AM43 platforms and
> kills the SoC specific stuff in arch/arm/mach-omap2/omap4-common.c.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Seems to work just fine for me:

Acked-by: Tony Lindgren <tony@atomide.com>
