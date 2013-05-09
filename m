Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3EINBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:01:08 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51572 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3EINBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:01:06 -0400
Date: Thu, 9 May 2013 14:01:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 28/63] ARM: ux500: Stop passing UART's platform data for
 Device Tree boots
Message-ID: <20130509130100.GA12156@gmail.com>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-29-git-send-email-lee.jones@linaro.org>
 <CACRpkdYCABo0AULsiUgwm3g=906iKzp_ZDFKLj=HgDbNK9mNUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYCABo0AULsiUgwm3g=906iKzp_ZDFKLj=HgDbNK9mNUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Linus Walleij wrote:

> On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > It was required to pass DMA channel configuration information to the
> > UART driver before the new DMA API was in place. Now that it is, and
> > is fully compatible with Device Tree we can stop doing that.
> >
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> I can't apply this as it is clearly dependent on a patch to
> drivers/tty/serial/amba-pl011.c that is not yet upstream.

It is now.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
