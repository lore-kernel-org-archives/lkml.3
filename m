Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3FMG6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:58:51 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:40636 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753550Ab3FMG6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:58:50 -0400
Date: Thu, 13 Jun 2013 14:58:38 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: linux-crypto@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aesni_intel - fix accessing of unaligned memory
Message-ID: <20130613065838.GA1691@gondor.apana.org.au>
References: <20130611191746.GA31945@redhat.com>
 <20130611192522.12995.57979.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611192522.12995.57979.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 10:25:22PM +0300, Jussi Kivilinna wrote:
> The new XTS code for aesni_intel uses input buffers directly as memory operands
> for pxor instructions, which causes crash if those buffers are not aligned to
> 16 bytes.
> 
> Patch changes XTS code to handle unaligned memory correctly, by loading memory
> with movdqu instead.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Tested-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
