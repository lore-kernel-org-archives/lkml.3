Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3IFQsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:48:18 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46248 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3IFQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:48:16 -0400
MIME-Version: 1.0
In-Reply-To: <1378351680-14696-2-git-send-email-acourbot@nvidia.com>
References: <1378351680-14696-1-git-send-email-acourbot@nvidia.com>
	<1378351680-14696-2-git-send-email-acourbot@nvidia.com>
Date: Fri, 6 Sep 2013 18:48:15 +0200
Message-ID: <CACRpkdaphSqM1oOphC-t1UPmkxaEemC3R3aDfEXb79GWNNyNMA@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] ARM: add basic Trusted Foundations support
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 5:27 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Trusted Foundations is a TrustZone-based secure monitor for ARM that
> can be invoked  using a consistent SMC-based API on all supported
> platforms. This patch adds initial basic support for Trusted
> Foundations using the ARM firmware API. Current features are limited
> to the ability to boot secondary processors.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

I take it that this means that it is a set of standard routines
living in the secure world that can be called by way of this
API, correct? The commit message is written a bit like
everybody knows what this is about but I don't :-)

Some more background here would be nice, like where did this
thing come from, and are there other platforms in existance that
use trusted foundations or is it a Tegra-only thing? Does a
specification of this thing listing available services exist for
example?

How does it relate to the (arch-neutral) trusted execution
environment and such things that other vendors are pushing for?
Can the trusted foundations be used "underneath" such
frameworks for trusted applications, or is it a parallell thing
altogether?

Simple things like that...

I tried googling it, is this a relevant URL?
http://www.arm.com/community/partners/display_product/rw/ProductId/5393/

Thanks,
Linus Walleij
