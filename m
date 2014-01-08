Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaAHMgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:36:14 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:46163 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755610AbaAHMgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:36:12 -0500
Message-ID: <52CD4637.8010805@vmware.com>
Date: Wed, 08 Jan 2014 13:36:07 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Jakob Bornecrantz <wallbraker@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <rob@ti.com>
Subject: Re: [PATCH 82/85] drivers: gpu: Mark functions as static in vmwgfx_kms.c
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com> <477dcfde0b9247c91030dedcbf71af7dafdb7bf4.1389018325.git.rashika.kheria@gmail.com> <CADdNU4TUh-Xe=UpzT8=j5+VVi6pYGa4rPsrDCqrmCOuNfcJTRA@mail.gmail.com> <20140107105154.GC4891@leaf>
In-Reply-To: <20140107105154.GC4891@leaf>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 11:51 AM, Josh Triplett wrote:
> On Tue, Jan 07, 2014 at 11:21:12AM +0100, Jakob Bornecrantz wrote:
>> On Mon, Jan 6, 2014 at 5:48 PM, Rashika Kheria <rashika.kheria@gmail.com> wrote:
>>> Mark functions as static because they are not used outside the file
>>> drm/vmwgfx/vmwgfx_kms.c.
>>>
>>> This eliminates the following warnings in drm/vmwgfx/vmwgfx_kms.c:
>>> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:43:6: warning: no previous prototype for ‘vmw_clip_cliprects’ [-Wmissing-prototypes]
>>> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:426:6: warning: no previous prototype for ‘vmw_framebuffer_surface_destroy’ [-Wmissing-prototypes]
>>> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:592:5: warning: no previous prototype for ‘vmw_framebuffer_surface_dirty’ [-Wmissing-prototypes]
>>> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:757:6: warning: no previous prototype for ‘vmw_framebuffer_dmabuf_destroy’ [-Wmissing-prototypes]
>>> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:943:5: warning: no previous prototype for ‘vmw_framebuffer_dmabuf_dirty’ [-Wmissing-prototypes]
>>> drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:1666:5: warning: no previous prototype for ‘vmw_du_update_layout’ [-Wmissing-prototypes]
>>>
>>> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>>> ---
>>>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |   12 ++++++------
>>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> This and patch 83, 84, 85 are
>> Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
> Can you take them through your tree, or are you expecting them to follow
> another path?

I'll take them through vmwgfx-next. However, patch 83/85 conflicts
heavily with an internal vmwgfx patch series. If applicable, I'll apply
it after resolving those conflicts.

Thanks,

/Thomas



>
> - Josh Triplett
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
