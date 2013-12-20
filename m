Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422644Ab3LTOIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:08:24 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:54734 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab3LTOIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:08:22 -0500
Date: Fri, 20 Dec 2013 22:08:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S.Miller" <davem@davemloft.net>,
        Erdinc Ozturk <erdinc.ozturk@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Huang Ying <ying.huang@intel.com>,
        Alessandro Salvatori <sandr8@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: AVX and AVX2 version of AESNI-GCM encode and
 decode
Message-ID: <20131220140802.GC356@gondor.apana.org.au>
References: <1386800921.2624.9.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386800921.2624.9.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 02:28:41PM -0800, Tim Chen wrote:
> We have added AVX and AVX2 routines that optimize AESNI-GCM encode/decode.
> These routines are optimized for encrypt and decrypt of large buffers.
> In tests we have seen up to 6% speedup for 1K, 11% speedup for 2K and
> 18% speedup for 8K buffer over the existing SSE version.  These routines
> should provide even better speedup for future Intel x86_64 cpus.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
