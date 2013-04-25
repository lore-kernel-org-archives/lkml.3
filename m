Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3DYLqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:46:24 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35762 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab3DYLqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:46:23 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-33-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-33-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:46:22 +0200
Message-ID: <CACRpkdbxwPh+j_=CBFeH83n0XHSbcShnZ7Reb54+5cWYL-j3-w@mail.gmail.com>
Subject: Re: [PATCH 32/32] ARM: ux500: Move SDI (MMC) and UART devices under
 more descriptive heading
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:12 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Now DMA DT bindings exist and are in use by he MMC and UART drivers, it
> should be possible to remove them from the auxdata structure. However,
> after doing so the drivers fail. Something must be reliant on the dev
> name applied by using auxdata; probably common clk.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

You can remove "probably" from that sentence. Common clock is
still relying on dev_name() to match the device name.

There are some example of how to fix this, I recently sent a patch
series fixing DT probed clocks for the Nomadik, check it out.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
