Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab3ECVMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:12:07 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:45568 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760851Ab3ECVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:12:05 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-30-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-30-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 23:12:04 +0200
Message-ID: <CACRpkdY8N1_xH8RAnqA-9W9cUyX5QVs4WYJERc31TK2r6Yz8qA@mail.gmail.com>
Subject: Re: [PATCH 29/63] ARM: ux500: Stop passing MMC's platform data for
 Device Tree boots
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

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> It was required to pass DMA channel configuration information to the
> MMC driver before the new DMA API was in place. Now that it is, and
> is fully compatible with Device Tree we can stop doing that.
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Can't apply this because of dependencies to be merged
by Russell.

Yours,
Linus Walleij
