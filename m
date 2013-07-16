Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab3GPPB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:01:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64029 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab3GPPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:01:27 -0400
Message-ID: <51E56043.1010509@linaro.org>
Date: Tue, 16 Jul 2013 17:01:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, tglx@linutronix.de,
        u.kleine-koenig@pengutronix.de, tomasz.figa@gmail.com,
        linus.walleij@linaro.org, thomas.petazzoni@free-electrons.com,
        arnd@arndb.de
Subject: Re: [PATCH v8] ARM: clocksource: add support for MOXA ART SoCs
References: <1373024773-24574-1-git-send-email-jonas.jensen@gmail.com> <1373985880-23469-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1373985880-23469-1-git-send-email-jonas.jensen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 04:44 PM, Jonas Jensen wrote:
> This patch adds an clocksource driver for the main timer(s)
> found on MOXA ART SoCs.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---

Ok, I will ask you two more things before taking your patch. I missed
them at the previous review, sorry for asking a new version.

1. could you elaborate the patch log: as it is a new driver, a nice
description of the timer hardware would be valuable for people willing
to understand the code (eg. some specificities of the driver).

2. fix the alignment below

Thanks
  -- Daniel

[ ... ]

> +
> +#define TIMER_CR		0x30
> +#define TIMER_INTR_STATE	0x34
> +#define TIMER_INTR_MASK		0x38


[ ... ]

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

