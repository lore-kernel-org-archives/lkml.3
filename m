Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3FFOAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:00:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:1961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3FFOAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:00:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,815,1363158000"; 
   d="scan'208";a="313226169"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: chris@chris-wilson.co.uk, daniel@ffwll.ch
Subject: Re: [PATCH 0/3]
In-Reply-To: <cover.1370525922.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1370525922.git.jani.nikula@intel.com>
User-Agent: Notmuch/0.15.2+173~g7bae869 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 06 Jun 2013 16:59:26 +0300
Message-ID: <87d2rzl4qp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With Greg's address fixed. Please drop the old one from any
replies. Sorry for the noise.

On Thu, 06 Jun 2013, Jani Nikula <jani.nikula@intel.com> wrote:
> Hi Greg, Andrew -
>
> Patch 1 is for DMI, bugfixes in patches 2-3 for i915 and included for
> completeness. After a tested-by they should be good for stable. I'll
> leave it to Daniel to sort out how the last two get in.
>
> BR,
> Jani.
>
> Chris Wilson (1):
>   drm/i915: Quirk away phantom LVDS on Intel's D510MO mainboard
>
> Jani Nikula (2):
>   dmi: add support for exact DMI matches in addition to substring
>     matching
>   drm/i915: Quirk away phantom LVDS on Intel's D525MW mainboard
>
>  drivers/firmware/dmi_scan.c       |   12 +++++++++---
>  drivers/gpu/drm/i915/intel_lvds.c |   16 ++++++++++++++++
>  include/linux/mod_devicetable.h   |    6 ++++--
>  3 files changed, 29 insertions(+), 5 deletions(-)
>
> -- 
> 1.7.9.5
>

-- 
Jani Nikula, Intel Open Source Technology Center
