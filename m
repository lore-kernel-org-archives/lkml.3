Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaJ0SxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:53:00 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37533 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaJ0Sw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:52:58 -0400
Date: Mon, 27 Oct 2014 19:53:08 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        Thierry Reding <treding@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] MAINTAINERS: Add entry for MIPI DSI bus
Message-ID: <20141027185308.GS26941@phenom.ffwll.local>
Mail-Followup-To: Andrzej Hajda <a.hajda@samsung.com>,
	Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
	Thierry Reding <treding@nvidia.com>,
	open list <linux-kernel@vger.kernel.org>
References: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
 <1414403310-6316-2-git-send-email-a.hajda@samsung.com>
 <20141027141717.GN26941@phenom.ffwll.local>
 <544E62B5.8060603@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544E62B5.8060603@samsung.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 04:20:21PM +0100, Andrzej Hajda wrote:
> On 10/27/2014 03:17 PM, Daniel Vetter wrote:
> > On Mon, Oct 27, 2014 at 10:48:26AM +0100, Andrzej Hajda wrote:
> >> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >> ---
> >>  MAINTAINERS | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index dd31933..476679c 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -3071,6 +3071,13 @@ F:	drivers/gpu/vga/
> >>  F:	include/drm/
> >>  F:	include/uapi/drm/
> >>  
> >> +DRM MIPI DSI BUS
> >> +M:	Andrzej Hajda <a.hajda@samsung.com>
> >> +L:	dri-devel@lists.freedesktop.org
> >> +S:	Supported
> >> +F:	drivers/gpu/drm/drm_mipi_dsi.c
> >> +F:	include/drm/drm_mipi_dsi.h
> > 
> > I really prefer when common infrastructure like this doesn't get
> > maintainer by a vendor. And I care with my intel hat on since we also ahve
> > a dsi driver that sooner or later needs to be converted to to this stuff.
> > 
> > Why doesn't the usual model of merging stuff through Dave's tree, or if
> > that doesn't work well due to patch depencies, through vendor trees with
> > Dave's ack?
> 
> The main intention of this patch is to be on CC in case of patches
> touching MIPI DSI bus.
> I do not want to create separate tree for such small subsystem.
> 
> So if such things are not allowed please drop the patch and sorry for
> the noise.

For that stuff you can just create a mail filter that shovels everything
touching anything dsi related on dri-devel (people arleady should send all
stuff there anyway) into a special folder/mark it as important. If you
rely on people to always use get_maintainers.pl that won't work properly
anyway.

So if all you want is to notice all dsi related patches then adding a
maintainer entry isn't a good solution anyway. So best to drop this one.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
