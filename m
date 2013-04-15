Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3DOKrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:47:12 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39677 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3DOKrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:47:10 -0400
MIME-Version: 1.0
In-Reply-To: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 15 Apr 2013 12:47:09 +0200
Message-ID: <CACRpkdauTuDhEq7H9DPLTGwQsZvpOrcJ62Kk7j6BkLMn8CxqVQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: ux500: Move DMA40 platform data includes file
 out to include/
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

On Mon, Apr 8, 2013 at 5:23 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The pin names for DB8500 based platforms need to be moved out of

"pin names" ???

> ux500 platform data and into the new proper location in include/
> linux/platform_data/. This way we an reference them from other
> external locations, such as the main DMA50 driver(s).
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

(...)
>  rename arch/arm/mach-ux500/ste-dma40-db8500.h => include/linux/platform_data/dma-ste-dma40-db8500.h (98%)

Those are the DB8500 DMA channel definitions...

I will not interfere with the fruitful discussion with Arnd on this
subject though, I suspect he's right.

Yours,
Linus Walleij
