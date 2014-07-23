Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaGWNgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:36:20 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:46256 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaGWNgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:36:18 -0400
Date: Wed, 23 Jul 2014 21:36:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] drivers/crypto/Kconfig: Let 'DEV_QCE' depend on both
 HAS_DMA and HAS_IOMEM
Message-ID: <20140723133615.GD29756@gondor.apana.org.au>
References: <53C1F692.4000105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C1F692.4000105@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 11:01:38AM +0800, Chen Gang wrote:
> 'DEV_QCE' needs both HAS_DMA and HAS_IOMEM, so let it depend on them.
> 
> The related error (with allmodconfig under score):
> 
>     MODPOST 1365 modules
>   ERROR: "devm_ioremap_resource" [drivers/crypto/qce/qcrypto.ko] undefined!
>   ERROR: "dma_map_sg" [drivers/crypto/qce/qcrypto.ko] undefined!
>   ERROR: "dma_set_mask" [drivers/crypto/qce/qcrypto.ko] undefined!
>   ERROR: "dma_supported" [drivers/crypto/qce/qcrypto.ko] undefined!
>   ERROR: "dma_unmap_sg" [drivers/crypto/qce/qcrypto.ko] undefined!
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
