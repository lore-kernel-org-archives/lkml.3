Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbbAORXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:23:16 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65458 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbbAORXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:23:14 -0500
MIME-Version: 1.0
In-Reply-To: <1421163897-8020-5-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-5-git-send-email-xlpang@126.com>
Date: Thu, 15 Jan 2015 18:23:13 +0100
Message-ID: <CACRpkdZsgMrX4KfjFicugOX4=vrkJKVgOUAmV9YXQbGdZJVsaw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/9] rtc/ab3100: Update driver to address
 y2038/y2106 issues
From: Linus Walleij <linus.walleij@linaro.org>
To: Xunlei Pang <xlpang@126.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 4:44 PM, Xunlei Pang <xlpang@126.com> wrote:

> From: Xunlei Pang <pang.xunlei@linaro.org>
>
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
