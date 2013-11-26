Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3KZK2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:28:11 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:47391 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3KZK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:28:07 -0500
MIME-Version: 1.0
In-Reply-To: <1385048076-7875-2-git-send-email-grygorii.strashko@ti.com>
References: <1385048076-7875-1-git-send-email-grygorii.strashko@ti.com> <1385048076-7875-2-git-send-email-grygorii.strashko@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 26 Nov 2013 15:57:44 +0530
Message-ID: <CA+V-a8udLPx6y74yNdYxZkDu0vOPHj-nLELBANkVUM7=LX3VcQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: davinci: get rid of DAVINCI_N_GPIO
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 9:04 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> Since Davinci GPIO driver is moved to support gpiolib it has to use
> ARCH_NR_GPIOS (can be configured using CONFIG_ARCH_NR_GPIO Kconfig
> option) configuration instead of any mach/platform specific options.
>
> Hence, replace private DAVINCI_N_GPIO with common ARCH_NR_GPIOS. This is
> safe because default value for ARCH_NR_GPIOS=256 and maximum number of
> supported GPIOs for Davinci is DAVINCI_N_GPIO=144.
>
> More over, this is one of steps to re-use Davinci GPIO driver by other
> mach/platform.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
