Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3FFOeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:34:03 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42654 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3FFOeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:34:01 -0400
Date: Thu, 6 Jun 2013 16:33:55 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@intel.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, chris@chris-wilson.co.uk,
        daniel@ffwll.ch
Subject: Re: [PATCH 0/3]
Message-ID: <20130606143354.GH7827@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@intel.com>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, chris@chris-wilson.co.uk
References: <cover.1370525922.git.jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1370525922.git.jani.nikula@intel.com>
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 04:53:01PM +0300, Jani Nikula wrote:
> Hi Greg, Andrew -
> 
> Patch 1 is for DMI, bugfixes in patches 2-3 for i915 and included for
> completeness. After a tested-by they should be good for stable. I'll
> leave it to Daniel to sort out how the last two get in.

I'd prefer all to go through the same tree (to avoid tracking them), and
conflicts around lvds quirks will be trivial at most. So no problem for me
if this doesn't go in through drm-next. So

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

on the i915 patches for merging through whatever tree the drm stuff goes
through.
-Daniel

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
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
