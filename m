Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3HPNOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:14:37 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41171 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3HPNOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:14:33 -0400
MIME-Version: 1.0
In-Reply-To: <1375133350-18828-2-git-send-email-ddaney.cavm@gmail.com>
References: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
	<1375133350-18828-2-git-send-email-ddaney.cavm@gmail.com>
Date: Fri, 16 Aug 2013 15:14:33 +0200
Message-ID: <CACRpkdZwZyqkjmHmdawyD+mC3bRmgg9Ab_VZp1cPPSGLUfVGMw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] MIPS: OCTEON: Select ARCH_REQUIRE_GPIOLIB
From: Linus Walleij <linus.walleij@linaro.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 11:29 PM, David Daney <ddaney.cavm@gmail.com> wrote:

> From: David Daney <david.daney@cavium.com>
>
> ... and create asm/mach-cavium-octeon/gpio.h so that things continue
> to build.
>
> This allows us to use the existing I2C connected GPIO expanders.
>
> Signed-off-by: David Daney <david.daney@cavium.com>

I like the looks of this.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
