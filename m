Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaBMNTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:19:19 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:50582 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaBMNTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:19:16 -0500
Date: Thu, 13 Feb 2014 13:17:20 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
Message-ID: <20140213131720.GC3403@lee--X1>
References: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
 <CACRpkdYnw3S3YEa8b0Pmipp892unBhVBMs0kqSNBAz5i0CVA0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYnw3S3YEa8b0Pmipp892unBhVBMs0kqSNBAz5i0CVA0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> <linus.walleij@linaro.org> wrote:
> 
> > The DBx500 and ABx500 should be getting their IRQs from the
> > device tree and nowhere else. Get rid of all the static assignments
> > everywhere, delete it from the driver, platform data and the
> > board files in one swift strike.
> >
> > Lots of cross-dependencies in the MFD drivers for PRCMU and
> > AB8500 makes it necessary to strike everywhere at once to
> > eradicate IRQs passed as resources and platform data to the left
> > and right around the platform.
> >
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> OK no major complaints, Lee can you queue this in the MFD tree
> so we get some Linux-next rotation? If we need an immutable
> branch remains to be seen, maybe we can merge this throug MFD
> exclusively.

I'm happy to do either, but the latter will require an ARM-SoC Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
