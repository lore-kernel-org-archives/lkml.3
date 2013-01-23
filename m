Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3AWJqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:46:43 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54299 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3AWJql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:46:41 -0500
MIME-Version: 1.0
In-Reply-To: <1358775323-8155-1-git-send-email-lee.jones@linaro.org>
References: <1358775323-8155-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 23 Jan 2013 10:46:40 +0100
Message-ID: <CACRpkdbWVVW98upGcqCsbNXPU9Q2m5VFe71GwngBni4ih+m8_w@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Enable Snowball's GPIO controlled
 Ethernet regulator in DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 2:35 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The Snowball Board's Ethernet chip is configured in a slightly
> non-standard way. Its SoC has an address space usually reserved
> for a NOR-flash device. However, on the Snowball, that external
> bus is populated by the SMSC9115 Ethernet chip. So, to power on
> the Ethernet chip, we have to enable the GPIO controlled
> regulator which usually controls the NOR-flash. In this patch
> we inform the Snowball's Device Tree which GPIO is used to
> operate it.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess you will funnel this to ARM SoC with other DT patches?

Yours,
Linus Walleij
