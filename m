Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbbAEQ3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:29:48 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14374 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbAEQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:29:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/4CvBAbkBj99Q2fHFaItfD
Date: Mon, 5 Jan 2015 08:25:54 -0800
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
Subject: Re: [PATCH v11 6/9] ARM: l2c: Add support for overriding prefetch
 settings
Message-ID: <20150105162553.GF4081@atomide.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
 <1420460348-20302-7-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420460348-20302-7-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Szyprowski <m.szyprowski@samsung.com> [150105 04:22]:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> Firmware on certain boards (e.g. ODROID-U3) can leave incorrect L2C prefetch
> settings configured in registers leading to crashes if L2C is enabled
> without overriding them. This patch introduces bindings to enable
> prefetch settings to be specified from DT and necessary support in the
> driver.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> [mszyprow: rebased onto v3.18-rc1, added error message when prefetch related
>  dt property has been provided without any value]
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Tony Lindgren <tony@atomide.com>
