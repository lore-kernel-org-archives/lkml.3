Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab3ECTvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:51:09 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34984 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3ECTvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-8-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-8-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 21:51:07 +0200
Message-ID: <CACRpkda1ELOH_aHcmy1LOs3XpWrwdtOhQWpEXx5Uik5yOJVbng@mail.gmail.com>
Subject: Re: [PATCH 07/63] dmaengine: ste_dma40: Assign memcpy channels in the driver
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

> The channels reserved for memcpy are the same for all currently
> supported platforms. With this in mind, we can ease the platform
> data passing requirement by moving these assignments out from
> platform code and place them directly into the driver.
>
> Acked-by: Vinod Koul <vnod.koul@intel.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied this to my ux500-dma40 branch, then applied the just mailed
fixup patch immediately after it.

Let's see how far ahead we get before I run into merge conflicts because
of this :-)

Yours,
Linus Walleij
