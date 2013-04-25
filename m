Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab3DYNou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:44:50 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:35501 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab3DYNot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:44:49 -0400
Date: Thu, 25 Apr 2013 14:44:43 +0100
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
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 5/9] crypto: ux500/cryp - Fix compile error
Message-ID: <20130425134443.GO4623@gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
 <1366280825-31136-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZNFqbHJB7R5zqVzkAn_nV=G+c27YRB7VCQxiMyFTnPbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZNFqbHJB7R5zqVzkAn_nV=G+c27YRB7VCQxiMyFTnPbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:27 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Clearly this driver hasn't been tested, or even enabled in a while.
> >
> > drivers/crypto/ux500/cryp/cryp_core.c:1771:3:
> >         error: request for member ‘pm’ in something not a structure or union
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Andreas Westin <andreas.westin@stericsson.com>
> > Cc: linux-crypto@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> NAK. I already fixed this. It is in v3.9-rc7.

Yes, I saw it when I rebased. I've dropped the patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
