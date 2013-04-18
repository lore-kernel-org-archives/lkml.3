Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936456Ab3DRRd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:33:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936119Ab3DRRd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:33:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] spi/s3c64xx: Fix non-dmaengine usage
Date: Thu, 18 Apr 2013 19:33:21 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
References: <1366304814-19428-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1366304814-19428-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181933.21598.arnd@arndb.de>
X-Provags-ID: V02:K0:4qSUdGH3/DuykEry6UHUOxEOaiBqnPMI/Z1pCYYkXuD
 0q4Ly1/Kd9+Nn8euf9I6QtkDlGrEgoNFrQYYrkt/7wE2v1WCRC
 8LSBOMa1wzT2vthfld5Xpar++fTx1KuO610aTm0T1TrO7SSx2x
 Y9PZeknIFwFMTYYhsRcVSjPoLpm31dPtayPF13gOdln4vORxAe
 tt2zYdN4R8+S0dxikHe30NaKqh/9sdUyewiNexRmtIs2ettEPW
 EgzlhhxVvELPwvHsrUkKCqaS+f5ECS3YGQYTbq9qPyTe0sWU5n
 bjEnQ0pQdhkeT/fj15SnrgkBBBvb+EUXSdpeBFBqNLHZqVexjW
 MOrWqe8NeoXAHCSdQdt0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Mark Brown wrote:
> The multiplatform conversion in commit 788437 (spi: s3c64xx: move to
> generic dmaengine API) tested for the use of the Samsung-specific DMA
> API with SAMSUNG_DMADEV when in fact S3C_DMA should be used. This
> renderd DMA based transfers non-functional on platforms not using
> dmaengine.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Sorry for the confusion on my part. I thought that S3C_DMA was referring
to just the S3C specific functionality while SAMSUNG_DMADEV was the
wrapper around it, while in truth SAMSUNG_DMADEV is the wrapper around
just the dmaengine API.

	Arnd
