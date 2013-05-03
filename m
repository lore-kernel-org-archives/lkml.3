Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742Ab3ECOB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:01:57 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:35428 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762428Ab3ECOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:01:56 -0400
MIME-Version: 1.0
In-Reply-To: <1367484683-3479-1-git-send-email-lee.jones@linaro.org>
References: <1367484683-3479-1-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 16:01:56 +0200
Message-ID: <CACRpkdaeEDHNLFt2z=7L=iFbxbSkbe25mYxCG3+MreLsZZ21SA@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Remove DMA address look-up table
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 10:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> DMA addresses are now passed as part of the dmaengine API by invoking
> dmaengine_slave_config(). So there's no requirement for the DMA40
> driver to look them up in a table provided by platform data. This
> method does not fit in well using Device Tree either.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This goes on top of some other changes right?

Right now the DMA series is confusing me a bit, there is
these 6 patches:
http://marc.info/?l=linux-arm-kernel&m=136698179306642&w=2

Then these 5 patches:
http://marc.info/?l=linux-arm-kernel&m=136740201416293&w=2

And then this single patch.

Where shall I start, i.e. which patches go first?

Can they all be combined into one big series?

Yours,
Linus Walleij
