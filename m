Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967892Ab3E3IM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:12:26 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43695 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967714Ab3E3IMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:12:18 -0400
Date: Thu, 30 May 2013 09:12:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>,
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
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Message-ID: <20130530081211.GA1915@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
 <20130529175741.GG21290@arwen.pp.htv.fi>
 <CACRpkda3d9_XvqRmy0nbWyri2xC3Qst2U2Sv=UDxV4w-UxK_JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda3d9_XvqRmy0nbWyri2xC3Qst2U2Sv=UDxV4w-UxK_JQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Linus Walleij wrote:

> On Wed, May 29, 2013 at 7:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Wed, May 15, 2013 at 10:51:43AM +0100, Lee Jones wrote:
> >> For all ux500 based platforms the maximum number of end-points are used.
> >> Move this knowledge into the driver so we can relinquish the burden from
> >> platform data. This also removes quite a bit of complexity from the driver
> >> and will aid us when we come to enable the driver for Device Tree.
> >>
> >> Cc: Felipe Balbi <balbi@ti.com>
> >> Cc: linux-usb@vger.kernel.org
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > for drivers/usb/musb
> >
> > Acked-by: Felipe Balbi <balbi@ti.com>
> 
> Is that only for this patch 20/39 or also 21, 22 & 23?
> 
> Poke us if we should re-send them...

I read this as all patches in the series "for drivers/usb/musb".

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
