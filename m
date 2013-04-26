Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3DZNm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:42:27 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58329 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3DZNm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:42:26 -0400
Date: Fri, 26 Apr 2013 14:42:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 32/32] ARM: ux500: Move SDI (MMC) and UART devices under
 more descriptive heading
Message-ID: <20130426134214.GC31899@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-33-git-send-email-lee.jones@linaro.org>
 <CACRpkdbxwPh+j_=CBFeH83n0XHSbcShnZ7Reb54+5cWYL-j3-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbxwPh+j_=CBFeH83n0XHSbcShnZ7Reb54+5cWYL-j3-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:12 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Now DMA DT bindings exist and are in use by he MMC and UART drivers, it
> > should be possible to remove them from the auxdata structure. However,
> > after doing so the drivers fail. Something must be reliant on the dev
> > name applied by using auxdata; probably common clk.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> You can remove "probably" from that sentence. Common clock is
> still relying on dev_name() to match the device name.
> 
> There are some example of how to fix this, I recently sent a patch
> series fixing DT probed clocks for the Nomadik, check it out.

You could have me some time here by giving me the $SUBJECT. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
