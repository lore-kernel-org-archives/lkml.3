Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbbAUQzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:55:21 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48984 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbbAUQzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:55:05 -0500
MIME-Version: 1.0
In-Reply-To: <1421770899-4136-4-git-send-email-pang.xunlei@linaro.org>
References: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
	<1421770899-4136-4-git-send-email-pang.xunlei@linaro.org>
Date: Wed, 21 Jan 2015 17:55:04 +0100
Message-ID: <CACRpkda3PhOhWPFd5YzfhvqRNUGSDA+=Lkqp1PNE4YPhCTTULQ@mail.gmail.com>
Subject: Re: [rtc-linux] [RFC PATCH v3 3/8] rtc/ab3100: Update driver to
 address y2038/y2106 issues
From: Linus Walleij <linus.walleij@linaro.org>
To: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Richard Henderson <rth@twiddle.net>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 5:21 PM, Xunlei Pang <pang.xunlei@linaro.org> wrote:

> This driver has a number of y2038/y2106 issues.
>
> This patch resolves them by:
> - Replace rtc_tm_to_time() with rtc_tm_to_time64()
> - Replace rtc_time_to_tm() with rtc_time64_to_tm()
> - Change ab3100_rtc_set_mmss() to use rtc_class_ops's set_mmss64()
>
> After this patch, the driver should not have any remaining
> y2038/y2106 issues.
>
> Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
