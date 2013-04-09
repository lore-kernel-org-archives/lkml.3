Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936910Ab3DIIA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:00:56 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:54736 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935154Ab3DIIAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:00:55 -0400
MIME-Version: 1.0
In-Reply-To: <1363674681-4015-5-git-send-email-sachin.kamat@linaro.org>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
	<1363674681-4015-5-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 9 Apr 2013 10:00:55 +0200
Message-ID: <CACRpkdbt+zaJ_A2Rt=yWXL+pm6dCBCP4rySSYy-NC-kV4Rh=9g@mail.gmail.com>
Subject: Re: [PATCH 5/5] pinctrl: ab8505: Staticize some symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 7:31 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Silences the following warnings:
> drivers/pinctrl/pinctrl-ab8505.c:274:28: warning:
> symbol 'ab8505_alternate_functions' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-ab8505.c:351:32: warning:
> symbol 'ab8505_gpio_irq_cluster' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@stericsson.com>

Patch applied with Patrice's ACK.

Yours,
Linus Walleij
