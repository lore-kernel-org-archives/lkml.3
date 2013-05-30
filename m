Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223Ab3E3IeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:34:09 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59310 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967903Ab3E3IeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:34:01 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-24-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-24-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 10:34:00 +0200
Message-ID: <CACRpkdbCx4br+2VH7hoPBPUF6Xpb+WDu2kDxUQAGFJxEHk8ffg@mail.gmail.com>
Subject: Re: [PATCH 23/39] usb: musb: ux500: harden checks for platform data
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
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> In its current state, the ux500-musb driver uses platform data pointers
> blindly with no prior checking. If no platform data pointer is passed
> this will Oops the kernel. In this patch we ensure platform data and
> board data are present prior to using them.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Tentatively applied with Felipe's ACK.

Yours,
Linus Walleij
