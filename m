Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3A2WLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:11:07 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:32794 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab3A2WLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:11:05 -0500
MIME-Version: 1.0
In-Reply-To: <1359123276-15833-14-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	<1359123276-15833-14-git-send-email-arnd@arndb.de>
Date: Tue, 29 Jan 2013 23:11:04 +0100
Message-ID: <CACRpkdYoy8teh4Tg3vkKJ2taOxyeBCvQ=HcFKW2XiMRgUXf4Sg@mail.gmail.com>
Subject: Re: [PATCH 13/19] pinctrl: nomadik: nmk_prcm_gpiocr_get_mode may be unused
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 3:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> nmk_prcm_gpiocr_get_mode is only needed for debugfs output at
> the moment, which can be compile-time disabled. Marking
> the function __maybe_unused still gives us compile-time
> coverage, but avoids a gcc warning.
>
> Without this patch, building nhk8815_defconfig results in:
>
> drivers/pinctrl/pinctrl-nomadik.c:676:12: warning: 'nmk_prcm_gpiocr_get_mode' defined but not used [-Wunused-function]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>

Patch applied, thanks!

Linus Walleij
