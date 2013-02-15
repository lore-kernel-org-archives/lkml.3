Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935559Ab3BOJNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:13:52 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:33051 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab3BOJNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:13:51 -0500
MIME-Version: 1.0
In-Reply-To: <1360849767-1463135-8-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
	<1360849767-1463135-8-git-send-email-arnd@arndb.de>
Date: Fri, 15 Feb 2013 10:13:50 +0100
Message-ID: <CACRpkda2A6upoT30vFfZM+a4dO=7tStVhHj_JoT-Oe16Pvuy=w@mail.gmail.com>
Subject: Re: [PATCH 07/11] ARM: integrator: fix build with INTEGRATOR_AP off
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 2:49 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The conditional declaration of ap_uart_data is broken
> and causes this build error:
>
> In file included from arch/arm/mach-integrator/core.c:35:0:
> arch/arm/mach-integrator/common.h:6:37: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
>
> Turning the check into an constant-expression if(IS_ENABLED()) statement
> creates more readable code and solves this problem as well.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>

Brilliant Arnd, thanks for fixing this!

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
