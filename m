Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaL2ObD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:31:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37545 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbaL2Oa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:30:58 -0500
Date: Mon, 29 Dec 2014 08:29:58 -0600
From: Nishanth Menon <nm@ti.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Tony Lindgren <tony@atomide.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, <lauraa@codeaurora.org>,
        <linus.walleij@linaro.org>, <drake@endlessm.com>, <loeliger@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, <khilman@linaro.org>
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like
 interface
Message-ID: <20141229142958.GA10746@kahuna>
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
 <1419331716-8972-3-git-send-email-m.szyprowski@samsung.com>
 <20141223170613.GM23854@atomide.com>
 <5499A2B4.2080909@ti.com>
 <549FEABA.10206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <549FEABA.10206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:34-20141228, Tomasz Figa wrote:
> May I ask you (or anyone else working on OMAP) to try to figure out
> what the issue is? It is stopping L2 cache support for Exynos4 being

http://slexy.org/view/s2BnzxVglj
Took a register dump and compared -> Got the same dump
http://slexy.org/view/s21YRHpzeW .

Basically, this implies: possible sequence change broke AM437x or
some secure function call (which i have'nt dumped).

Is it possible to break up this patch into easier patches?

-- 
Regards,
Nishanth Menon
