Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaBMNLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:11:19 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:40240 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaBMNLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:11:18 -0500
MIME-Version: 1.0
In-Reply-To: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
References: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
Date: Thu, 13 Feb 2014 14:11:17 +0100
Message-ID: <CACRpkdYnw3S3YEa8b0Pmipp892unBhVBMs0kqSNBAz5i0CVA0g@mail.gmail.com>
Subject: Re: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 11:29 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> The DBx500 and ABx500 should be getting their IRQs from the
> device tree and nowhere else. Get rid of all the static assignments
> everywhere, delete it from the driver, platform data and the
> board files in one swift strike.
>
> Lots of cross-dependencies in the MFD drivers for PRCMU and
> AB8500 makes it necessary to strike everywhere at once to
> eradicate IRQs passed as resources and platform data to the left
> and right around the platform.
>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

OK no major complaints, Lee can you queue this in the MFD tree
so we get some Linux-next rotation? If we need an immutable
branch remains to be seen, maybe we can merge this throug MFD
exclusively.

Yours,
Linus Walleij
