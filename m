Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3EPHA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:00:26 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:36190 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754949Ab3EPHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:00:23 -0400
Date: Thu, 16 May 2013 15:00:03 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Andreas Westin <andreas.westin@stericsson.com>
Subject: Re: [PATCH 12/39] crypto: ux500/hash - Prepare clock before
 enabling it
Message-ID: <20130516070003.GA6634@gondor.apana.org.au>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-13-git-send-email-lee.jones@linaro.org>
 <CACRpkdYdf1j+V516CigFeGKv1B+Mf4mZk8g3ZwYAwa=rDP=7vg@mail.gmail.com>
 <20130516065355.GA3269@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516065355.GA3269@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 07:53:55AM +0100, Lee Jones wrote:
> On Wed, 15 May 2013, Linus Walleij wrote:
> 
> > On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > > If we fail to prepare the ux500-hash clock before enabling it the
> > > platform will fail to boot. Here we insure this happens.
> > >
> > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > Cc: David S. Miller <davem@davemloft.net>
> > > Cc: Andreas Westin <andreas.westin@stericsson.com>
> > > Cc: linux-crypto@vger.kernel.org
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > This patch seems to be totally independent of the other stuff
> > in the patch series, and it even seems like an -rc fix to me
> > (I don't think the crypto device works without this).
> > 
> > This should go into the crypto tree?
> 
> I agree. 
> 
> > Else please convince Herbert to give his ACK on this
> > before I apply it.
> 
> Pleeeeaasseee Herbert, take this patch! :)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
