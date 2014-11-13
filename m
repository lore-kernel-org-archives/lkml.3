Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbaKMOeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:34:11 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:50367 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959AbaKMOeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:34:09 -0500
Date: Thu, 13 Nov 2014 22:33:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Marek Vasut <marex@denx.de>, "David S. Miller" <davem@davemloft.net>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "Joy M. Latten" <jmlatten@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 00/13] crypto: Documentation of kernel crypto API
Message-ID: <20141113143335.GA6193@gondor.apana.org.au>
References: <1800066.efQ8hkST4U@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1800066.efQ8hkST4U@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 05:22:00AM +0100, Stephan Mueller wrote:
> Hi,
> 
> The following patch set adds documentation files under Documentation/crypto/
> covering the high-level description of the API. In addition, it contains
> source code comments added to the header files of the kernel crypto API
> documenting the API functions.
> 
> The documentation is provided in a DocBook whose output can be reviewed at:
> 
> http://www.chronox.de/crypto-API/index.html
> 
> Changes v2:

All applied.  Thanks everyone!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
