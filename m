Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445Ab3ECTdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:33:55 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:46817 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763318Ab3ECTdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-4-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-4-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 21:33:54 +0200
Message-ID: <CACRpkdYrb10bVpcm706NmVs7osM=gy4fT3=qZ3__pfndTWM+bQ@mail.gmail.com>
Subject: Re: [PATCH 03/63] ARM: ux500: Supply UART's DMA configuration via
 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> When requesting a channel, a DMA client needs to pass some pieces of
> information such as; request channel, device type, channel type and
> direction etc. Normally we do this in the form of platform data, but
> when DT is enabled we need to pass it using the driver's bindings
> instead.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-devicetree branch.

Thanks!
Linus Walleij
