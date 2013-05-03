Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab3ECOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:09:56 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43149 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501Ab3ECOJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:09:54 -0400
Date: Fri, 3 May 2013 15:09:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] ARM: ux500: Remove DMA address look-up table
Message-ID: <20130503140949.GN24153@gmail.com>
References: <1367484683-3479-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdaeEDHNLFt2z=7L=iFbxbSkbe25mYxCG3+MreLsZZ21SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaeEDHNLFt2z=7L=iFbxbSkbe25mYxCG3+MreLsZZ21SA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Linus Walleij wrote:

> On Thu, May 2, 2013 at 10:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > DMA addresses are now passed as part of the dmaengine API by invoking
> > dmaengine_slave_config(). So there's no requirement for the DMA40
> > driver to look them up in a table provided by platform data. This
> > method does not fit in well using Device Tree either.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> This goes on top of some other changes right?
> 
> Right now the DMA series is confusing me a bit, there is
> these 6 patches:
> http://marc.info/?l=linux-arm-kernel&m=136698179306642&w=2
> 
> Then these 5 patches:
> http://marc.info/?l=linux-arm-kernel&m=136740201416293&w=2
> 
> And then this single patch.

Right. I can prepare one big branch if you like.

> Where shall I start, i.e. which patches go first?
> 
> Can they all be combined into one big series?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
