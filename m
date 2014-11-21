Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaKUUyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:54:36 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:48363 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaKUUyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:54:35 -0500
MIME-Version: 1.0
In-Reply-To: <1416600479-5767-1-git-send-email-oded.gabbay@amd.com>
References: <1416600479-5767-1-git-send-email-oded.gabbay@amd.com>
Date: Fri, 21 Nov 2014 15:54:34 -0500
Message-ID: <CADnq5_OKSNfTH_kfwR4OgbTdp5twA5EVk6Ec+5SA2=2u=rNwgQ@mail.gmail.com>
Subject: Re: [PATCH] amdkfd: explicitely include io.h in kfd_doorbell.c
From: Alex Deucher <alexdeucher@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        jim.epost@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 3:07 PM, Oded Gabbay <oded.gabbay@amd.com> wrote:
> This patch fixes a compilation error when using certain configuration by
> including the file io.h in kfd_doorbell.c
>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
> index 0dcb787..b5791a5 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
> @@ -23,6 +23,7 @@
>  #include <linux/mm.h>
>  #include <linux/mman.h>
>  #include <linux/slab.h>
> +#include <linux/io.h>
>
>  /*
>   * This extension supports a kernel level doorbells management for
> --
> 2.1.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
