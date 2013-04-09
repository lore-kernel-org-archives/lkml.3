Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937060Ab3DIH5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:57:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41224 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762080Ab3DIH5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:57:15 -0400
MIME-Version: 1.0
In-Reply-To: <1363674681-4015-3-git-send-email-sachin.kamat@linaro.org>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
	<1363674681-4015-3-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 9 Apr 2013 09:57:15 +0200
Message-ID: <CACRpkdZEyF39KLJacAtg4ppVzpg28wpucJH3udP7wmW+hKirkw@mail.gmail.com>
Subject: Re: [PATCH 3/5] pinctrl: ab9540: Staticize some symbols
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

> Fixes the following warnings:
> drivers/pinctrl/pinctrl-ab9540.c:382:28: warning:
> symbol 'ab9540alternate_functions' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-ab9540.c:457:32: warning:
> symbol 'ab9540_gpio_irq_cluster' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@stericsson.com>

Patch applied with Patrice's ACK.

Yours,
Linus Walleij
