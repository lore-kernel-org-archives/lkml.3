Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3K2Lek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:34:40 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:59154 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3K2Lei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:34:38 -0500
Date: Fri, 29 Nov 2013 19:34:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Cristian Stoica <cristian.stoica@freescale.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: remove unnecessary includes
Message-ID: <20131129113430.GA9542@gondor.apana.org.au>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
 <20131129020657.GA5650@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 08:49:42AM +0000, Cristian Stoica wrote:
> >From what I could see there is nothing from those includes that is used inside authenc.c.
> The build passes without them.

Just because it compiles it doesn't meant that the files you
removed are unnecessary.

The only file that is really unnecessary here is spinlock.h.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
