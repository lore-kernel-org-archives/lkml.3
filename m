Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763526Ab3ECUX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:23:59 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:56477 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763500Ab3ECUX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:23:58 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-20-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-20-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:23:57 +0200
Message-ID: <CACRpkdZexk6a7yaWEzzOkihcHNGY_UQN3hYiz45LK1cuy0ob=g@mail.gmail.com>
Subject: Re: [PATCH 19/63] dmaengine: ste_dma40: Separate Logical Global
 Interrupt Mask (GIM) unmasking
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> During the initial setup of a logical channel, it is necessary to unmask
> the GIM in order to receive generated terminal count and error interrupts.
> We're separating out this required code so it will be possible to move
> the remaining code in d40_phy_cfg(), which is mostly runtime configuration
> into the runtime_config() routine.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

These review comments are only partially accounted for:
http://marc.info/?l=linux-kernel&m=136688761708399&w=2

Please supply a short changelog in the next submission
so I know what was changed and why some things were not
changed and if you split out other changes to other patches
etc etc.

Yours,
Linus Walleij
