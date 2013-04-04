Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763560Ab3DDHUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:20:23 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:50838 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763038Ab3DDHUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:20:22 -0400
Date: Thu, 4 Apr 2013 08:20:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 4/9] ARM: ux500: Move Snowball's thermal DT node into
 existing PRCMU one
Message-ID: <20130404072016.GA3004@gmail.com>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
 <1364908916-29803-4-git-send-email-lee.jones@linaro.org>
 <CACRpkdar=xD34yaMP2gOfUPkpxOhDymS6zTedKOEW7j2DNHusA@mail.gmail.com>
 <CACRpkda08Joe9aXRgYDUs622GELL+O1vZSnzzCBa++m1zZZi=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda08Joe9aXRgYDUs622GELL+O1vZSnzzCBa++m1zZZi=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Apr 2013, Linus Walleij wrote:

> On Wed, Apr 3, 2013 at 10:38 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Tue, Apr 2, 2013 at 3:21 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >
> >> When the thermal DT node was inserted a new PRCMU node was created;
> >> however, one already exists in the Snowball DTS file. Here we
> >> amalgamate the two into a single consolidated node.
> >>
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > Patch applied.
> 
> After applying this I get this:
> 
>   DTC     arch/arm/boot/dts/snowball.dtb
> Error: /home/elinwal/linux-stericsson/arch/arm/boot/dts/snowball.dts:351.3-352.1
> syntax error
> FATAL ERROR: Unable to parse input tree
> make[3]: *** [arch/arm/boot/dts/snowball.dtb] Error 1
> make[2]: *** [dtbs] Error 2
> make[1]: *** [sub-make] Error 2
> make[1]: Leaving directory `/home/elinwal/linux-stericsson'
> make: *** [build-dtbs] Error 2
> 
> Does not appear prior to applying patch.

That doesn't really tell me anything.

Can you paste the hunk to which the error is referring please?

> It doesn't quiet apply cleanly either, what is this based on?

It's based on 'arm-soc/fixes', which should be appearing in Mainline
rc:s any day now.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
