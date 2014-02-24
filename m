Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaBXN7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:59:14 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:65379 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaBXN7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:59:13 -0500
Date: Mon, 24 Feb 2014 13:59:03 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
Message-ID: <20140224135903.GA15847@lee--X1>
References: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
 <20140213131720.GC3403@lee--X1>
 <CACRpkdaoqwiy0n-oN0gKqgX_enGXw+BggRQy9yz8eQNyJ3MvsA@mail.gmail.com>
 <201402141754.02159.arnd@arndb.de>
 <CACRpkdYTd+x=tEviRxXv6HANscJjWqfeVOhDtpefFmxiuCsVDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYTd+x=tEviRxXv6HANscJjWqfeVOhDtpefFmxiuCsVDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Linus Walleij wrote:

> On Fri, Feb 14, 2014 at 5:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 14 February 2014, Linus Walleij wrote:
> 
> >> > I'm happy to do either, but the latter will require an ARM-SoC Ack.
> >>
> >> OK Olof/Arnd/Kevin: can you ACK this patch for queueing
> >> through MFD? It only hits arch/arm/mach-ux500/*
> >
> > Sounds good. Great job at cleaning up that stuff!
> 
> Lee this sounds like an ACK :-)
> 
> Please queue this patch, I will probably avoid doing more
> of this stuff for the next merge window so I think it won't
> collide with anything.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
