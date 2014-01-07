Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaAGKVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:21:15 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:53569 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaAGKVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:21:13 -0500
MIME-Version: 1.0
In-Reply-To: <477dcfde0b9247c91030dedcbf71af7dafdb7bf4.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
	<477dcfde0b9247c91030dedcbf71af7dafdb7bf4.1389018325.git.rashika.kheria@gmail.com>
Date: Tue, 7 Jan 2014 11:21:12 +0100
Message-ID: <CADdNU4TUh-Xe=UpzT8=j5+VVi6pYGa4rPsrDCqrmCOuNfcJTRA@mail.gmail.com>
Subject: Re: [PATCH 82/85] drivers: gpu: Mark functions as static in vmwgfx_kms.c
From: Jakob Bornecrantz <wallbraker@gmail.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, josh@joshtriplett.org,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <rob@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 5:48 PM, Rashika Kheria <rashika.kheria@gmail.com> wrote:
> Mark functions as static because they are not used outside the file
> drm/vmwgfx/vmwgfx_kms.c.
>
> This eliminates the following warnings in drm/vmwgfx/vmwgfx_kms.c:
> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:43:6: warning: no previous prototype for ‘vmw_clip_cliprects’ [-Wmissing-prototypes]
> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:426:6: warning: no previous prototype for ‘vmw_framebuffer_surface_destroy’ [-Wmissing-prototypes]
> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:592:5: warning: no previous prototype for ‘vmw_framebuffer_surface_dirty’ [-Wmissing-prototypes]
> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:757:6: warning: no previous prototype for ‘vmw_framebuffer_dmabuf_destroy’ [-Wmissing-prototypes]
> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:943:5: warning: no previous prototype for ‘vmw_framebuffer_dmabuf_dirty’ [-Wmissing-prototypes]
> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:1666:5: warning: no previous prototype for ‘vmw_du_update_layout’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)


This and patch 83, 84, 85 are
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>

Cheers, Jakob.
