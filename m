Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbaDPNtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:49:00 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:52531 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161125AbaDPNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:48:41 -0400
Date: Wed, 16 Apr 2014 21:48:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] hw_random: Move UML_RANDOM at the last position
Message-ID: <20140416134836.GC4684@gondor.apana.org.au>
References: <20140408142731.48c9f92f@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408142731.48c9f92f@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 02:27:31PM +0200, Jean Delvare wrote:
> UML_RANDOM is the only hardware random number generator option which
> does not depend on HW_RANDOM. Having it in the middle of the other
> options breaks the alignment in "make menuconfig". Move it at the last
> position to avoid that.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
