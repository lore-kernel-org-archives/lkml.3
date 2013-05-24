Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3EXG1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 02:27:53 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48854 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3EXG1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 02:27:52 -0400
MIME-Version: 1.0
In-Reply-To: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
References: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
Date: Fri, 24 May 2013 08:27:52 +0200
Message-ID: <CACRpkdapJ4Y0fxHa_j0WaOtWEom3y+bv2aA3qVBnLBjHsB2tOA@mail.gmail.com>
Subject: Re: [PATCH 0/6] crypto: ux500/[cryp|hash] - Enable Device Tree
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

On Thu, May 16, 2013 at 1:27 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch-set simply allows ux500-[cryp|hash] drivers to be probed
> when Snowball is running with Device Tree enabled.
>
> Linus,
>
> Feel free to split the DTS changes out into your ux500-devicetree branch.

I have tentatively applied 1, 2, 3 & 4 to my device tree branch.

5 & 6 need bindings and ACKs.

I can merge them through the ux500 devicetree branch as well I
think, they "should" be orthogonal to other (DMA-related) changes
AFAICT.

Yours,
Linus Walleij
