Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab3DYNq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:46:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36071 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab3DYNq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:46:57 -0400
Date: Thu, 25 Apr 2013 14:46:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 1/9 v2] crypto: ux500/hash - Prepare clock before
 enabling it
Message-ID: <20130425134636.GP4623@gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
 <1366280825-31136-2-git-send-email-lee.jones@linaro.org>
 <20130419122428.GC3432@gmail.com>
 <CACRpkdYrCA6SduwMJF=7C9hyjP2Or7gxhjVFtLshdzkbYnxX1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYrCA6SduwMJF=7C9hyjP2Or7gxhjVFtLshdzkbYnxX1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Fri, Apr 19, 2013 at 2:24 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > Slight change of plan for v2.
> >
> > Now we're doing a seperate clk_prepare(), as the clk_enable() in the
> > previous patch turned out to be called inside a spin_lock().
> >
> > Arnd, can you confirm your Ack please?
> 
> Do you really want letters to Arnd to be part of the commit log?
> 
> >
> > ---
> 
> Note: stuff following the three dashes (---) will be *omitted*
> from the change log. This seems to be turned upside-down.

Ah, I didn't know that, thanks.

This patch wasn't due for 'plucking', just reviewing.

> > crypto: ux500/hash - Prepare clock before enabling it
> >
> > If we fail to prepare the ux500-hash clock before enabling it the
> > platform will fail to boot. Here we insure this happens.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Andreas Westin <andreas.westin@stericsson.com>
> > Cc: linux-crypto@vger.kernel.org
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Pls include Ulf Hansson <ulf.hansson@linaro.org> on this patch.

Sure.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
