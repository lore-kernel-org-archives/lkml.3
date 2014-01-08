Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbaAHM2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:28:09 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:36286 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755684AbaAHM2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:28:06 -0500
Message-ID: <52CD4451.9010409@vmware.com>
Date: Wed, 08 Jan 2014 13:28:01 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        josh@joshtriplett.org, dri-devel@lists.freedesktop.org,
        Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 78/85] drivers: gpu: Mark function as static in ttm_bo.c
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com> <8e6973505071300c3d011272d5498597fd24a387.1389018325.git.rashika.kheria@gmail.com>
In-Reply-To: <8e6973505071300c3d011272d5498597fd24a387.1389018325.git.rashika.kheria@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 78-80/85
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>

Queued for ttm-next.
Thanks.

Thomas

On 01/06/2014 05:42 PM, Rashika Kheria wrote:
> Mark function as static because it is not used outside file
> drm/ttm/ttm_bo.c.
>
> This eliminates the following warning in drm/ttm/ttm_bo.c:
> drivers/gpu/drm/ttm/ttm_bo.c:960:5: warning: no previous prototype for ‘ttm_bo_move_buffer’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/gpu/drm/ttm/ttm_bo.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> index 07e02c4..a066513 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -957,7 +957,7 @@ int ttm_bo_mem_space(struct ttm_buffer_object *bo,
>  }
>  EXPORT_SYMBOL(ttm_bo_mem_space);
>  
> -int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
> +static int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
>  			struct ttm_placement *placement,
>  			bool interruptible,
>  			bool no_wait_gpu)
