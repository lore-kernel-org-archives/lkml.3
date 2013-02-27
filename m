Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab3B0Ldk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:33:40 -0500
Received: from 8bytes.org ([85.214.48.195]:35937 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704Ab3B0Ldj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:33:39 -0500
Date: Wed, 27 Feb 2013 12:33:36 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, scottwood@freescale.com,
        stuart.yoder@freescale.com
Subject: Re: [PATCH 3/6] powerpc/fsl_pci: Added defines for the FSL PCI
 controller BRR1 register.
Message-ID: <20130227113336.GI26252@8bytes.org>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
 <1361191939-21260-4-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361191939-21260-4-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb 27 12:33:37 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 512def1122971001617433
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 06:22:16PM +0530, Varun Sethi wrote:
> Macros for checking FSL PCI controller version.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
>  arch/powerpc/include/asm/pci-bridge.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
> index 025a130..c12ed78 100644
> --- a/arch/powerpc/include/asm/pci-bridge.h
> +++ b/arch/powerpc/include/asm/pci-bridge.h
> @@ -14,6 +14,10 @@
>  
>  struct device_node;
>  
> +/* FSL PCI controller BRR1 register */
> +#define PCI_FSL_BRR1      0xbf8
> +#define PCI_FSL_BRR1_VER 0xffff
> +


Please merge this patch with the one where you actually make use of
these defines for the first time.


	Joerg


