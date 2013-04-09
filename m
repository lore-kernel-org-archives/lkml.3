Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936190Ab3DIH7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:59:05 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59885 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934794Ab3DIH7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <1363674681-4015-4-git-send-email-sachin.kamat@linaro.org>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
	<1363674681-4015-4-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 9 Apr 2013 09:59:02 +0200
Message-ID: <CACRpkdb4qEYjJvz5AN_3Fn+TwPO4oXeEWhV+hWB6SkXTWwCSYA@mail.gmail.com>
Subject: Re: [PATCH 4/5] pinctrl: ab8540: Staticize some symbols
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
> drivers/pinctrl/pinctrl-ab8540.c:302:28: warning:
> symbol 'ab8540_alternate_functions' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-ab8540.c:379:32: warning:
> symbol 'ab8540_gpio_irq_cluster' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@stericsson.com>

Patch applied with Patrice's ACK.

Yours,
Linus Walleij
