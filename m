Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3AVIze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:55:34 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56873 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3AVIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:55:32 -0500
MIME-Version: 1.0
In-Reply-To: <50FB8986.9010205@nvidia.com>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
	<CACRpkda6dqAj+DzrMCnKET7Z9PtuW0+k9ea3YDL8Z1D=oFVRpQ@mail.gmail.com>
	<50F7E83E.8000105@uclinux.org>
	<201301170850.43655.sfking@fdwdc.com>
	<50FB8986.9010205@nvidia.com>
Date: Tue, 22 Jan 2013 09:55:32 +0100
Message-ID: <CACRpkdZHgEQRwKZXS6Juk763z+AAXB3SnG=wLdX+aJY0X=nYKQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alex Courbot <acourbot@nvidia.com>, Steven King <sfking@fdwdc.com>
Cc: Greg Ungerer <gerg@uclinux.org>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 7:07 AM, Alex Courbot <acourbot@nvidia.com> wrote:

> Actually the question of switching to GPIOlib is only worth being asked if
> you are making use of drivers that require GENERIC_GPIO. If this is not the
> case and your GPIOs are only used by your own platform code, you can always
> give up using defining GENERIC_GPIO and continue implementing them your own
> way.

Agreed. The problem can be summed up like this:

#include <linux/gpio.h>

Considered ambiguous.

#include <asm/foo/bar/baz-gpio.h>

OK with me.

Yours,
Linus Walleij
