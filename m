Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaAAGHB (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 1 Jan 2014 01:07:01 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:42116 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaAAGHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 01:07:00 -0500
Date: Wed, 1 Jan 2014 14:06:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>
Subject: Re: [ARM] Fix kernel compile error: drivers/crypto/ixp4xx_crypto.c.
Message-ID: <20140101060651.GA22534@gondor.apana.org.au>
References: <m3d2kduwd7.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3d2kduwd7.fsf@t19.piap.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 11:51:16AM +0100, Krzysztof Hałasa wrote:
> drivers/crypto/ixp4xx_crypto.c: In function 'ixp_module_init':
> drivers/crypto/ixp4xx_crypto.c:1419:2: error: 'dev' undeclared (first use in this function)
> 
> Now builds. Not tested on real hw.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
