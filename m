Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab3FYNt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:49:59 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:49813 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FYNt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:49:58 -0400
MIME-Version: 1.0
In-Reply-To: <51C97F40.5030101@arm.com>
References: <51C97F40.5030101@arm.com>
Date: Tue, 25 Jun 2013 15:49:57 +0200
Message-ID: <CACRpkdb-Fhz3pjWm3xVguitv6h0-+ywyo3HFDVgqgHcZ-MjKKA@mail.gmail.com>
Subject: Re: amba-pl08x and 'get_signal' namespace collision/build error
From: Linus Walleij <linus.walleij@linaro.org>
To: Jonathan Austin <jonathan.austin@arm.com>, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 1:30 PM, Jonathan Austin
<jonathan.austin@arm.com> wrote:

> There's a patch making its way to mainline via Russell's tree
> (8d96250700: ARM: mm: Transparent huge page support for LPAE systems)
> that breaks the build of the amba-pl08x driver (drivers/dma/amba-pl08x.c)
> because the 'get_signal' macro from include/linux/signal.h is now in the
> driver's scope and it clobbers a (previously) valid function call.

This is already fixed by Mark Brown in the DMA tree.

Commit subject:
"dmaengine: PL08x: Avoid collisions with get_signal() macro"

Yours,
Linus Walleij
