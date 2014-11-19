Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaKSKf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:35:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33111 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaKSKf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:35:26 -0500
Date: Wed, 19 Nov 2014 10:35:22 +0000
From: Will Deacon <will.deacon@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: Re: [PATCH v2 01/13] arm64: PCI/MSI: Use asm-generic/msi.h
Message-ID: <20141119103522.GA15985@arm.com>
References: <1416336788-22634-1-git-send-email-marc.zyngier@arm.com>
 <1416336788-22634-2-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416336788-22634-2-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 06:52:56PM +0000, Marc Zyngier wrote:
> In order to support CONFIG_GENERIC_MSI_IRQ_DOMAIN, we need to
> define msi_alloc_info_t. As the generic version exposed in
> asm-generic/msi.h is perfectly convenient, import this file
> as asm/msi.h.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---

Since this depends on the asm-generic file,

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

>  arch/arm64/include/asm/Kbuild | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
> index dc770bd..e315bd8 100644
> --- a/arch/arm64/include/asm/Kbuild
> +++ b/arch/arm64/include/asm/Kbuild
> @@ -28,6 +28,7 @@ generic-y += local64.h
>  generic-y += mcs_spinlock.h
>  generic-y += mman.h
>  generic-y += msgbuf.h
> +generic-y += msi.h
>  generic-y += mutex.h
>  generic-y += pci.h
>  generic-y += pci-bridge.h
> -- 
> 2.1.3
> 
> 
