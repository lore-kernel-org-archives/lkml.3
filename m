Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbaHZHeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:34:13 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:35050 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHZHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:34:11 -0400
Date: Tue, 26 Aug 2014 15:34:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DRBG: fix sparse warning for cpu_to_be[32|64]
Message-ID: <20140826073401.GA3962@gondor.apana.org.au>
References: <53fc2da5.AS8xtJ0DprRMVjVq%fengguang.wu@intel.com>
 <1803846.LZmvEct3qr@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1803846.LZmvEct3qr@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 09:32:24AM +0200, Stephan Mueller wrote:
> The sparse tool complained that the cpu_to_be[32|64] functions return
> __be[32|64] instead of __u32 or __u64. The patch replaces the __u32 and
> __u64 with __be32 and __be64.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
