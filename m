Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaAGKwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:52:06 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44258 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaAGKwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:52:04 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 7 Jan 2014 02:51:54 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Jakob Bornecrantz <wallbraker@gmail.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <rob@ti.com>
Subject: Re: [PATCH 82/85] drivers: gpu: Mark functions as static in
 vmwgfx_kms.c
Message-ID: <20140107105154.GC4891@leaf>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
 <477dcfde0b9247c91030dedcbf71af7dafdb7bf4.1389018325.git.rashika.kheria@gmail.com>
 <CADdNU4TUh-Xe=UpzT8=j5+VVi6pYGa4rPsrDCqrmCOuNfcJTRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADdNU4TUh-Xe=UpzT8=j5+VVi6pYGa4rPsrDCqrmCOuNfcJTRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:21:12AM +0100, Jakob Bornecrantz wrote:
> On Mon, Jan 6, 2014 at 5:48 PM, Rashika Kheria <rashika.kheria@gmail.com> wrote:
> > Mark functions as static because they are not used outside the file
> > drm/vmwgfx/vmwgfx_kms.c.
> >
> > This eliminates the following warnings in drm/vmwgfx/vmwgfx_kms.c:
> > drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:43:6: warning: no previous prototype for ‘vmw_clip_cliprects’ [-Wmissing-prototypes]
> > drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:426:6: warning: no previous prototype for ‘vmw_framebuffer_surface_destroy’ [-Wmissing-prototypes]
> > drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:592:5: warning: no previous prototype for ‘vmw_framebuffer_surface_dirty’ [-Wmissing-prototypes]
> > drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:757:6: warning: no previous prototype for ‘vmw_framebuffer_dmabuf_destroy’ [-Wmissing-prototypes]
> > drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:943:5: warning: no previous prototype for ‘vmw_framebuffer_dmabuf_dirty’ [-Wmissing-prototypes]
> > drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:1666:5: warning: no previous prototype for ‘vmw_du_update_layout’ [-Wmissing-prototypes]
> >
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> >  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |   12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> 
> This and patch 83, 84, 85 are
> Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>

Can you take them through your tree, or are you expecting them to follow
another path?

- Josh Triplett
