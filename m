Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab3EOQoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:44:30 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39159 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab3EOQo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:44:27 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-4-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-4-git-send-email-lee.jones@linaro.org>
Date: Wed, 15 May 2013 18:44:26 +0200
Message-ID: <CACRpkdbvhB=7QScU1bCN8wXr7ZOuPX9XYoCjX_a8gFSMCkbm-w@mail.gmail.com>
Subject: Re: [PATCH 03/39] dmaengine: ste_dma40: Don't configure runtime
 configurable setup during allocate
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Rabin Vincent <rabin@rab.in>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Using the dmaengine API, allocating and configuring a channel are two
> separate actions. Here we're removing logical channel configuration from
> the channel allocating routines.

This commit message is also incorrect, but I amended it.

Besides, when I amend commit messages I make sure I really
understand what is going on so no big deal...

> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I still need Vinod's ACK on this before I send it anywhere.

Patch applied!

Yours,
Linus Walleij
