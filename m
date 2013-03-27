Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3C0WKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:10:44 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:55663 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3C0WKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <003901ce293f$76639800$632ac800$%han@samsung.com>
References: <003901ce293f$76639800$632ac800$%han@samsung.com>
Date: Wed, 27 Mar 2013 23:10:42 +0100
Message-ID: <CACRpkda=_g2Qir05_H4ELrNWM8tVoPQfmZRVdqxjrOs=3EAiXA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: plgpio: add CONFIG_PM_SLEEP to suspend/resume functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 10:59 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
> build warning when CONFIG_PM_SLEEP is not selected. This is because
> sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
> the CONFIG_PM_SLEEP is enabled.
>
> drivers/pinctrl/spear/pinctrl-plgpio.c:645:12: warning: 'plgpio_suspend' defined but not used [-Wunused-function]
> drivers/pinctrl/spear/pinctrl-plgpio.c:684:12: warning: 'plgpio_resume' defined but not used [-Wunused-function]
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Thanks, applied for fixes.

Yours,
Linus Walleij
