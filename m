Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbaKTOnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:43:21 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:52984 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbaKTOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:43:20 -0500
Date: Thu, 20 Nov 2014 22:43:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yazen Ghannam <yazen.ghannam@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: crypto: Add ARM64 CRC32 hw accelerated module
Message-ID: <20141120144315.GA32061@gondor.apana.org.au>
References: <1416417577-27495-1-git-send-email-yazen.ghannam@linaro.org>
 <CA+dbMpuXC58d_CPYfzYEOjKkP04ZgcxBj6qtfxFfDJK95BxD3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+dbMpuXC58d_CPYfzYEOjKkP04ZgcxBj6qtfxFfDJK95BxD3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 07:42:23AM -0600, Yazen Ghannam wrote:
> +linux-arm-kernel@lists.infradead.org
> 
> On Wed, Nov 19, 2014 at 11:19 AM, Yazen Ghannam <yazen.ghannam@linaro.org>
> wrote:
> 
> > This module registers a crc32 algorithm and a crc32c algorithm
> > that use the optional CRC32 and CRC32C instructions in ARMv8.
> >
> > Tested on AMD Seattle.
> >
> > Improvement compared to crc32c-generic algorithm:
> > TCRYPT CRC32C speed test shows ~450% speedup.
> > Simple dd write tests to btrfs filesystem show ~30% speedup.
> >
> > Signed-off-by: Yazen Ghannam <yazen.ghannam@linaro.org>
> > Acked-by: Steve Capper <steve.capper@linaro.org>
> > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
