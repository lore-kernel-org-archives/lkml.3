Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098Ab3DJJhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:37:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:6493 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab3DJJhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:37:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,445,1363158000"; 
   d="scan'208";a="320216987"
From: Jani Nikula <jani.nikula@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>, Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.8.y] drm/i915: add quirk to invert brightness on eMachines e725
In-Reply-To: <1365561254.5814.44.camel@deadeye.wl.decadent.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20130409123833.GC32476@hansolo.jdub.homelinux.org> <87y5crpzct.fsf@intel.com> <20130409142230.GD32476@hansolo.jdub.homelinux.org> <1365561254.5814.44.camel@deadeye.wl.decadent.org.uk>
User-Agent: Notmuch/0.15.2+76~g76bbe24 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 10 Apr 2013 12:37:51 +0300
Message-ID: <87obdmpvyo.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Ben Hutchings <ben@decadent.org.uk> wrote:
> I cherry-picked the following series for Debian:
>
> [pre-3.8]
> 7bd90909bbf9 drm/i915: panel: invert brightness via parameter
> 4dca20efb1a9 drm/i915: panel: invert brightness via quirk
> 5a15ab5b93e4 drm/i915: panel: invert brightness acer aspire 5734z
> 5f85f176c2f1 DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
> [post-3.8]
> 1ffff6032087 drm/i915: add quirk to invert brightness on eMachines G725
> 01e3a8feb40e drm/i915: add quirk to invert brightness on eMachines e725
> 5559ecadad5a drm/i915: add quirk to invert brightness on Packard Bell NCL20
>
> Should these all be applied to the various 3.x.y stable branches?

Acked-by: Jani Nikula <jani.nikula@intel.com>
