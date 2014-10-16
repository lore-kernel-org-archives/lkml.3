Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaJPOCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:02:01 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:61064 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaJPOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:02:00 -0400
MIME-Version: 1.0
In-Reply-To: <1413467180-32515-1-git-send-email-riku.voipio@linaro.org>
References: <1413467180-32515-1-git-send-email-riku.voipio@linaro.org>
Date: Thu, 16 Oct 2014 17:01:59 +0300
Message-ID: <CAAqcGHnJCBMYtjgBfnczKvGaqEUmBnHJJWfZRUQZ1yOJpd0z7A@mail.gmail.com>
Subject: Re: [PATCH] gcov: add ARM64 to GCOV_PROFILE_ALL
From: Riku Voipio <riku.voipio@linaro.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Riku Voipio <riku.voipio@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2014 16:46, Riku Voipio <riku.voipio@linaro.org> wrote:
> Following up the arm testing of gcov, turns out gcov on ARM64
> works fine as well. Only change needed is adding ARM64 to Kconfig
> depends.
>
> Tested with qemu and mach-virt
>
> Signed-off-by: Riku Voipio <riku.voipio@linaro.org>

Sorry for the noise, this is the wrong patch. Will send the updated
one a moment.

Riku

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
>         bool "Profile entire Kernel"
>         depends on GCOV_KERNEL
> -       depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM
> +       depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM || ARM64
>         default n
>         ---help---
>         This options activates profiling for the entire kernel.
> --
> 2.0.1
>
