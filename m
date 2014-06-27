Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaF0Hof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:44:35 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48989 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaF0Hod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:44:33 -0400
MIME-Version: 1.0
In-Reply-To: <1403703451-12233-2-git-send-email-t.figa@samsung.com>
References: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
	<1403703451-12233-2-git-send-email-t.figa@samsung.com>
Date: Fri, 27 Jun 2014 09:44:28 +0200
Message-ID: <CACRpkdaA2oDOTBcL=S2j5bUTSB7oaS8ZWN0Rnf9Pbwtf3fTKjQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] ARM: mm: cache-l2x0: Add base address argument to
 write_sec callback
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 3:37 PM, Tomasz Figa <t.figa@samsung.com> wrote:

> For certain platforms (e.g. Exynos) it is necessary to read back some
> values from registers before they can be written (i.e. SMC calls that
> set multiple registers per call), so base address of L2C controller is
> needed for .write_sec operation. This patch adds base argument to
> .write_sec callback so that its implementation can also access registers
> directly.
>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>

>  arch/arm/mach-ux500/cache-l2x0.c   | 3 ++-

In our case just changing the signature of the function I see so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
