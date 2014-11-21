Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaKUUrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:47:40 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41218 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaKUUri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:47:38 -0500
MIME-Version: 1.0
In-Reply-To: <1416602417-7337-1-git-send-email-oded.gabbay@amd.com>
References: <1416602417-7337-1-git-send-email-oded.gabbay@amd.com>
Date: Fri, 21 Nov 2014 15:47:37 -0500
Message-ID: <CADnq5_NhrZKthZruOQPPpzKHCTWuR5_P21gSQhP-TeL+j=gZig@mail.gmail.com>
Subject: Re: [PATCH] amdkfd: Remove DRM_AMDGPU dependency from Kconfig
From: Alex Deucher <alexdeucher@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        Paul Bolle <pebolle@tiscali.nl>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 3:40 PM, Oded Gabbay <oded.gabbay@amd.com> wrote:
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/amd/amdkfd/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/Kconfig b/drivers/gpu/drm/amd/amdkfd/Kconfig
> index e13c67c..8dfac37 100644
> --- a/drivers/gpu/drm/amd/amdkfd/Kconfig
> +++ b/drivers/gpu/drm/amd/amdkfd/Kconfig
> @@ -4,6 +4,6 @@
>
>  config HSA_AMD
>         tristate "HSA kernel driver for AMD GPU devices"
> -       depends on (DRM_RADEON || DRM_AMDGPU) && AMD_IOMMU_V2 && X86_64
> +       depends on DRM_RADEON && AMD_IOMMU_V2 && X86_64
>         help
>           Enable this if you want to use HSA features on AMD GPU devices.
> --
> 2.1.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
