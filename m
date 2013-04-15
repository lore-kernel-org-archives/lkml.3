Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3DOK6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:58:07 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42223 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3DOK6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:58:06 -0400
Date: Mon, 15 Apr 2013 11:58:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/5] ARM: ux500: Move DMA40 platform data includes file
 out to include/
Message-ID: <20130415105800.GC6512@gmail.com>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdauTuDhEq7H9DPLTGwQsZvpOrcJ62Kk7j6BkLMn8CxqVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdauTuDhEq7H9DPLTGwQsZvpOrcJ62Kk7j6BkLMn8CxqVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Linus Walleij wrote:

> On Mon, Apr 8, 2013 at 5:23 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The pin names for DB8500 based platforms need to be moved out of
> 
> "pin names" ???
> 
> > ux500 platform data and into the new proper location in include/
> > linux/platform_data/. This way we an reference them from other
> > external locations, such as the main DMA50 driver(s).
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> (...)
> >  rename arch/arm/mach-ux500/ste-dma40-db8500.h => include/linux/platform_data/dma-ste-dma40-db8500.h (98%)
> 
> Those are the DB8500 DMA channel definitions...
> 
> I will not interfere with the fruitful discussion with Arnd on this
> subject though, I suspect he's right.

It's okay, I've since removed this patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
