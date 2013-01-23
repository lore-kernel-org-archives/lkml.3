Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3AWXXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:23:40 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:33686 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751143Ab3AWXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:23:32 -0500
Date: Thu, 24 Jan 2013 10:23:16 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        linux-iio@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 23 (mtd/ubi and iio and
 crypto/crc32[c])
Message-ID: <20130123232316.GB25726@gondor.apana.org.au>
References: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au>
 <51006DC9.30802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51006DC9.30802@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 03:10:01PM -0800, Randy Dunlap wrote:
> On 01/22/13 22:43, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130122:
> > 
> 
> 
> on i386:
> 
> ERROR: "crc32_le" [drivers/mtd/ubi/ubi.ko] undefined!
> ERROR: "iio_triggered_buffer_setup" [drivers/iio/adc/max1363.ko] undefined!
> ERROR: "iio_triggered_buffer_cleanup" [drivers/iio/adc/max1363.ko] undefined!
> ERROR: "__crc32c_le" [crypto/crc32c.ko] undefined!
> ERROR: "crc32_le" [crypto/crc32.ko] undefined!

Weird.  You do have CONFIG_CRC32 selected, so did it compile
a lib/crc32.ko or not?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
