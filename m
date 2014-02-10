Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBJNwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:52:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:6819 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaBJNwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:52:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,818,1384329600"; 
   d="scan'208";a="452787566"
Date: Mon, 10 Feb 2014 15:52:12 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: sagar.a.kamble@intel.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        vijay.a.purushothaman@intel.com, tomi.valkeinen@ti.com,
        dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org,
        joe@perches.com, airlied@redhat.com
Subject: Re: [PATCH v4 00/11] Enabling 180 degree rotation for sprite and
 crtc planes
Message-ID: <20140210135212.GN3891@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
 <20140210104130.7e7c3c93@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140210104130.7e7c3c93@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:41:30AM +0000, One Thousand Gnomes wrote:
> On Fri,  7 Feb 2014 19:15:05 +0530
> sagar.a.kamble@intel.com wrote:
> 
> > From: Sagar Kamble <sagar.a.kamble@intel.com>
> > 
> > These patches will enable 180 degree rotation for CRTC and Sprite planes.
> > Changelog:
> > 1. drm/i915: Add 180 degree primary plane rotation support
> > Addressed review comments for CRTC rotation from FBC, page flip, CRTC active/
> > inactive perspective.
> 
> Does this mean it should also handle horizontal mirroring in
> hardware (180° rotate, and scan lines backwards combined) ?

Our hardware doesn't support mirroring (h or v). Well, unless you
count h+v mirroring since that's 180 degree rotation :)

Anyways IIRC the old video overlay (present on gen2-4) was the only plane
to ever support mirroring on Intel hardware. With all other planes we're
limited to 0 and 180 degree rotation.

-- 
Ville Syrjälä
Intel OTC
