Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231Ab3E3Iio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:38:44 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43501 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967904Ab3E3Iif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:38:35 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-26-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-26-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 10:38:34 +0200
Message-ID: <CACRpkdZE-i5v_B7CCVPVNpU+EgCx4D17mZ+OvwAHZXXDBdoi1w@mail.gmail.com>
Subject: Re: [PATCH 25/39] usb: musb: ux500: add device tree probing support
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
        Vinod Koul <vinod.koul@intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch will allow ux500-musb to be probed and configured solely from
> configuration found in Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: linux-usb@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Tentatively applied with Felipe's ACK.

Yours,
Linus Walleij
