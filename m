Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbbABPjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:39:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42854 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbbABPj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:39:26 -0500
Message-ID: <54A6BB85.70805@ti.com>
Date: Fri, 2 Jan 2015 09:38:45 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Lindgren <tony@atomide.com>, Daniel Drake <drake@endlessm.com>,
        Jon Loeliger <loeliger@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like
 interface
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>	<1419331716-8972-3-git-send-email-m.szyprowski@samsung.com>	<54A19C17.1020909@ti.com> <CA+Ln22G3kVA_-tsjAxbe2rqSHeLtdU2X_EhNL0uW3cUCgaWLgg@mail.gmail.com> <54A2BBDC.1020900@ti.com> <54A66143.2080506@gmail.com>
In-Reply-To: <54A66143.2080506@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2015 03:13 AM, Tomasz Figa wrote:

> However I'm not sure about your concern about using l2x0_data before 
> kmemdup(). I don't see any code potentially doing this.

It is not terribly important, but anyways [1] is what I had in mind..



[1]
https://github.com/nmenon/linux-2.6-playground/commit/40f65e4707856f7b35872cf2225bf8beaf43552c#diff-56925866b8b499d75763bf5a1d7f1666L883

-- 
Regards,
Nishanth Menon
