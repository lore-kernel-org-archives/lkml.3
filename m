Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377Ab3EBVUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:20:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761462Ab3EBVUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:20:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/2] clk: add of_clk_provider stubs to enable clk-si5351 on non OF
Date: Thu, 2 May 2013 23:20:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Stephen Warren <swarren@nvidia.com>, Daniel Mack <zonque@gmail.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Marek Belisko <marek.belisko@streamunlimited.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1367369910-20402-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1367369910-20402-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305022320.00769.arnd@arndb.de>
X-Provags-ID: V02:K0:DqBciXiz21I8o5nTfnuyDxHO+oxmOT6ZrvfT1MKKDFt
 J8hNt0VQi9T6HXuH/ZA9E4H34dQ+KxA9E2jkEid/Z8Gp9329An
 FeBR0h860apzqj4yoavndOhKAL6zjmuZyo1NSAHkpxsGU5z9+O
 Ep8xOWarOp/ReGh/vpYZtPRh4uHSGDUkQn95VojYqW+1nm7bHp
 6xNcRVJzfo7bm7Q1JRBElr8/sUyljIRwURaqLJGoLNUed3R4x5
 YAQRkaIlDgxYi3Er4pfLRf1vIGJyr94vulVhorGu8LqzFpTSwl
 iYm+9b33q4J+mgJ06SgJsBNk7SVGeRH5gNjHeGcu940nhiou8X
 JwCRzZisVOJj08aYDuBg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 May 2013, Sebastian Hesselbarth wrote:
> 
> Yesterday 02:58:27
> Enabling drivers that provide clocks on DT on platforms that don't have
> CONFIG_OF set fails due to compilation errors. This patch set first adds
> some stubs for of_clk_provider functions if CONFIG_OF is not set. Second
> it allows those platforms to build and use clk-si5351 i2c clock driver
> by removing the dependency on CONFIG_OF.
> 
> The above approach has been suggested by Arnd Bergmann and replaces the
> corresponding Kconfig patch for clk-si5351 posted earlier. It has been
> compile tested with allmodconfig on x86_64 for post v3.9.
> 
> Sebastian Hesselbarth (2):
>   clk: add non CONFIG_OF routines for clk-provider
>   clk: si5351: Allow to build without CONFIG_OF
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
