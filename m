Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbaGOJCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:02:18 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34510 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaGOJCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:02:11 -0400
Date: Tue, 15 Jul 2014 18:02:07 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-sh@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: shmobile: dma: Use defines instead of hardcoded
 numbers
Message-ID: <20140715090207.GE17806@verge.net.au>
References: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
 <1403267861-15609-3-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403267861-15609-3-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:37:39PM +0200, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  arch/arm/mach-shmobile/dma-register.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/dma-register.h b/arch/arm/mach-shmobile/dma-register.h
> index 97c40bd9b94f..52a2f66e600f 100644
> --- a/arch/arm/mach-shmobile/dma-register.h
> +++ b/arch/arm/mach-shmobile/dma-register.h
> @@ -52,8 +52,8 @@ static const unsigned int dma_ts_shift[] = {
>  	((((i) & TS_LOW_BIT) << TS_LOW_SHIFT) |\
>  	 (((i) & TS_HI_BIT)  << TS_HI_SHIFT))
>  
> -#define CHCR_TX(xmit_sz) (DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL((xmit_sz)))
> -#define CHCR_RX(xmit_sz) (DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL((xmit_sz)))
> +#define CHCR_TX(xmit_sz) (DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL((xmit_sz)))
> +#define CHCR_RX(xmit_sz) (DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL((xmit_sz)))

I am dropping this patch from the shdma-for-v3.17 branch (which I am
preparing for Vinod) as it depends on a patch in another branch of my tree
(which I am preparing for arm-SoC).

Could you please repost this patch once the other patches
in this tree have been accepted by Vinod.

Thanks
