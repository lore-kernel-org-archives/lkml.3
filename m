Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaISIi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:38:26 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:57083 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaISIhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:37:04 -0400
MIME-Version: 1.0
In-Reply-To: <1411114297-13910-2-git-send-email-kraxel@redhat.com>
References: <1411114297-13910-1-git-send-email-kraxel@redhat.com>
	<1411114297-13910-2-git-send-email-kraxel@redhat.com>
Date: Fri, 19 Sep 2014 10:37:03 +0200
Message-ID: <CANq1E4RUnO0VTSP++ONddAV1tiLOvQwGwxwzNZ3FvYnaObQdaA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cirrus: add missing drm_connector_register call
From: David Herrmann <dh.herrmann@gmail.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Sep 19, 2014 at 10:11 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/gpu/drm/cirrus/cirrus_mode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
> index e1c5c32..c7c5a9d 100644
> --- a/drivers/gpu/drm/cirrus/cirrus_mode.c
> +++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
> @@ -555,6 +555,7 @@ static struct drm_connector *cirrus_vga_init(struct drm_device *dev)
>
>         drm_connector_helper_add(connector, &cirrus_vga_connector_helper_funcs);
>
> +       drm_connector_register(connector);

Error checking?

And should probably include "Cc: <stable@vger.kernel.org> # v3.15+".

Thanks
David

>         return connector;
>  }
>
> --
> 1.8.3.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
