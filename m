Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3K2Ple (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:41:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41515 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3K2Plc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:41:32 -0500
Message-ID: <5298B5AA.8030301@ti.com>
Date: Fri, 29 Nov 2013 10:41:30 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <prabhakar.csengg@gmail.com>, <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] gpio: davinci: preparation fixes and updates to reuse
 it for Keystone
References: <1385048076-7875-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1385048076-7875-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 November 2013 10:34 AM, Grygorii Strashko wrote:
> This series is a preparation step for reusing Davinci GPIO driver
> for Keystone SoCs.
> And it's been created in order to break the strict dependency of
> Davinci GPIO driver from Davinci platform code.
> 
> Based on patch:
> http://www.spinics.net/lists/kernel/msg1632405.html
> 
> Grygorii Strashko (2):
>   gpio: davinci: get rid of DAVINCI_N_GPIO
>   gpio: introduce GPIO_DAVINCI kconfig option
> 
>  drivers/gpio/Kconfig        |    7 +++++++
>  drivers/gpio/Makefile       |    2 +-
>  drivers/gpio/gpio-davinci.c |    4 ++--
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
Thanks Grygorii and clean-up is inline as discussed off-list.
FWIW,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

