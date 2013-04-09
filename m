Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936843Ab3DIHwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:52:53 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35113 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935258Ab3DIHww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:52:52 -0400
MIME-Version: 1.0
In-Reply-To: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 9 Apr 2013 09:52:51 +0200
Message-ID: <CACRpkdbiB6_cqrgLE1bGS4M6=AgHLwKYxVkENVNETqhX3_wxeA@mail.gmail.com>
Subject: Re: [PATCH 1/5] pinctrl: abx500: Staticize some symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 7:31 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> These symbols are used only in this file. Without this patch
> we get the following warnings:
> drivers/pinctrl/pinctrl-abx500.c:520:5: warning:
> symbol 'abx500_gpio_request' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-abx500.c:527:6: warning:
> symbol 'abx500_gpio_free' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-abx500.c:614:5: warning:
> symbol 'abx500_gpio_request_enable' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-abx500.c:714:5: warning:
> symbol 'abx500_pin_config_get' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-abx500.c:721:5: warning:
> symbol 'abx500_pin_config_set' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> ---
> This series is compile tested against linux-next tree (20130319).

Patch applied with Patrice's ACK, thanks!

Yours,
Linus Walleij
