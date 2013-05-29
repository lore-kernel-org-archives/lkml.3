Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965842Ab3E2L5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:57:37 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33290 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965730Ab3E2L5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:57:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130528162715.GB28253@arwen.pp.htv.fi>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-21-git-send-email-lee.jones@linaro.org>
	<CACRpkdYjjDp+7hzGtAchyy3+5Vxc8jK5THGCETkAO_V9Hj9Ssw@mail.gmail.com>
	<20130528162715.GB28253@arwen.pp.htv.fi>
Date: Wed, 29 May 2013 13:57:33 +0200
Message-ID: <CACRpkdZn14Gn-YEeHJHre6Sr4JU-xjOeLFgM8OjX7M5qnKudTg@mail.gmail.com>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 6:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, May 15, 2013 at 07:18:01PM +0200, Linus Walleij wrote:

>> I can't merge any of this without Felipes ACKs in any
>> case.
>
> Do you want to take this yourself ? I haven't fully read the series yet,
> but seems like this depends on the rest of the series. If you want to
> take it, let me know I can ack the patches as soon as I'm done
> reviewing.

Yes please. They are dependent on a stash of patches that that
has recently landed in the ARM SoC tree, so currently they need
to follow those through the same tree, which is where I funnel
all the ux500 stuff.

Yours,
Linus Walleij
