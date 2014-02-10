Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaBJLJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:09:35 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36370 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaBJLJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:09:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140210104032.GB20143@ulmo.nvidia.com>
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
	<20140210104032.GB20143@ulmo.nvidia.com>
Date: Mon, 10 Feb 2014 12:09:29 +0100
Message-ID: <CACRpkdb1T1GCqEpy9=fPp4hYQErLYiQqJezrFhoS3x1MU=0S9g@mail.gmail.com>
Subject: Re: [PATCH] backlight: add PWM dependencies
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:40 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:

> it seems like at least BACKLIGHT_LP8788 is missing a corresponding
> dependency as well.
>
> I have applied Sascha's patch to remove the obsolete HAVE_PWM symbol,
> and this will fix at least the build issues. However it will also cause
> the driver to fail at runtime because the pwm_*() functions won't work.

So it definately needs that API, not just stubs.

But isn't it proper for Kconfig to allow you to break things
like that by configuring out stuff and have stubs come in?

I'm a bit torn here.

Yours,
Linus Walleij
