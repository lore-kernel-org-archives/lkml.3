Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbaCTQgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:36:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34375 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481AbaCTQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:35:59 -0400
Date: Thu, 20 Mar 2014 17:35:53 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: sagar.a.kamble@intel.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, "G, Pallavi" <pallavi.g@intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v4 1/1] drm/i915: Enabling 128x128 and 256x256 ARGB
 Cursor Support
Message-ID: <20140320163553.GU30571@phenom.ffwll.local>
Mail-Followup-To: Imre Deak <imre.deak@intel.com>, sagar.a.kamble@intel.com,
	intel-gfx@lists.freedesktop.org, "G, Pallavi" <pallavi.g@intel.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20140310100321.GA30571@phenom.ffwll.local>
 <1394451383-27133-1-git-send-email-sagar.a.kamble@intel.com>
 <1395329443.17233.10.camel@intelbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395329443.17233.10.camel@intelbox>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 05:30:43PM +0200, Imre Deak wrote:
> On Mon, 2014-03-10 at 17:06 +0530, sagar.a.kamble@intel.com wrote:
> > From: Sagar Kamble <sagar.a.kamble@intel.com>
> > 
> > With this patch we allow larger cursor planes of sizes 128x128
> > and 256x256.
> > 
> > v2: Added more precise check on size while setting cursor plane.
> > 
> > v3: Changes related to restructuring cursor size restrictions
> > and DRM_DEBUG usage.
> > 
> > v4: Indentation related changes for setting cursor control and
> > implementing DRM_CAP_CURSOR_WIDTH and DRM_CAP_CURSOR_HEIGHT
> > 
> > Testcase: igt/kms_cursor_crc
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: G, Pallavi <pallavi.g@intel.com>
> > Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
> 
> Looks ok:
> Reviewed-by: Imre Deak <imre.deak@intel.com>

Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
