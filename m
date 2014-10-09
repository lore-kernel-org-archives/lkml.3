Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbaJIOAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:00:31 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:46955 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaJIOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:00:20 -0400
Message-ID: <543694F4.3070306@linux.vnet.ibm.com>
Date: Thu, 09 Oct 2014 16:00:20 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Riku Voipio <riku.voipio@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gcov: add ARM64 to GCOV_PROFILE_ALL
References: <1412852099-23099-1-git-send-email-riku.voipio@linaro.org>
In-Reply-To: <1412852099-23099-1-git-send-email-riku.voipio@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100914-0025-0000-0000-000001D22E15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good. Andrew, can you pick this change up via your tree?

Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

On 09.10.2014 12:54, Riku Voipio wrote:
> Following up the arm testing of gcov, turns out gcov on ARM64
> works fine as well. Only change needed is adding ARM64 to Kconfig
> depends.
> 
> Tested with qemu and mach-virt
> 
> Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
> ---
>  kernel/gcov/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
> index cf66c5c..3b74087 100644
> --- a/kernel/gcov/Kconfig
> +++ b/kernel/gcov/Kconfig
> @@ -35,7 +35,7 @@ config GCOV_KERNEL
>  config GCOV_PROFILE_ALL
>  	bool "Profile entire Kernel"
>  	depends on GCOV_KERNEL
> -	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM
> +	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM || ARM64
>  	default n
>  	---help---
>  	This options activates profiling for the entire kernel.
> 


-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

