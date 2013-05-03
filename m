Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763476Ab3ECThH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:37:07 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:54521 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760627Ab3ECThE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:37:04 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-7-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-7-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 21:37:04 +0200
Message-ID: <CACRpkdZ+srX-gEimgNYBgvK-qGBGorM4EygWgGdDXBhtBaTFcQ@mail.gmail.com>
Subject: Re: [PATCH 06/63] ARM: ux500: Pass DMA memcpy channels though Device Tree
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

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> It's now possible to configure memcpy channels dynamically with DT.
> We're providing them despite the fact that they're the same as the
> hard-coded channels, as they will be removed once the u8500 platform
> goes DT-only.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-devicetree branch.

Thanks!
Linus Walleij
