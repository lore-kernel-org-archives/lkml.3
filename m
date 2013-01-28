Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3A1INK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:13:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40052 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3A1INI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:13:08 -0500
Date: Mon, 28 Jan 2013 08:13:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Naga Radhesh <naga.radheshy@stericsson.com>
Subject: Re: [PATCH 23/26] mfd: ab8500-pwm: Enable support for AB8505 PWMLED
 blink
Message-ID: <20130128081301.GX15873@gmail.com>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-24-git-send-email-lee.jones@linaro.org>
 <20130127235348.GT1174@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130127235348.GT1174@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Samuel Ortiz wrote:

> Hi Lee,
> 
> On Tue, Jan 15, 2013 at 12:56:03PM +0000, Lee Jones wrote:
> > From: Naga Radhesh <naga.radheshy@stericsson.com>
> > 
> > Enable support for PWM OUT LED blinking for AB8505. Instead of
> > having 3 pwm instances from ab8500 core file add it as platform data.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Naga Radhesh <naga.radheshy@stericsson.com>
> > Reviewed-by: Arun MURTHY <arun.murthy@stericsson.com>
> > Reviewed-by: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
> > ---
> >  drivers/mfd/ab8500-core.c          |   10 --
> >  drivers/misc/ab8500-pwm.c          |  282 ++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/ab8500/pwmleds.h |   20 +++
> >  include/linux/mfd/abx500/ab8500.h  |    2 +
> >  4 files changed, 304 insertions(+), 10 deletions(-)
> >  create mode 100644 drivers/misc/ab8500-pwm.c
> This pretty much looks like the already existing and PWM API compliant
> drivers/pwm/ab8500-pwm.c. What's the point here ?

This patch pre-dates the new PWM interface.

It's probably the same thing. I'll look into it.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
