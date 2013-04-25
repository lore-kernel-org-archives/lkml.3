Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab3DYLth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:49:37 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:63330 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab3DYLtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:49:36 -0400
Date: Thu, 25 Apr 2013 12:49:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 30/32] ARM: ux500: Supply MMC DMA configuration via
 Device Tree
Message-ID: <20130425114931.GJ4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-31-git-send-email-lee.jones@linaro.org>
 <CACRpkdbYXxkC2y9zCNcMAAmmQ7+3V0Y=hq7zgtp5L=Ts9QzpQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbYXxkC2y9zCNcMAAmmQ7+3V0Y=hq7zgtp5L=Ts9QzpQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:12 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > When requesting a channel, a DMA client needs to pass some pieces of
> > information such as; request channel, device type, channel type and
> > direction etc. Normally we do this in the form of platform data, but
> > when DT is enabled we need to pass it using the driver's bindings
> > instead.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> This requires that the pending MMCI patch get merged *first* right?

No, it doesn't. There is no harm in applying this *before*.

It will just lay dormant until it is.

> So you need to make sure Russell will merge that (or ACK it
> and include it) before you send any pull requests to me.
> 
> Apart from that it looks allright:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
