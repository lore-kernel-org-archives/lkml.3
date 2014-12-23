Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaLWVPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:15:35 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:52639 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaLWVPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:15:33 -0500
Date: Wed, 24 Dec 2014 08:15:19 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, linux-crypto@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] MIPS/crypto: MD5 for OCTEON
Message-ID: <20141223211519.GA3051@gondor.apana.org.au>
References: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 10:53:57PM +0200, Aaro Koskinen wrote:
> Hi,
> 
> This adds accelerated MD5 cryptoapi module for OCTEON.
> 
> Tested with 3.19-rc1 on EdgeRouter Lite (OCTEON+) and EdgeRouter Pro
> (OCTEON2) by running selftest, tcrypt and also by sending TCP MD5SIG
> traffic between OCTEON <-> X86 box.
> 
> Below figures show the improvement on ER Lite compared to md5-generic
> (calculated from output of tcrypt mode=402).

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
