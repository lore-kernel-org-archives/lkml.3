Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3KKPqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:46:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41454 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3KKPqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:46:31 -0500
Message-ID: <5280FB19.4020204@ti.com>
Date: Mon, 11 Nov 2013 17:43:21 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/2] DaVinci: GPIO: fixes
References: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar, Prabhakar Lad

On 11/08/2013 08:45 AM, Prabhakar Lad wrote:> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch series fixes gpio driver regestration
> and offset check for unbanked gpio.
> 
> Lad, Prabhakar (2):
>    gpio: davinci: Fix a check for unbanked gpio
>    ARM: davinci: Fix number of resources passed to
>      davinci_gpio_register() call

I've verified both patches - looks ok. 
Patch 1 - restores unbanked GPIO IRQs functionality
Patch 2 - allows to register GPIO Platform devices and boot without issues.

Could we move forward with these patches?

> 
>   arch/arm/mach-davinci/dm355.c  |    2 +-
>   arch/arm/mach-davinci/dm365.c  |    2 +-
>   arch/arm/mach-davinci/dm644x.c |    2 +-
>   arch/arm/mach-davinci/dm646x.c |    2 +-
>   drivers/gpio/gpio-davinci.c    |    4 +++-
>   5 files changed, 7 insertions(+), 5 deletions(-)
> 

